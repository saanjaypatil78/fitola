import hashlib
import json
import logging
import os
import re
from contextlib import asynccontextmanager
from datetime import datetime, timezone
from typing import Any, Dict, List, Optional
from urllib.parse import urlparse

import httpx
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Query, Request
from fastapi.middleware.cors import CORSMiddleware
from google import genai
from pydantic import BaseModel, EmailStr, Field

load_dotenv()
logger = logging.getLogger(__name__)

# Initialize Gemini Client
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
GEMINI_MODEL = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")
client = genai.Client(api_key=GEMINI_API_KEY) if GEMINI_API_KEY else None
RUBE_MCP_BASE_URL = os.getenv("RUBE_MCP_BASE_URL", "https://rube.app")
RUBE_MCP_VALIDATED_BASE_URL: Optional[str] = None
RUBE_HTTP_CLIENT: Optional[httpx.AsyncClient] = None
RUBE_HTTP_TIMEOUT: Optional[float] = None


def parse_rube_timeout() -> float:
    raw_timeout = os.getenv("RUBE_MCP_TIMEOUT", "10")
    try:
        timeout = float(raw_timeout)
    except ValueError:
        raise ValueError(
            f"RUBE_MCP_TIMEOUT must be a valid number (got '{raw_timeout}')."
        )
    if timeout <= 0:
        raise ValueError(
            f"RUBE_MCP_TIMEOUT must be a positive number (got '{raw_timeout}')."
        )
    return timeout


# =============================================================================
# Request/Response Models
# =============================================================================


class ChatRequest(BaseModel):
    message: str
    language: Optional[str] = None


class PlanRequest(BaseModel):
    age: int = Field(ge=1, le=120)
    height_cm: float = Field(ge=1, le=300)
    weight_kg: float = Field(ge=1, le=500)
    body_type: str
    goal: str
    duration_weeks: int = 4
    preferences: Optional[str] = None
    language: Optional[str] = None


class TranslationRequest(BaseModel):
    text: str
    source_language: str
    target_language: str


def require_gemini() -> genai.Client:
    if not GEMINI_API_KEY:
        raise HTTPException(
            status_code=500,
            detail="GEMINI_API_KEY is not configured. Please set GEMINI_API_KEY.",
        )
    if client is None:
        raise HTTPException(
            status_code=500,
            detail="Gemini client failed to initialize. Verify GEMINI_API_KEY.",
        )
    return client


def require_rube_token() -> str:
    token = os.getenv("RUBE_MCP_JWT")
    if not token:
        raise HTTPException(
            status_code=500,
            detail="RUBE_MCP_JWT is not configured. Please set RUBE_MCP_JWT.",
        )
    return token


def validate_rube_base_url() -> str:
    url = RUBE_MCP_BASE_URL.strip()
    if not url:
        raise ValueError("RUBE_MCP_BASE_URL must be set.")
    parsed = urlparse(url)
    if parsed.scheme != "https" or not parsed.netloc:
        raise ValueError("RUBE_MCP_BASE_URL must be a valid https URL.")
    return url.rstrip("/")


async def get_rube_http_client() -> httpx.AsyncClient:
    global RUBE_HTTP_CLIENT
    if RUBE_HTTP_TIMEOUT is None:
        raise RuntimeError("Rube MCP timeout is not initialized.")
    if RUBE_HTTP_CLIENT is None:
        RUBE_HTTP_CLIENT = httpx.AsyncClient(timeout=RUBE_HTTP_TIMEOUT)
    return RUBE_HTTP_CLIENT


@asynccontextmanager
async def lifespan(app: FastAPI):
    global RUBE_MCP_VALIDATED_BASE_URL, RUBE_HTTP_TIMEOUT
    try:
        RUBE_MCP_VALIDATED_BASE_URL = validate_rube_base_url()
        RUBE_HTTP_TIMEOUT = parse_rube_timeout()
        await get_rube_http_client()
    except ValueError as exc:
        logger.error("Rube MCP configuration error: %s", exc)
        raise RuntimeError(f"Rube MCP configuration error: {exc}") from exc
    try:
        yield
    finally:
        await close_rube_http_client()


async def close_rube_http_client() -> None:
    global RUBE_HTTP_CLIENT
    if RUBE_HTTP_CLIENT is not None:
        await RUBE_HTTP_CLIENT.aclose()
        RUBE_HTTP_CLIENT = None


