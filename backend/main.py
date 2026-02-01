import os
from typing import List, Optional
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, EmailStr
from google import genai
from dotenv import load_dotenv
import math

load_dotenv()

app = FastAPI(
    title="Fitola Backend API",
    description="AI-Powered Personal Fitness & Social Wellness Platform",
    version="1.0.0"
)

# CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize Gemini Client
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
client = genai.Client(api_key=GEMINI_API_KEY)

# =============================================================================
# Request/Response Models
# =============================================================================

class ChatRequest(BaseModel):
    message: str
    context: Optional[str] = None

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

# =============================================================================
# Health Check
# =============================================================================

@app.get("/")
async def root():
    return {
        "message": "Fitola API is running",
        "version": "1.0.0",
        "status": "healthy"
    }

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
            "created_at": "2026-02-01T12:00:00Z"
        },
        "message": "User registered successfully"
    }

@app.post("/api/v1/auth/login")
async def login_user(email: EmailStr, password: str):
    """Login user with email and password."""
    return {
        "user": {
            "id": "sample-user-id",
            "email": email,
            "name": "Sample User"
        },
        "token": "sample-jwt-token",
        "message": "Login successful"
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
        "city": "New York"
    }

@app.put("/api/v1/user/profile")
async def update_user_profile(profile: UserProfile):
    """Update user profile."""
    return {
        "message": "Profile updated successfully",
        "profile": profile.dict(exclude_none=True)
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
            "max_weight": round(24.9 * ((request.height / 100) ** 2), 1)
        }
    }

# =============================================================================
# AI & Chat Endpoints
# =============================================================================

@app.post("/api/v1/chat")
async def chat_with_ai(request: ChatRequest):
    """Chat with Gemini AI for fitness advice."""
    try:
        prompt = request.message
        if request.context:
            prompt = f"Context: {request.context}\n\nUser: {request.message}"
        
        response = client.models.generate_content(
            model="gemini-2.0-flash",
            contents=prompt
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
            model="gemini-2.0-flash",
            contents=prompt
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
            "created_at": "2026-02-01T12:00:00Z"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/api/v1/plans/ai/nutrition")
async def generate_nutrition_plan(request: NutritionRequest):
    """Generate personalized nutrition plan using AI."""
    try:
        allergies_str = f"Allergies: {', '.join(request.allergies)}" if request.allergies else ""
        
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
            model="gemini-2.0-flash",
            contents=prompt
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
            "macros": {
                "protein": 150,
                "carbs": 200,
                "fats": 60
            },
            "duration_days": request.duration_days,
            "ai_generated": True,
            "plan_details": response.text,
            "created_at": "2026-02-01T12:00:00Z"
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
        "is_read": False
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
                "is_read": True
            },
            {
                "id": "msg-2",
                "sender_id": other_user_id,
                "receiver_id": user_id,
                "message": "Hi there!",
                "type": "text",
                "timestamp": "2026-02-01T12:01:00Z",
                "is_read": False
            }
        ]
    }

@app.get("/api/v1/chat/conversations/{user_id}")
async def get_conversations(user_id: str):
    """Get all conversations for a user."""
    return {
        "conversations": [
            {
                "id": "conv-1",
                "other_user": {
                    "id": "user-2",
                    "name": "Jane Doe",
                    "photo_url": None
                },
                "last_message": "Hello!",
                "last_message_time": "2026-02-01T12:00:00Z",
                "unread_count": 2
            }
        ]
    }

@app.post("/api/v1/chat/translate")
async def translate_message(request: TranslateRequest):
    """Translate a message to target language."""
    return {
        "original_message": request.message,
        "translated_message": f"[{request.target_language}] {request.message}",
        "target_language": request.target_language
    }

@app.post("/api/v1/chat/request")
async def send_chat_request(from_user_id: str, to_user_id: str):
    """Send a chat request to another user."""
    return {
        "request_id": f"req-{from_user_id}-{to_user_id}",
        "from_user_id": from_user_id,
        "to_user_id": to_user_id,
        "status": "pending",
        "created_at": "2026-02-01T12:00:00Z"
    }

@app.put("/api/v1/chat/request/{request_id}/accept")
async def accept_chat_request(request_id: str):
    """Accept a chat request."""
    return {
        "request_id": request_id,
        "status": "accepted",
        "message": "Chat request accepted"
    }

# =============================================================================
# Map & Location Endpoints
# =============================================================================

@app.get("/api/v1/map/nearby")
async def get_nearby_fitbuddies(
    latitude: float = Query(...),
    longitude: float = Query(...),
    radius: int = Query(5, description="Radius in kilometers"),
    status: Optional[str] = Query(None)
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
            "bio": "Love yoga and running!"
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
            "bio": "Gym enthusiast"
        }
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
        "message": "Location updated successfully"
    }

@app.post("/api/v1/location/share")
async def share_location(share: LocationShare):
    """Share live location with another user."""
    return {
        "user_id": share.user_id,
        "target_user_id": share.target_user_id,
        "duration_seconds": share.duration_seconds,
        "expires_at": "2026-02-01T13:00:00Z",
        "message": "Location sharing started"
    }

@app.delete("/api/v1/location/share/{user_id}/{target_user_id}")
async def stop_location_sharing(user_id: str, target_user_id: str):
    """Stop sharing location."""
    return {
        "message": "Location sharing stopped",
        "user_id": user_id,
        "target_user_id": target_user_id
    }

# =============================================================================
# Leaderboard Endpoints
# =============================================================================

@app.get("/api/v1/leaderboard/global")
async def get_global_leaderboard(
    limit: int = Query(100, le=100),
    offset: int = Query(0)
):
    """Get global leaderboard."""
    leaderboard = [
        {
            "rank": i + 1,
            "user_id": f"user-{i}",
            "name": f"User {i}",
            "score": 1500 - (i * 10),
            "streak_days": 30 - i,
            "country": "USA"
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
            "country": country
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
            "streak_days": 25
        },
        {
            "rank": 2,
            "user_id": "friend-1",
            "name": "Friend 1",
            "score": 1100,
            "streak_days": 20
        }
    ]
    return {"leaderboard": leaderboard, "total": 2}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)