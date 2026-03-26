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
   - Add your `GEMINI_API_KEY`, `RUBE_MCP_JWT`, `RUBE_MCP_BASE_URL`, `STITCH_PROJECT_ID`, and Supabase credentials.
   - **CRITICAL**: Do not commit your `.env` file to version control.

5. **Run the Server**:
   ```bash
   python backend/main.py
   ```
   The API will be available at `http://localhost:8000`.

---

## 2. Vercel Deployment (Production)

Fitola is pre-configured for Vercel using `vercel.json`.

**One-click deploy:**  
[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/saanjaypatil78/fitola&project-name=fitola&repository-name=fitola&env=GEMINI_API_KEY,GEMINI_MODEL,RUBE_MCP_JWT,RUBE_MCP_BASE_URL,RUBE_MCP_TIMEOUT,STITCH_PROJECT_ID,CLICKHOUSE_HOST,CLICKHOUSE_PORT,CLICKHOUSE_USER,CLICKHOUSE_PASSWORD,CLICKHOUSE_SECURE,CLICKHOUSE_VERIFY,CLICKHOUSE_CONNECT_TIMEOUT,CLICKHOUSE_SEND_RECEIVE_TIMEOUT,CLICKHOUSE_MCP_AUTH_TOKEN,SUPABASE_URL,SUPABASE_KEY&envDescription=Add%20your%20API%20keys%20to%20finish%20deployment)

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
      - `STITCH_PROJECT_ID`: Google Cloud project ID for Stitch MCP (required for Stitch MCP).
      - `STITCH_USE_SYSTEM_GCLOUD` (optional): Set to `1` to reuse your system gcloud credentials.
      - `CLICKHOUSE_HOST`: ClickHouse host for the ClickHouse MCP server.
      - `CLICKHOUSE_PORT`: ClickHouse port (for example, `8443` for secure HTTPS).
      - `CLICKHOUSE_USER`: ClickHouse user.
      - `CLICKHOUSE_PASSWORD`: ClickHouse password.
      - `CLICKHOUSE_SECURE` (optional): Set to `true` for HTTPS connections.
      - `CLICKHOUSE_VERIFY` (optional): Set to `true` to verify TLS certificates.
      - `CLICKHOUSE_CONNECT_TIMEOUT` (optional): Connection timeout in seconds.
      - `CLICKHOUSE_SEND_RECEIVE_TIMEOUT` (optional): Request timeout in seconds.
      - `CLICKHOUSE_MCP_AUTH_TOKEN` (optional): Auth token when exposing ClickHouse MCP over HTTP/SSE.
      - `SUPABASE_URL`: Your Supabase Project URL.
      - `SUPABASE_KEY`: Your Supabase API Key.

3. **Deploy**:
   - Vercel will automatically build and deploy your project on every push to the `main` branch.

---

## 3. Netlify Functions Deployment (Serverless)

Deploy the FastAPI backend as a Netlify serverless function.

**One-click deploy:**  
[![Deploy to Netlify](https://www.netlify.com/img/deploy/button.svg)](https://app.netlify.com/start/deploy?repository=https://github.com/saanjaypatil78/fitola#GEMINI_API_KEY=&GEMINI_MODEL=gemini-2.5-flash&RUBE_MCP_JWT=&RUBE_MCP_BASE_URL=https://rube.app&RUBE_MCP_TIMEOUT=10&STITCH_PROJECT_ID=&CLICKHOUSE_HOST=&CLICKHOUSE_PORT=&CLICKHOUSE_USER=&CLICKHOUSE_PASSWORD=&SUPABASE_URL=&SUPABASE_KEY=)

1. **What you get**
   - `netlify.toml` routes all traffic to `/.netlify/functions/api`.
   - `netlify/functions/api.py` wraps the FastAPI app with `Mangum` for AWS Lambda.
   - Minimal static stub at `/` that documents the function path.

2. **Environment variables**
   - Configure the same variables as Vercel (Gemini, Rube MCP, Supabase, ClickHouse, Stitch).

3. **Test locally**
   ```bash
   npm install -g netlify-cli
   netlify dev
   # API available at http://localhost:8888/.netlify/functions/api
   ```

---

## 4. Google Cloud Run Deployment

Use the provided `Dockerfile` to deploy the backend to Cloud Run.

**One-click deploy:**  
[![Run on Google Cloud](https://deploy.cloud.run/button.svg)](https://deploy.cloud.run?git_repo=https://github.com/saanjaypatil78/fitola.git)

1. **Manual deployment**
   ```bash
   gcloud builds submit --tag gcr.io/$(gcloud config get-value project)/fitola .
   gcloud run deploy fitola \
     --image gcr.io/$(gcloud config get-value project)/fitola \
     --platform managed \
     --allow-unauthenticated \
     --region us-central1 \
     --set-env-vars GEMINI_API_KEY=... \
     --set-env-vars RUBE_MCP_JWT=... \
     --set-env-vars SUPABASE_URL=... \
     --set-env-vars SUPABASE_KEY=...
   ```

2. **Runtime**
   - Container listens on port `8080` (Cloud Run default).
   - `uvicorn main:app` from `/app/backend`.

---

## 5. API Endpoints

- `POST /api/v1/chat`: AI-powered chat (Gemini 2.5 Flash).
- `GET /api/v1/map/nearby`: FitBuddy locator logic.
- `GET /api/v1/plans/ai`: Personalized fitness plans.
- `POST /api/v1/plans/ai`: AI-generated weekly workout + diet plans.
- `POST /api/v1/translate`: Gemini-powered translation.
- `GET /api/v1/rube/recipe-hub/discover`: Proxy to Rube MCP Recipe Hub discover.

The `POST /api/v1/plans/ai` response includes `plan_json` (parsed JSON or null),
`plan_text` for the raw response, and `plan_format` to indicate parsing success.

---

## 6. Automated Deployment Workflow

Fitola includes automated deployment capabilities through agentic workflows and CI/CD pipelines.

### 6.1 One-Command Deployment

Use the automated deployment script:

```bash
# Deploy everything to production
./deploy.sh production true

# Deploy backend only
./deploy.sh production false

# Deploy to staging
./deploy.sh staging true
```

The script automatically:
- Runs all tests (backend & mobile)
- Builds the backend
- Deploys to Vercel
- Builds mobile apps (APK & Web)
- Validates deployment

### 6.2 CI/CD Pipeline

Fitola supports GitHub Actions for automated CI/CD:

**Continuous Integration** (on every push/PR):
- Backend linting (black, flake8)
- Backend tests (pytest with coverage)
- Flutter analysis
- Flutter tests
- Build validation

**Continuous Deployment** (on main branch):
- Automatic deployment to Vercel
- Web app build and deployment
- APK artifact generation

See **[AUTOMATION_GUIDE.md](AUTOMATION_GUIDE.md)** for complete CI/CD setup.

### 6.3 Agentic Development Automation

Leverage MCP servers for deployment automation:

**Sequential Thinking MCP**:
- Deployment strategy planning
- Environment configuration validation
- Rollback procedures
- Health check automation

**Stitch MCP**:
- Generate deployment dashboards
- Create monitoring UIs
- Build admin panels

📚 **Learn More**: See **[AGENTIC_WORKFLOW.md](AGENTIC_WORKFLOW.md)** for AI-powered development workflows.

---

## ⚠️ Security Notice
You shared a Gemini API key in a public chat session. For your security:
1. **Revoke the key** in the Google AI Studio / Google Cloud Console immediately.
2. **Generate a new key** for production use.
3. Use the `.env` file for local development and Vercel Environment Variables for production.