app = FastAPI(
    title="Fitola Backend API",
    description="AI-Powered Personal Fitness & Social Wellness Platform",
    version="1.0.0",
    lifespan=lifespan,
)

# CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


async def fetch_rube_json(
    url: str, token: str, params: Optional[Dict[str, Any]] = None
) -> dict:
    """Fetch JSON payloads from the Rube MCP API with Bearer auth."""
    try:
        http_client = await get_rube_http_client()
        response = await http_client.get(
            url,
            params=params,
            headers={"Authorization": f"Bearer {token}", "Accept": "application/json"},
        )
        response.raise_for_status()
    except httpx.HTTPStatusError as exc:
        raise HTTPException(
            status_code=exc.response.status_code,
            detail=f"Rube MCP request failed with status {exc.response.status_code}.",
        )
    except httpx.RequestError as exc:
        raise HTTPException(status_code=502, detail=f"Rube MCP request failed: {exc}")

    try:
        return response.json()
    except json.JSONDecodeError:
        raise HTTPException(
            status_code=502, detail="Invalid JSON returned from Rube MCP."
        )


def get_language_instruction(language: Optional[str]) -> str:
    if not language:
        return ""
    return f"Respond in {language}."


def parse_json_response(text: str) -> Optional[dict]:
    cleaned = text.strip()
    if cleaned.startswith("```"):
        cleaned = re.sub(r"^```(?:json)?\n", "", cleaned)
        cleaned = re.sub(r"\n```$", "", cleaned)
    try:
        return json.loads(cleaned)
    except json.JSONDecodeError:
        logger.warning(
            "Failed to parse Gemini JSON response (length=%s).", len(cleaned)
        )
        return None


def sanitize_prompt_value(value: Optional[str], max_length: int = 200) -> str:
    if not value:
        return "None"
    cleaned = " ".join(value.split())
    if len(cleaned) <= max_length:
        return cleaned
    truncated_length = max(max_length - 3, 0)
    return f"{cleaned[:truncated_length].rstrip()}..."


def sanitize_language_identifier(value: str, max_length: int = 40) -> str:
    cleaned = sanitize_prompt_value(value, max_length=max_length)
    cleaned = re.sub(r"[^a-zA-Z0-9\-_]", "", cleaned).strip()
    return cleaned or "unknown"


class UserRegister(BaseModel):
    id: str
    email: EmailStr
    name: str


class UserProfile(BaseModel):
    name: Optional[str] = None
    weight: Optional[float] = None
    height: Optional[float] = None
    age_group: Optional[str] = None
    body_type: Optional[str] = None
    goals: Optional[List[str]] = None
    city: Optional[str] = None
    allergies: Optional[List[str]] = None


class BMIRequest(BaseModel):
    weight: float
    height: float


class FitnessRequest(BaseModel):
    user_id: str
    age_group: str
    weight: float
    height: float
    body_type: str
    goals: List[str]
    duration_days: int = 30


class NutritionRequest(BaseModel):
    user_id: str
    age_group: str
    weight: float
    height: float
    body_type: str
    goals: List[str]
    city: str
    allergies: Optional[List[str]] = None
    duration_days: int = 7


class TranslateRequest(BaseModel):
    message: str
    target_language: str


class LocationUpdate(BaseModel):
    user_id: str
    latitude: float
    longitude: float
    timestamp: str


class LocationShare(BaseModel):
    user_id: str
    target_user_id: str
    duration_seconds: int


class ChatMessageRequest(BaseModel):
    sender_id: str
    receiver_id: str
    message: str
    type: str = "text"
    file_url: Optional[str] = None


class SessionCompletionRequest(BaseModel):
    user_id: str
    workout_minutes: int = Field(ge=5, le=360)
    intensity: str = Field(default="moderate")
    shared_progress: bool = False


class RewardClaimRequest(BaseModel):
    user_id: str
    amount_fitcoins: int = Field(gt=0, le=10000)


class VipUpgradeQuoteRequest(BaseModel):
    current_level: int = Field(ge=1, le=999)
    target_level: int = Field(ge=1, le=999)


class TrophyUnboxRequest(BaseModel):
    user_id: str
    vip_level: int = Field(ge=1, le=999)
    box_type: str = Field(default="standard")
    client_seed: str
    nonce: int = Field(ge=0)


