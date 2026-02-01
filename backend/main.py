import json
import logging
import os
import re

from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel, Field
import httpx
from google import genai
from dotenv import load_dotenv
from typing import Optional

load_dotenv()

app = FastAPI(title="Fitola Backend", version="1.0.0")
logger = logging.getLogger(__name__)

# Initialize Gemini Client
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
GEMINI_MODEL = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")
client = genai.Client(api_key=GEMINI_API_KEY) if GEMINI_API_KEY else None
RUBE_MCP_BASE_URL = os.getenv("RUBE_MCP_BASE_URL", "https://rube.app").rstrip("/")
RUBE_MCP_VALIDATED_BASE_URL: Optional[str] = None
RUBE_HTTP_CLIENT: Optional[httpx.AsyncClient] = None

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
            detail="GEMINI_API_KEY is not configured. Please set GEMINI_API_KEY."
        )
    if client is None:
        raise HTTPException(
            status_code=500,
            detail="Gemini client failed to initialize. Verify GEMINI_API_KEY."
        )
    return client

def require_rube_token() -> str:
    token = os.getenv("RUBE_MCP_JWT")
    if not token:
        raise HTTPException(
            status_code=500,
            detail="RUBE_MCP_JWT is not configured. Please set RUBE_MCP_JWT."
        )
    return token

def validate_rube_base_url() -> str:
    if not RUBE_MCP_BASE_URL.startswith("https://"):
        raise HTTPException(
            status_code=500,
            detail="RUBE_MCP_BASE_URL must use https."
        )
    return RUBE_MCP_BASE_URL

@app.on_event("startup")
async def validate_rube_on_startup() -> None:
    global RUBE_MCP_VALIDATED_BASE_URL
    RUBE_MCP_VALIDATED_BASE_URL = validate_rube_base_url()
    await get_rube_http_client()

@app.on_event("shutdown")
async def close_rube_http_client() -> None:
    global RUBE_HTTP_CLIENT
    if RUBE_HTTP_CLIENT is not None:
        await RUBE_HTTP_CLIENT.aclose()
        RUBE_HTTP_CLIENT = None

async def get_rube_http_client() -> httpx.AsyncClient:
    global RUBE_HTTP_CLIENT
    if RUBE_HTTP_CLIENT is None:
        RUBE_HTTP_CLIENT = httpx.AsyncClient(timeout=10)
    return RUBE_HTTP_CLIENT

async def fetch_rube_json(url: str, token: str, params: Optional[dict] = None) -> dict:
    try:
        http_client = await get_rube_http_client()
        response = await http_client.get(
            url,
            params=params,
            headers={"Authorization": f"Bearer {token}", "Accept": "application/json"}
        )
        response.raise_for_status()
    except httpx.HTTPStatusError as exc:
        raise HTTPException(
            status_code=exc.response.status_code,
            detail=f"Rube MCP request failed with status {exc.response.status_code}."
        )
    except httpx.RequestError as exc:
        raise HTTPException(status_code=502, detail=f"Rube MCP request failed: {exc}")

    try:
        return response.json()
    except json.JSONDecodeError:
        raise HTTPException(status_code=502, detail="Invalid JSON returned from Rube MCP.")

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
        logger.warning("Failed to parse Gemini JSON response (length=%s).", len(cleaned))
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

@app.post("/api/v1/chat")
async def chat(request: ChatRequest):
    """
    Fitola Chat endpoint powered by Gemini AI.
    Handles user messages and returns AI-generated responses.
    """
    try:
        gemini_client = require_gemini()
        language_instruction = get_language_instruction(request.language)
        message = request.message
        if language_instruction:
            message = f"{language_instruction}\n\n{request.message}"
        response = gemini_client.models.generate_content(
            model=GEMINI_MODEL,
            contents=message
        )
        return {"response": response.text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/v1/map/nearby")
async def map_endpoint():
    return {"message": "Map endpoint logic for nearby FitBuddies"}

@app.get("/api/v1/plans/ai")
async def ai_plans():
    return {"message": "AI-generated personalized fitness plans"}

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
            model=GEMINI_MODEL,
            contents=prompt
        )
        parsed_plan = parse_json_response(response.text)
        return {
            "plan_json": parsed_plan,
            "plan_text": response.text,
            "plan_format": "json" if parsed_plan else "text"
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
            model=GEMINI_MODEL,
            contents=prompt
        )
        return {"translation": response.text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/v1/rube/recipe-hub/discover")
async def rube_recipe_discover(request: Request):
    token = require_rube_token()
    params = dict(request.query_params)
    base_url = RUBE_MCP_VALIDATED_BASE_URL or validate_rube_base_url()
    url = f"{base_url}/recipe-hub/discover"
    return await fetch_rube_json(url, token, params=params)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
