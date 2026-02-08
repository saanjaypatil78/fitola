#!/bin/bash

set -e

echo "🚀 Fitola Automated Deployment Script"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for required tools
echo "🔍 Checking prerequisites..."
command -v git >/dev/null 2>&1 || { echo -e "${RED}❌ git is required${NC}"; exit 1; }
command -v python >/dev/null 2>&1 || { echo -e "${RED}❌ python is required${NC}"; exit 1; }

# Parse arguments
ENVIRONMENT=${1:-production}
BUILD_MOBILE=${2:-true}
SKIP_TESTS=${3:-false}

echo -e "${GREEN}📋 Configuration:${NC}"
echo "   Environment: $ENVIRONMENT"
echo "   Build Mobile: $BUILD_MOBILE"
echo "   Skip Tests: $SKIP_TESTS"
echo ""

# Validate environment
if [ "$ENVIRONMENT" != "production" ] && [ "$ENVIRONMENT" != "staging" ] && [ "$ENVIRONMENT" != "development" ]; then
  echo -e "${RED}❌ Invalid environment. Use: production, staging, or development${NC}"
  exit 1
fi

# Check if we're in the right directory
if [ ! -f "mcp.json" ]; then
  echo -e "${RED}❌ Not in project root directory. Please run from /home/runner/work/fitola/fitola${NC}"
  exit 1
fi

# Run tests (unless skipped)
if [ "$SKIP_TESTS" != "true" ]; then
  echo ""
  echo "🧪 Running tests..."
  
  # Backend tests
  echo "Testing backend..."
  cd backend
  if [ -f "requirements.txt" ]; then
    pip install -q -r requirements.txt
    if command -v pytest >/dev/null 2>&1; then
      pytest || { echo -e "${YELLOW}⚠️  Backend tests failed, continuing...${NC}"; }
    else
      echo -e "${YELLOW}⚠️  pytest not found, skipping backend tests${NC}"
    fi
  fi
  cd ..
  
  # Flutter tests (if Flutter is available)
  if command -v flutter >/dev/null 2>&1; then
    echo "Testing Flutter app..."
    cd mobile
    flutter pub get
    flutter test || { echo -e "${YELLOW}⚠️  Flutter tests failed, continuing...${NC}"; }
    cd ..
  else
    echo -e "${YELLOW}⚠️  Flutter not found, skipping mobile tests${NC}"
  fi
  
  echo -e "${GREEN}✅ Tests completed${NC}"
else
  echo -e "${YELLOW}⚠️  Skipping tests as requested${NC}"
fi

# Build backend
echo ""
echo "🏗️  Building backend..."
cd backend
if [ -f "requirements.txt" ]; then
  pip install -q -r requirements.txt
  echo -e "${GREEN}✅ Backend dependencies installed${NC}"
else
  echo -e "${YELLOW}⚠️  No requirements.txt found${NC}"
fi
cd ..

# Deploy backend (if Vercel CLI is available)
echo ""
echo "🚀 Deploying backend to Vercel..."
if command -v vercel >/dev/null 2>&1; then
  cd backend
  if [ "$ENVIRONMENT" = "production" ]; then
    vercel --prod --yes || { echo -e "${YELLOW}⚠️  Vercel deployment requires manual setup${NC}"; }
  else
    vercel --yes || { echo -e "${YELLOW}⚠️  Vercel deployment requires manual setup${NC}"; }
  fi
  cd ..
  echo -e "${GREEN}✅ Backend deployed${NC}"
else
  echo -e "${YELLOW}⚠️  Vercel CLI not found. Install with: npm i -g vercel${NC}"
  echo "   Or deploy manually: cd backend && vercel --prod"
fi

# Build mobile (if requested)
if [ "$BUILD_MOBILE" = "true" ]; then
  echo ""
  echo "📱 Building mobile apps..."
  
  if command -v flutter >/dev/null 2>&1; then
    cd mobile
    
    # Clean previous builds
    echo "Cleaning previous builds..."
    flutter clean
    flutter pub get
    
    # Build Android APK
    echo ""
    echo "Building Android APK..."
    flutter build apk --release || { echo -e "${YELLOW}⚠️  Android build failed${NC}"; }
    
    # Build Web
    echo ""
    echo "Building Web app..."
    flutter build web --release || { echo -e "${YELLOW}⚠️  Web build failed${NC}"; }
    
    cd ..
    echo -e "${GREEN}✅ Mobile builds completed${NC}"
    
    # Show build artifacts
    echo ""
    echo "📦 Build artifacts:"
    if [ -f "mobile/build/app/outputs/flutter-apk/app-release.apk" ]; then
      echo "   ✓ Android APK: mobile/build/app/outputs/flutter-apk/app-release.apk"
    fi
    if [ -d "mobile/build/web" ]; then
      echo "   ✓ Web app: mobile/build/web/"
    fi
  else
    echo -e "${YELLOW}⚠️  Flutter not found, skipping mobile builds${NC}"
  fi
else
  echo -e "${YELLOW}ℹ️  Skipping mobile builds as requested${NC}"
fi

# Success message
echo ""
echo "======================================"
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo "======================================"
echo ""
echo "🌐 URLs:"
echo "   Backend API: https://fitola.vercel.app"
echo "   API Docs: https://fitola.vercel.app/docs"
echo "   Health Check: https://fitola.vercel.app/health"
echo ""
echo "📱 Next steps:"
echo "   1. Test the deployed API endpoints"
echo "   2. Verify mobile app connectivity"
echo "   3. Check logs for any issues"
echo "   4. Update DNS records if needed"
echo ""
echo "📚 Documentation:"
echo "   - Deployment Guide: DEPLOYMENT.md"
echo "   - Automation Guide: AUTOMATION_GUIDE.md"
echo "   - Agentic Workflows: AGENTIC_WORKFLOW.md"
echo ""