class VaultSaveRequest(BaseModel):
    user_id: str
    item_id: str
    metadata: Optional[Dict[str, Any]] = None


# =============================================================================
# Health Check
# =============================================================================


@app.get("/")
async def root():
    return {"message": "Fitola API is running", "version": "1.0.0", "status": "healthy"}


@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "fitola-backend"}


# =============================================================================
# Authentication Endpoints
# =============================================================================


@app.post("/api/v1/auth/register")
async def register_user(user: UserRegister):
    """Register a new user in the system."""
    return {
        "user": {
            "id": user.id,
            "email": user.email,
            "name": user.name,
            "created_at": "2026-02-01T12:00:00Z",
        },
        "message": "User registered successfully",
    }


@app.post("/api/v1/auth/login")
async def login_user(email: EmailStr, password: str):
    """Login user with email and password."""
    return {
        "user": {"id": "sample-user-id", "email": email, "name": "Sample User"},
        "token": "sample-jwt-token",
        "message": "Login successful",
    }


# =============================================================================
# User Profile Endpoints
# =============================================================================


@app.get("/api/v1/user/profile/{user_id}")
async def get_user_profile(user_id: str):
    """Get user profile by ID."""
    return {
        "id": user_id,
        "name": "John Doe",
        "email": "john@example.com",
        "age_group": "Adult",
        "weight": 75.0,
        "height": 180.0,
        "body_type": "Mesomorph",
        "goals": ["Weight Loss", "Muscle Gain"],
        "city": "New York",
    }


@app.put("/api/v1/user/profile")
async def update_user_profile(profile: UserProfile):
    """Update user profile."""
    return {
        "message": "Profile updated successfully",
        "profile": profile.dict(exclude_none=True),
    }


@app.post("/api/v1/user/bmi")
async def calculate_bmi(request: BMIRequest):
    """Calculate BMI and return category."""
    bmi = request.weight / ((request.height / 100) ** 2)

    if bmi < 18.5:
        category = "Underweight"
    elif bmi < 25.0:
        category = "Normal"
    elif bmi < 30.0:
        category = "Overweight"
    else:
        category = "Obese"

    return {
        "bmi": round(bmi, 1),
        "category": category,
        "healthy_range": {
            "min": 18.5,
            "max": 24.9,
            "min_weight": round(18.5 * ((request.height / 100) ** 2), 1),
            "max_weight": round(24.9 * ((request.height / 100) ** 2), 1),
        },
    }


# =============================================================================
# AI & Chat Endpoints
# =============================================================================


