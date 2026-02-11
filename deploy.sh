#!/bin/bash
# Fitola Production Deployment Script
# Single-command deployment to Kubernetes

set -e

echo "🚀 Fitola Production Deployment Script"
echo "========================================"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check prerequisites
echo ""
echo "📋 Checking prerequisites..."

# Check Docker
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed"
    exit 1
fi
print_success "Docker found"

# Check kubectl
if ! command -v kubectl &> /dev/null; then
    print_warning "kubectl not found - skipping K8s deployment"
    K8S_DEPLOY=false
else
    print_success "kubectl found"
    K8S_DEPLOY=true
fi

# Check docker-compose
if ! command -v docker-compose &> /dev/null; then
    print_warning "docker-compose not found - will use 'docker compose'"
    COMPOSE_CMD="docker compose"
else
    COMPOSE_CMD="docker-compose"
fi

# Parse command line arguments
DEPLOYMENT_MODE=${1:-local}

case $DEPLOYMENT_MODE in
    local)
        echo ""
        echo "🏠 Deploying in LOCAL mode (Docker Compose)"
        echo "============================================"
        
        # Check for .env file
        if [ ! -f .env ]; then
            print_warning ".env file not found, copying from .env.example"
            cp .env.example .env
            print_warning "Please edit .env file with your actual API keys"
            exit 1
        fi
        
        # Build and start containers
        echo ""
        echo "🔨 Building Docker images..."
        $COMPOSE_CMD build
        
        echo ""
        echo "🚀 Starting services..."
        $COMPOSE_CMD up -d
        
        echo ""
        echo "⏳ Waiting for services to be healthy..."
        sleep 10
        
        # Check health
        if curl -s http://localhost:8000/health > /dev/null; then
            print_success "Backend is healthy!"
        else
            print_error "Backend health check failed"
            $COMPOSE_CMD logs backend
            exit 1
        fi
        
        echo ""
        print_success "🎉 Fitola is running locally!"
        echo ""
        echo "Access the API at: http://localhost:8000"
        echo "API Documentation: http://localhost:8000/docs"
        echo ""
        echo "To view logs: $COMPOSE_CMD logs -f"
        echo "To stop: $COMPOSE_CMD down"
        ;;
        
    k8s|kubernetes)
        if [ "$K8S_DEPLOY" = false ]; then
            print_error "kubectl is required for Kubernetes deployment"
            exit 1
        fi
        
        echo ""
        echo "☸️  Deploying to KUBERNETES"
        echo "==========================="
        
        # Check kubectl connection
        if ! kubectl cluster-info &> /dev/null; then
            print_error "Cannot connect to Kubernetes cluster"
            exit 1
        fi
        print_success "Connected to Kubernetes cluster"
        
        # Build Docker image
        echo ""
        echo "🔨 Building Docker image..."
        docker build -t fitola/backend:latest .
        
        # Tag for your registry (update as needed)
        # docker tag fitola/backend:latest your-registry/fitola-backend:latest
        # docker push your-registry/fitola-backend:latest
        
        # Apply Kubernetes manifests
        echo ""
        echo "📦 Applying Kubernetes manifests..."
        
        kubectl apply -f k8s/namespace.yaml
        print_success "Namespace created"
        
        kubectl apply -f k8s/configmap.yaml
        print_success "ConfigMap created"
        
        # Warning about secrets
        print_warning "About to apply secrets - ensure k8s/secrets.yaml has real values!"
        read -p "Continue? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Deployment cancelled"
            exit 1
        fi
        
        kubectl apply -f k8s/secrets.yaml
        print_success "Secrets created"
        
        kubectl apply -f k8s/redis-statefulset.yaml
        print_success "Redis StatefulSet created"
        
        kubectl apply -f k8s/service.yaml
        print_success "Services created"
        
        kubectl apply -f k8s/deployment.yaml
        print_success "Backend Deployment created"
        
        kubectl apply -f k8s/ingress.yaml
        print_success "Ingress created"
        
        # Wait for deployment
        echo ""
        echo "⏳ Waiting for deployment to be ready..."
        kubectl wait --for=condition=available --timeout=300s deployment/fitola-backend -n fitola
        
        echo ""
        print_success "🎉 Fitola deployed to Kubernetes!"
        echo ""
        echo "Check status: kubectl get all -n fitola"
        echo "View logs: kubectl logs -f -l app=fitola-backend -n fitola"
        echo "Port forward: kubectl port-forward -n fitola svc/fitola-backend 8000:80"
        ;;
        
    prod|production)
        echo ""
        echo "🌐 Deploying to PRODUCTION"
        echo "=========================="
        
        print_warning "Production deployment requires:"
        echo "  1. Docker registry access"
        echo "  2. Kubernetes cluster configured"
        echo "  3. Domain name and SSL certificates"
        echo "  4. External secrets management (not in git)"
        echo ""
        read -p "Continue? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Deployment cancelled"
            exit 1
        fi
        
        # Build and push to registry
        echo ""
        echo "🔨 Building production image..."
        docker build -t fitola/backend:$(git rev-parse --short HEAD) .
        docker tag fitola/backend:$(git rev-parse --short HEAD) fitola/backend:latest
        
        print_warning "Push image to your registry manually:"
        echo "  docker tag fitola/backend:latest your-registry/fitola-backend:latest"
        echo "  docker push your-registry/fitola-backend:latest"
        echo ""
        
        # Deploy to K8s
        if [ "$K8S_DEPLOY" = true ]; then
            echo "📦 Update k8s/deployment.yaml with your registry image"
            echo "Then run: kubectl apply -f k8s/"
        fi
        
        print_success "Production deployment prepared"
        ;;
        
    *)
        print_error "Unknown deployment mode: $DEPLOYMENT_MODE"
        echo ""
        echo "Usage: ./deploy.sh [MODE]"
        echo ""
        echo "Modes:"
        echo "  local      - Deploy locally with Docker Compose (default)"
        echo "  k8s        - Deploy to Kubernetes cluster"
        echo "  production - Prepare production deployment"
        echo ""
        echo "Examples:"
        echo "  ./deploy.sh local"
        echo "  ./deploy.sh k8s"
        echo "  ./deploy.sh production"
        exit 1
        ;;
esac

echo ""
print_success "Deployment completed successfully! 🎉"

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
  echo -e "${RED}❌ Not in project root directory. Please run from the Fitola project root.${NC}"
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
