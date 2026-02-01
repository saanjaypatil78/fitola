import json
import os
import re
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from google import genai
from dotenv import load_dotenv
from typing import Optional

load_dotenv()

app = FastAPI(title="Fitola Backend", version="1.0.0")

# Initialize Gemini Client
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
GEMINI_MODEL = os.getenv("GEMINI_MODEL", "gemini-2.5-flash")
client = genai.Client(api_key=GEMINI_API_KEY) if GEMINI_API_KEY else None

class ChatRequest(BaseModel):
    message: str
    language: Optional[str] = None

class PlanRequest(BaseModel):
    age: int = Field(gt=0, lt=150)
    height_cm: float = Field(gt=0, lt=300)
    weight_kg: float = Field(gt=0, lt=500)
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
    if not GEMINI_API_KEY or client is None:
        raise HTTPException(status_code=500, detail="GEMINI_API_KEY is not configured")
    return client

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
        return None

def sanitize_prompt_value(value: Optional[str], max_length: int = 200) -> str:
    if not value:
        return "None"
    cleaned = " ".join(value.split())
    if len(cleaned) <= max_length:
        return cleaned
    truncated_length = max(max_length - 3, 0)
    return f"{cleaned[:truncated_length].rstrip()}..."

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
        prompt = (
            "Translate the following text from "
            f"{request.source_language} to {request.target_language}. "
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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