@app.post("/api/v1/chat")
async def chat_with_ai(request: ChatRequest):
    """Chat with Gemini AI for fitness advice."""
    try:
        gemini_client = require_gemini()
        language_instruction = get_language_instruction(request.language)
        message = request.message
        if language_instruction:
            message = f"{language_instruction}\n\n{request.message}"
        response = gemini_client.models.generate_content(
            model=GEMINI_MODEL, contents=message
        )
        return {"response": response.text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/v1/plans/ai/fitness")
async def generate_fitness_plan(request: FitnessRequest):
    """Generate personalized fitness plan using AI."""
    try:
        prompt = f"""
        Create a personalized {request.duration_days}-day fitness plan for:
        - Age Group: {request.age_group}
        - Weight: {request.weight}kg, Height: {request.height}cm
        - Body Type: {request.body_type}
        - Goals: {', '.join(request.goals)}
        
        Provide a structured workout plan with exercises, sets, reps, and rest days.
        """

        response = client.models.generate_content(
            model="gemini-2.0-flash", contents=prompt
        )

        return {
            "id": f"plan-{request.user_id}",
            "user_id": request.user_id,
            "title": f"{request.duration_days}-Day {request.goals[0]} Plan",
            "description": "AI-generated personalized fitness plan",
            "type": request.goals[0].replace(" ", ""),
            "difficulty": "Intermediate",
            "duration_days": request.duration_days,
            "ai_generated": True,
            "plan_details": response.text,
            "created_at": "2026-02-01T12:00:00Z",
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/v1/plans/ai/nutrition")
async def generate_nutrition_plan(request: NutritionRequest):
    """Generate personalized nutrition plan using AI."""
    try:
        allergies_str = (
            f"Allergies: {', '.join(request.allergies)}" if request.allergies else ""
        )

        prompt = f"""
        Create a personalized {request.duration_days}-day nutrition plan for:
        - Age Group: {request.age_group}
        - Weight: {request.weight}kg, Height: {request.height}cm
        - Body Type: {request.body_type}
        - Goals: {', '.join(request.goals)}
        - City: {request.city} (use local ingredients)
        {allergies_str}
        
        Provide meal plans with breakfast, lunch, dinner, and snacks.
        Include calorie counts and macronutrient breakdown.
        """

        response = client.models.generate_content(
            model="gemini-2.0-flash", contents=prompt
        )

        # Calculate daily calories based on goals
        bmr = 10 * request.weight + 6.25 * request.height - 5 * 30  # Simplified
        daily_calories = int(bmr * 1.5)  # Activity factor

        return {
            "id": f"nutrition-{request.user_id}",
            "user_id": request.user_id,
            "title": f"{request.duration_days}-Day Nutrition Plan",
            "description": "AI-generated personalized nutrition plan",
            "daily_calories": daily_calories,
            "macros": {"protein": 150, "carbs": 200, "fats": 60},
            "duration_days": request.duration_days,
            "ai_generated": True,
            "plan_details": response.text,
            "created_at": "2026-02-01T12:00:00Z",
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# =============================================================================
# Chat Endpoints
# =============================================================================


@app.post("/api/v1/chat/message")
async def send_message(message: ChatMessageRequest):
    """Send a chat message."""
    return {
        "id": f"msg-{message.sender_id}",
        "sender_id": message.sender_id,
        "receiver_id": message.receiver_id,
        "message": message.message,
        "type": message.type,
        "timestamp": "2026-02-01T12:00:00Z",
        "is_read": False,
    }


@app.get("/api/v1/chat/conversation/{user_id}/{other_user_id}")
async def get_conversation(user_id: str, other_user_id: str):
    """Get conversation between two users."""
    return {
        "messages": [
            {
                "id": "msg-1",
                "sender_id": user_id,
                "receiver_id": other_user_id,
                "message": "Hello!",
                "type": "text",
                "timestamp": "2026-02-01T12:00:00Z",
                "is_read": True,
            },
            {
                "id": "msg-2",
                "sender_id": other_user_id,
                "receiver_id": user_id,
                "message": "Hi there!",
                "type": "text",
                "timestamp": "2026-02-01T12:01:00Z",
                "is_read": False,
            },
        ]
    }


@app.get("/api/v1/chat/conversations/{user_id}")
async def get_conversations(user_id: str):
    """Get all conversations for a user."""
    return {
        "conversations": [
            {
                "id": "conv-1",
                "other_user": {"id": "user-2", "name": "Jane Doe", "photo_url": None},
                "last_message": "Hello!",
                "last_message_time": "2026-02-01T12:00:00Z",
                "unread_count": 2,
            }
        ]
    }


@app.post("/api/v1/chat/translate")
async def translate_message(request: TranslateRequest):
    """Translate a message to target language."""
    return {
        "original_message": request.message,
        "translated_message": f"[{request.target_language}] {request.message}",
        "target_language": request.target_language,
    }


@app.post("/api/v1/chat/request")
async def send_chat_request(from_user_id: str, to_user_id: str):
    """Send a chat request to another user."""
    return {
        "request_id": f"req-{from_user_id}-{to_user_id}",
        "from_user_id": from_user_id,
        "to_user_id": to_user_id,
        "status": "pending",
        "created_at": "2026-02-01T12:00:00Z",
    }


@app.put("/api/v1/chat/request/{request_id}/accept")
async def accept_chat_request(request_id: str):
    """Accept a chat request."""
    return {
        "request_id": request_id,
        "status": "accepted",
        "message": "Chat request accepted",
    }


# =============================================================================
# Map & Location Endpoints
# =============================================================================


@app.get("/api/v1/map/nearby")
async def get_nearby_fitbuddies(
    latitude: float = Query(...),
    longitude: float = Query(...),
    radius: int = Query(5, description="Radius in kilometers"),
    status: Optional[str] = Query(None),
):
    """Get nearby FitBuddies."""
    # Mock data for demonstration
    users = [
        {
            "id": "user-2",
            "name": "Jane Doe",
            "gender": "Female",
            "latitude": latitude + 0.01,
            "longitude": longitude + 0.01,
            "distance": 1.2,
            "status": "available",
            "photo_url": None,
            "bio": "Love yoga and running!",
        },
        {
            "id": "user-3",
            "name": "John Smith",
            "gender": "Male",
            "latitude": latitude - 0.02,
            "longitude": longitude + 0.02,
            "distance": 2.5,
            "status": "available",
            "photo_url": None,
            "bio": "Gym enthusiast",
        },
    ]

    if status:
        users = [u for u in users if u["status"] == status]

    return {"users": users, "total": len(users)}


@app.post("/api/v1/location/update")
async def update_location(location: LocationUpdate):
    """Update user location."""
    return {
        "user_id": location.user_id,
        "latitude": location.latitude,
        "longitude": location.longitude,
        "updated_at": location.timestamp,
        "message": "Location updated successfully",
    }


@app.post("/api/v1/location/share")
async def share_location(share: LocationShare):
    """Share live location with another user."""
    return {
        "user_id": share.user_id,
        "target_user_id": share.target_user_id,
        "duration_seconds": share.duration_seconds,
        "expires_at": "2026-02-01T13:00:00Z",
        "message": "Location sharing started",
    }


@app.delete("/api/v1/location/share/{user_id}/{target_user_id}")
async def stop_location_sharing(user_id: str, target_user_id: str):
    """Stop sharing location."""
    return {
        "message": "Location sharing stopped",
        "user_id": user_id,
        "target_user_id": target_user_id,
    }




def _normalize_intensity_multiplier(intensity: str) -> float:
    intensity_map = {
        "light": 1.0,
        "moderate": 1.2,
        "intense": 1.5,
    }
    return intensity_map.get(intensity.lower(), 1.0)


def _build_economy_profile(user_id: str) -> dict:
    # F2P: keep progression available to all users via FitCoins + XP + missions.
    # P2E: allow optional reward claims backed by anti-abuse checks and thresholds.
    return {
        "user_id": user_id,
        "model": {
            "f2p": {
                "enabled": True,
                "core_loops": [
                    "daily workout missions",
                    "streak multipliers",
                    "social challenge bonuses",
                ],
                "soft_currency": "fitcoins",
            },
            "p2e": {
                "enabled": True,
                "claim_window": "weekly",
                "minimum_claim_fitcoins": 500,
                "anti_cheat": [
                    "device anomaly checks",
                    "session duration validation",
                    "streak fraud detection",
                ],
            },
        },
        "wallet": {
            "fitcoins": 1240,
            "xp": 9320,
            "season_level": 18,
            "eligible_to_claim": True,
        },
        "progression": {
            "daily_missions_completed": 2,
            "weekly_target": 5,
            "active_streak_days": 12,
        },
    }


@app.get("/api/v1/economy/profile/{user_id}")
async def get_economy_profile(user_id: str):
    """Return blended F2P + P2E economy state for a user."""
    return _build_economy_profile(user_id)


@app.post("/api/v1/economy/session-complete")
async def complete_economy_session(payload: SessionCompletionRequest):
    """Award F2P progression and calculate P2E claimable credits for a session."""
    intensity_multiplier = _normalize_intensity_multiplier(payload.intensity)
    base_fitcoins = max(10, int(payload.workout_minutes * 0.8))
    social_bonus = 25 if payload.shared_progress else 0
    earned_fitcoins = int(base_fitcoins * intensity_multiplier) + social_bonus
    earned_xp = int(payload.workout_minutes * 4 * intensity_multiplier)

    return {
        "user_id": payload.user_id,
        "session": {
            "workout_minutes": payload.workout_minutes,
            "intensity": payload.intensity,
            "shared_progress": payload.shared_progress,
        },
        "f2p_rewards": {
            "earned_fitcoins": earned_fitcoins,
            "earned_xp": earned_xp,
            "streak_bonus_applied": payload.workout_minutes >= 30,
        },
        "p2e_projection": {
            "claimable_fitcoins": int(earned_fitcoins * 0.3),
            "claim_window": "weekly",
            "status": "pending_verification",
        },
    }


@app.post("/api/v1/economy/claim")
async def claim_p2e_rewards(payload: RewardClaimRequest):
    """Claim P2E rewards if the minimum threshold is met."""
    minimum_claim = 500
    if payload.amount_fitcoins < minimum_claim:
        raise HTTPException(
            status_code=400,
            detail=f"Minimum claim is {minimum_claim} FitCoins for P2E withdrawals.",
        )

    return {
        "user_id": payload.user_id,
        "claimed_fitcoins": payload.amount_fitcoins,
        "status": "queued",
        "eta": "24h",
        "message": "P2E claim request queued for anti-cheat verification.",
    }


VIP_BASE_COST = 100
VIP_GROWTH_MULTIPLIER = 1.5
VIP_MAX_LEVEL = 999
GAME_VAULT: Dict[str, List[Dict[str, Any]]] = {}


def _vip_level_cost(level: int) -> int:
    # Level 1 costs base cost, every next level costs 50% more than previous.
    level = max(1, min(level, VIP_MAX_LEVEL))
    return int(round(VIP_BASE_COST * (VIP_GROWTH_MULTIPLIER ** (level - 1))))


def _vip_cumulative_cost(start_level: int, end_level: int) -> int:
    if end_level <= start_level:
        return 0
    return sum(_vip_level_cost(level) for level in range(start_level + 1, end_level + 1))


def _fixed_perks_for_level(level: int) -> List[str]:
    fixed = [
        "Priority support lane",
        "Advanced body analytics",
        "Premium streak boosts",
    ]
    if level >= 99:
        fixed.append("AGI Master Physician Preview")
    if level >= 999:
        fixed.append("AGI Master Physician Full Interface")
    return fixed


def _hash_roll(server_seed: str, client_seed: str, nonce: int) -> Dict[str, Any]:
    payload = f"{server_seed}:{client_seed}:{nonce}"
    digest = hashlib.sha256(payload.encode("utf-8")).hexdigest()
    roll = int(digest[:8], 16) / 0xFFFFFFFF
    return {"digest": digest, "roll": roll}


def _randomized_trophy(roll: float) -> Dict[str, Any]:
    if roll < 0.01:
        return {"rarity": "mythic", "reward": "AGI relic shard", "perk_points": 100}
    if roll < 0.1:
        return {"rarity": "legendary", "reward": "Platinum recovery module", "perk_points": 40}
    if roll < 0.35:
        return {"rarity": "epic", "reward": "Elite nutrition script", "perk_points": 20}
    return {"rarity": "rare", "reward": "Boost capsule", "perk_points": 8}


@app.get("/api/v1/vip/level-window/{current_level}")
async def get_vip_level_window(current_level: int):
    """Return VIP screen data centered around user level with previous/next 5 levels."""
    level = max(1, min(current_level, VIP_MAX_LEVEL))
    start = max(1, level - 5)
    end = min(VIP_MAX_LEVEL, level + 5)

    levels = []
    for lv in range(start, end + 1):
        levels.append(
            {
                "level": lv,
                "cost": _vip_level_cost(lv),
                "fixed_perks": _fixed_perks_for_level(lv),
                "randomized_perks_enabled": lv >= 5,
            }
        )

    return {"current_level": level, "window": levels}


@app.post("/api/v1/vip/upgrade-quote")
async def vip_upgrade_quote(payload: VipUpgradeQuoteRequest):
    """Quote upgrade pricing where each next VIP level costs 50% more than previous."""
    start = payload.current_level
    target = payload.target_level
    if target <= start:
        raise HTTPException(status_code=400, detail="target_level must be greater than current_level")

    return {
        "current_level": start,
        "target_level": target,
        "total_upgrade_cost": _vip_cumulative_cost(start, target),
        "next_level_cost": _vip_level_cost(start + 1),
        "pricing_model": "geometric_1.5x",
    }


@app.post("/api/v1/vault/trophy/unbox")
async def unbox_trophy(payload: TrophyUnboxRequest):
    """Provably fair hash-based unboxing result for trophy rewards."""
    server_seed = os.getenv("VAULT_SERVER_SEED", "fitola-default-server-seed")
    roll_data = _hash_roll(server_seed, payload.client_seed, payload.nonce)
    randomized = _randomized_trophy(roll_data["roll"])

    result = {
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "vip_level": payload.vip_level,
        "box_type": payload.box_type,
        "provably_fair": {
            "hash": roll_data["digest"],
            "roll": round(roll_data["roll"], 8),
            "client_seed": payload.client_seed,
            "nonce": payload.nonce,
        },
        "fixed_perks": _fixed_perks_for_level(payload.vip_level),
        "randomized_reward": randomized,
    }

    GAME_VAULT.setdefault(payload.user_id, []).append(result)
    return result


@app.get("/api/v1/vault/{user_id}")
async def get_game_vault(user_id: str):
    """Return saved game vault entries for the user."""
    return {"user_id": user_id, "entries": GAME_VAULT.get(user_id, [])}


@app.post("/api/v1/vault/save")
async def save_to_game_vault(payload: VaultSaveRequest):
    """Persist custom reward/perk entries in game vault."""
    entry = {
        "item_id": payload.item_id,
        "metadata": payload.metadata or {},
        "saved_at": datetime.now(timezone.utc).isoformat(),
    }
    GAME_VAULT.setdefault(payload.user_id, []).append(entry)
    return {"message": "Saved to Game Vault", "entry": entry}



# =============================================================================
# Leaderboard Endpoints
# =============================================================================


@app.get("/api/v1/leaderboard/global")
async def get_global_leaderboard(
    limit: int = Query(100, le=100), offset: int = Query(0)
):
    """Get global leaderboard."""
    leaderboard = [
        {
            "rank": i + 1,
            "user_id": f"user-{i}",
            "name": f"User {i}",
            "score": 1500 - (i * 10),
            "streak_days": 30 - i,
            "country": "USA",
        }
        for i in range(limit)
    ]
    return {"leaderboard": leaderboard, "total": 1000}


@app.get("/api/v1/leaderboard/national/{country}")
async def get_national_leaderboard(country: str):
    """Get national leaderboard."""
    leaderboard = [
        {
            "rank": i + 1,
            "user_id": f"user-{i}",
            "name": f"User {i}",
            "score": 1500 - (i * 10),
            "streak_days": 30 - i,
            "country": country,
        }
        for i in range(10)
    ]
    return {"leaderboard": leaderboard, "country": country, "total": 100}


@app.get("/api/v1/leaderboard/friends/{user_id}")
async def get_friends_leaderboard(user_id: str):
    """Get friends leaderboard."""
    leaderboard = [
        {
            "rank": 1,
            "user_id": user_id,
            "name": "You",
            "score": 1200,
            "streak_days": 25,
        },
        {
            "rank": 2,
            "user_id": "friend-1",
            "name": "Friend 1",
            "score": 1100,
            "streak_days": 20,
        },
    ]
    return {"leaderboard": leaderboard, "total": 2}


@app.post("/api/v1/plans/ai")
async def ai_plans_generate(request: PlanRequest):
    try:
        gemini_client = require_gemini()
        language_note = get_language_instruction(request.language)
        body_type = sanitize_prompt_value(request.body_type)
        goal = sanitize_prompt_value(request.goal)
        preferences = sanitize_prompt_value(request.preferences)
        # Expected JSON keys: workout_plan, diet_plan, rationale
        prompt = (
            "Create a weekly workout plan and diet plan as JSON with keys "
            "`workout_plan`, `diet_plan`, and `rationale`.\n"
            f"Age: {request.age}\n"
            f"Height (cm): {request.height_cm}\n"
            f"Weight (kg): {request.weight_kg}\n"
            f"Body Type: {body_type}\n"
            f"Goal: {goal}\n"
            f"Duration (weeks): {request.duration_weeks}\n"
            f"Preferences: {preferences}\n"
            f"{language_note}"
        )
        response = gemini_client.models.generate_content(
            model=GEMINI_MODEL, contents=prompt
        )
        parsed_plan = parse_json_response(response.text)
        return {
            "plan_json": parsed_plan,
            "plan_text": response.text,
            "plan_format": "json" if parsed_plan else "text",
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/v1/translate")
async def translate_text(request: TranslationRequest):
    try:
        gemini_client = require_gemini()
        source_language = sanitize_language_identifier(request.source_language)
        target_language = sanitize_language_identifier(request.target_language)
        prompt = (
            "Translate the following text from "
            f"{source_language} to {target_language}. "
            "Return only the translated text.\n\n"
            f"{request.text}"
        )
        response = gemini_client.models.generate_content(
            model=GEMINI_MODEL, contents=prompt
        )
        return {"translation": response.text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/v1/rube/recipe-hub/discover")
async def rube_recipe_discover(request: Request):
    token = require_rube_token()
    params = dict(request.query_params)
    url = f"{RUBE_MCP_VALIDATED_BASE_URL}/recipe-hub/discover"
    return await fetch_rube_json(url, token, params=params)


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
