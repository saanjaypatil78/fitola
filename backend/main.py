import os
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from google import genai
from dotenv import load_dotenv

load_dotenv()

app = FastAPI(title="Fitola Backend", version="1.0.0")

# Initialize Gemini Client
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
client = genai.Client(api_key=GEMINI_API_KEY)

class ChatRequest(BaseModel):
    message: str

@app.post("/api/v1/chat")
async def chat(request: ChatRequest):
    """
    Fitola Chat endpoint powered by Gemini AI.
    Handles user messages and returns AI-generated responses.
    """
    try:
        # Using gemini-2.0-flash as per the example
        response = client.models.generate_content(
            model="gemini-2.0-flash", 
            contents=request.message
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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)