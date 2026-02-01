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
   - Add your `GEMINI_API_KEY` and Supabase credentials.
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
     - `SUPABASE_URL`: Your Supabase Project URL.
     - `SUPABASE_KEY`: Your Supabase API Key.

3. **Deploy**:
   - Vercel will automatically build and deploy your project on every push to the `main` branch.

---

## 3. API Endpoints

- `POST /api/v1/chat`: AI-powered chat (Gemini 2.0 Flash).
- `GET /api/v1/map/nearby`: FitBuddy locator logic.
- `GET /api/v1/plans/ai`: Personalized fitness plans.

---

## ⚠️ Security Notice
You shared a Gemini API key in a public chat session. For your security:
1. **Revoke the key** in the Google AI Studio / Google Cloud Console immediately.
2. **Generate a new key** for production use.
3. Use the `.env` file for local development and Vercel Environment Variables for production.