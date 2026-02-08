# Fitola - Quick Start Guide

## 🚀 Getting Started in 5 Minutes

This guide will help you get Fitola running on your local machine quickly.

## Prerequisites

Before you begin, ensure you have:
- **Flutter SDK** (3.24.5 or later) - [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Python** (3.10 or later) - [Install Python](https://www.python.org/downloads/)
- **Git** - [Install Git](https://git-scm.com/downloads/)

## Step 1: Clone the Repository

```bash
git clone https://github.com/saanjaypatil78/fitola.git
cd fitola
```

## Step 2: Backend Setup (5 minutes)

### 2.1 Create Virtual Environment
```bash
cd backend
python -m venv venv

# On macOS/Linux:
source venv/bin/activate

# On Windows:
venv\Scripts\activate
```

### 2.2 Install Dependencies
```bash
pip install -r requirements.txt
```

### 2.3 Set Up Environment Variables
```bash
# Create .env file
cp .env.example .env

# Edit .env and add your keys:
# GEMINI_API_KEY=your_gemini_api_key_here
# SUPABASE_URL=your_supabase_url_here
# SUPABASE_KEY=your_supabase_key_here
# STITCH_PROJECT_ID=your_google_cloud_project_id
# STITCH_USE_SYSTEM_GCLOUD=1
```

### 2.4 Start Backend Server
```bash
uvicorn main:app --reload
```

The API will be running at `http://localhost:8000`
- API Docs: http://localhost:8000/docs
- Health Check: http://localhost:8000/health

## Step 3: Flutter App Setup (5 minutes)

### 3.1 Navigate to Mobile Directory
```bash
cd ../mobile
```

### 3.2 Install Flutter Dependencies
```bash
flutter pub get
```

### 3.3 Verify Flutter Installation
```bash
flutter doctor
```

### 3.4 Run the App

**For Android Emulator:**
```bash
flutter run
```

**For iOS Simulator (macOS only):**
```bash
flutter run -d ios
```

**For Web Browser:**
```bash
flutter run -d chrome
```

## Step 4: Get API Keys (Optional for Full Features)

### 4.1 Get Gemini API Key
1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Create a new API key
3. Add to `backend/.env`: `GEMINI_API_KEY=your_key_here`

### 4.2 Set Up Supabase (Optional)
1. Create account at [Supabase](https://supabase.com)
2. Create a new project
3. Go to Project Settings → API
4. Copy URL and anon key
5. Add to both `backend/.env` and `mobile/.env`

## Step 5: Set Up Agentic Workflow (Optional but Recommended)

### 5.1 Install MCP Servers

Fitola integrates **Model Context Protocol (MCP)** servers for AI-powered development automation.

**Prerequisites**:
- Node.js 18+ with `npx`
- MCP-compatible IDE (VS Code with GitHub Copilot, Claude Desktop, etc.)

**Install Sequential Thinking MCP** (auto-installed when accessed):
```bash
npx -y @modelcontextprotocol/server-sequential-thinking
```

**Install Stitch MCP** (Google Labs UI generation):
```bash
# Prerequisites: Google Cloud CLI
gcloud auth login

# Run setup helper
npx @_davideast/stitch-mcp init
```

### 5.2 Configure MCP

The `mcp.json` file in the project root is already configured:

```json
{
  "servers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    },
    "stitch": {
      "command": "npx",
      "args": ["@_davideast/stitch-mcp", "proxy"],
      "env": {
        "STITCH_PROJECT_ID": "YOUR_PROJECT_ID_HERE"
      }
    }
  }
}
```

Update your `.env` with your Google Cloud project ID:
```env
STITCH_PROJECT_ID=your_google_cloud_project_id
STITCH_USE_SYSTEM_GCLOUD=1
```

### 5.3 Verify Setup

```bash
# Verify Stitch MCP
npx @_davideast/stitch-mcp doctor

# Check configuration
cat mcp.json
```

### 5.4 What MCP Enables

✨ **Development Superpowers**:
- Generate Flutter screens from natural language descriptions
- Auto-create boilerplate code and components
- Intelligent problem-solving with sequential thinking
- UI design generation (400 free daily credits)

📚 **Learn More**: See [AGENTIC_WORKFLOW.md](AGENTIC_WORKFLOW.md) for complete guide

## Step 6: Test the App

1. **Launch App** - You should see the splash screen
2. **Select Language** - Choose your preferred language
3. **Complete Onboarding** - Fill in your information
4. **Explore Features**:
   - View Home Screen with feature grid
   - Open Chat List
   - View FitBuddy Map
   - Check AI Trainer (requires Gemini API key)
   - View Leaderboard

## Common Issues & Solutions

### Issue: Flutter not found
**Solution:** Make sure Flutter is in your PATH. Run:
```bash
export PATH="$PATH:`pwd`/flutter/bin"  # Add Flutter to PATH
flutter doctor  # Verify installation
```

### Issue: Backend won't start
**Solution:** Ensure all dependencies are installed:
```bash
pip install --upgrade -r requirements.txt
```

### Issue: App crashes on startup
**Solution:** Check that environment variables are set correctly in both backend and mobile .env files.

### Issue: Gemini API errors
**Solution:** 
1. Verify your API key is correct
2. Check you have billing enabled on Google Cloud
3. Ensure you're using gemini-2.0-flash model

## Development Tools

### Backend
- **API Documentation**: http://localhost:8000/docs (Swagger UI)
- **ReDoc**: http://localhost:8000/redoc
- **Logs**: Terminal where uvicorn is running

### Flutter
- **Hot Reload**: Press `r` in terminal
- **Hot Restart**: Press `R` in terminal
- **DevTools**: Run `flutter pub global activate devtools` then `dart devtools`

## Project Structure

```
fitola/
├── backend/              # FastAPI backend
│   ├── main.py          # API endpoints
│   ├── requirements.txt # Python dependencies
│   └── .env            # Environment variables
├── mobile/              # Flutter app
│   ├── lib/            # Dart source code
│   │   ├── config/     # Configuration
│   │   ├── models/     # Data models
│   │   ├── services/   # Business logic
│   │   ├── providers/  # State management
│   │   ├── screens/    # UI screens
│   │   └── widgets/    # Reusable widgets
│   ├── android/        # Android config
│   ├── ios/           # iOS config
│   └── pubspec.yaml   # Flutter dependencies
└── docs/              # Documentation
    ├── PRD.md        # Product specs
    ├── TECHNICAL.md  # Technical docs
    └── UX_WIREFRAMES.md # Design specs
```

## Next Steps

1. **Explore the Code**: Read through the models, services, and screens
2. **Read Documentation**: Check out the comprehensive docs in the `docs/` folder
3. **Customize**: Modify theme colors in `mobile/lib/config/theme.dart`
4. **Add Features**: Follow the existing patterns to add new features
5. **Deploy**: Follow deployment instructions in `docs/TECHNICAL.md`

## Useful Commands

### Backend
```bash
# Run tests
pytest

# Format code
black .

# Check types
mypy .
```

### Flutter
```bash
# Run tests
flutter test

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Clean build
flutter clean && flutter pub get
```

## Getting Help

- **Documentation**: See `docs/` folder for comprehensive guides
- **API Reference**: http://localhost:8000/docs when backend is running
- **Issues**: https://github.com/saanjaypatil78/fitola/issues

## Success! 🎉

You should now have Fitola running on your machine. Explore the app, try the features, and start building!

---

**Need more help?** Check out the full documentation in the `docs/` folder or open an issue on GitHub.
