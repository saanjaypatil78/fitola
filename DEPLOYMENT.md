# Deployment Guide: Fitola Backend

This guide explains how to deploy and run the Fitola backend.

## 1. Local Development Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/saanjaypatil78/fitola.git
   cd fitola
   ```

2. **Create a Virtual Environment**:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\\Scripts\\activate
   ```

3. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure Environment Variables**:
   - Copy `.env.example` to `.env`.
   - Add your `GEMINI_API_KEY`, `RUBE_MCP_JWT`, `RUBE_MCP_BASE_URL`, and Supabase credentials.
   - **CRITICAL**: Do not commit your `.env` file to version control.

5. **Run the Server**:
   ```bash
   python backend/main.py
   ```
   The API will be available at `http://localhost:8000`.

---

## 2. Vercel Deployment (Production)

Fitola is pre-configured for Vercel using `vercel.json`.

1. **Connect GitHub to Vercel**:
   - Go to your [Vercel Dashboard](https://vercel.com/dashboard).
   - Click **Add New Project** and import the `saanjaypatil78/fitola` repository.

2. **Configure Environment Variables**:
   - In the Vercel project settings, go to **Environment Variables**.
   - Add the following keys:
     - `GEMINI_API_KEY`: Your Google Gemini API Key.
     - `GEMINI_MODEL` (optional): Override the Gemini model (defaults to `gemini-2.5-flash`).
     - `RUBE_MCP_JWT`: JWT for the Rube MCP API (Authorization: Bearer <token>).
     - `RUBE_MCP_BASE_URL` (optional): Base URL for Rube MCP (defaults to `https://rube.app`).
     - `RUBE_MCP_TIMEOUT` (optional): HTTP timeout in seconds (defaults to `10`).
     - `SUPABASE_URL`: Your Supabase Project URL.
     - `SUPABASE_KEY`: Your Supabase API Key.

3. **Deploy**:
   - Vercel will automatically build and deploy your project on every push to the `main` branch.

---

## 3. API Endpoints

- `POST /api/v1/chat`: AI-powered chat (Gemini 2.5 Flash).
- `GET /api/v1/map/nearby`: FitBuddy locator logic.
- `GET /api/v1/plans/ai`: Personalized fitness plans.
- `POST /api/v1/plans/ai`: AI-generated weekly workout + diet plans.
- `POST /api/v1/translate`: Gemini-powered translation.
- `GET /api/v1/rube/recipe-hub/discover`: Proxy to Rube MCP Recipe Hub discover.

The `POST /api/v1/plans/ai` response includes `plan_json` (parsed JSON or null),
`plan_text` for the raw response, and `plan_format` to indicate parsing success.

---

## ⚠️ Security Notice
You shared a Gemini API key in a public chat session. For your security:
1. **Revoke the key** in the Google AI Studio / Google Cloud Console immediately.
2. **Generate a new key** for production use.
3. Use the `.env` file for local development and Vercel Environment Variables for production.
