# Production Deployment Guide - Fitola

Complete guide for deploying Fitola to production with Docker and Kubernetes.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Quick Deployment](#quick-deployment)
4. [Docker Deployment](#docker-deployment)
5. [Kubernetes Deployment](#kubernetes-deployment)
6. [Configuration](#configuration)
7. [Monitoring](#monitoring)
8. [Troubleshooting](#troubleshooting)
9. [Security](#security)

## Overview

Fitola supports multiple deployment options:

| Option | Best For | Complexity | Scalability |
|--------|----------|------------|-------------|
| **Docker Compose** | Local dev, small deployments | Low | Limited |
| **Kubernetes** | Production, high availability | Medium | High |
| **Vercel** | Serverless, auto-scaling | Low | High |

## Prerequisites

### Required
- **Docker** 20.10+ and Docker Compose
- **kubectl** (for Kubernetes deployment)
- **Git** for cloning repository
- **API Keys**:
  - Gemini API Key (required)
  - Supabase URL and Key (required)
  - MemU API Key (optional, uses mock mode without)

### Recommended
- **Kubernetes Cluster** (GKE, EKS, AKS, or local with Minikube)
- **Container Registry** (Docker Hub, GCR, ECR, or ACR)
- **Domain Name** with DNS configured
- **SSL Certificate** (or use Let's Encrypt with cert-manager)

## Quick Deployment

### Option 1: Single Command (Recommended)

```bash
# Clone repository
git clone https://github.com/saanjaypatil78/fitola.git
cd fitola

# Copy and configure secrets
cp .env.example .env
# Edit .env with your API keys

# Deploy locally
./deploy.sh local

# Or deploy to Kubernetes
./deploy.sh k8s
```

That's it! 🎉

### Option 2: Docker Compose

```bash
# Configure environment
cp .env.example .env
# Edit .env

# Start services
docker-compose up -d

# Check health
curl http://localhost:8000/health

# View logs
docker-compose logs -f backend
```

### Option 3: Kubernetes

```bash
# Build and push image
docker build -t your-registry/fitola-backend:latest .
docker push your-registry/fitola-backend:latest

# Update k8s/deployment.yaml with your image

# Deploy
kubectl apply -f k8s/

# Check status
kubectl get all -n fitola
```

## Docker Deployment

### Step 1: Build Docker Image

```bash
# Build production image
docker build -t fitola/backend:latest .

# Test locally
docker run -p 8000:8000 \
  -e GEMINI_API_KEY=your_key \
  -e SUPABASE_URL=your_url \
  -e SUPABASE_KEY=your_key \
  fitola/backend:latest
```

### Step 2: Docker Compose Deployment

**File**: `docker-compose.yml`

Services included:
- **Backend**: FastAPI application (port 8000)
- **Redis**: Caching and leaderboards (port 6379)
- **Nginx**: Reverse proxy (ports 80/443)

```bash
# Start all services
docker-compose up -d

# Scale backend
docker-compose up -d --scale backend=3

# Update specific service
docker-compose up -d --no-deps backend

# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Remove volumes (WARNING: deletes data)
docker-compose down -v
```

### Step 3: Health Checks

```bash
# Backend health
curl http://localhost:8000/health

# Redis health
docker exec fitola-redis redis-cli ping

# Check all containers
docker ps
```

## Kubernetes Deployment

### Architecture

```
Internet
    │
    ▼
Ingress (HTTPS)
    │
    ▼
Service (fitola-backend)
    │
    ├──► Pod 1 (Backend)
    ├──► Pod 2 (Backend)
    └──► Pod 3 (Backend)
    
StatefulSet (Redis)
    │
    └──► Pod (Redis + PersistentVolume)
```

### Step 1: Prepare Kubernetes Cluster

```bash
# Verify kubectl connection
kubectl cluster-info

# Create namespace
kubectl apply -f k8s/namespace.yaml

# Verify
kubectl get namespaces
```

### Step 2: Configure Secrets

**DO NOT commit real secrets to git!**

```bash
# Create secrets from environment variables
kubectl create secret generic fitola-secrets \
  --from-literal=GEMINI_API_KEY=$GEMINI_API_KEY \
  --from-literal=SUPABASE_URL=$SUPABASE_URL \
  --from-literal=SUPABASE_KEY=$SUPABASE_KEY \
  --from-literal=RUBE_MCP_JWT=$RUBE_MCP_JWT \
  --from-literal=MEMU_API_KEY=$MEMU_API_KEY \
  -n fitola

# Or use a secrets file (NEVER commit this!)
kubectl apply -f k8s/secrets.yaml
```

### Step 3: Deploy Application

```bash
# Apply all manifests
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/redis-statefulset.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/ingress.yaml

# Or apply all at once
kubectl apply -f k8s/

# Watch deployment
kubectl get pods -n fitola -w
```

### Step 4: Verify Deployment

```bash
# Check all resources
kubectl get all -n fitola

# Check pod status
kubectl get pods -n fitola

# Check logs
kubectl logs -f deployment/fitola-backend -n fitola

# Check events
kubectl get events -n fitola
```

### Step 5: Access Application

```bash
# Port forward for testing
kubectl port-forward -n fitola svc/fitola-backend 8000:80

# Test health
curl http://localhost:8000/health

# Access via ingress (requires DNS)
curl https://api.fitola.app/health
```

## Configuration

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `GEMINI_API_KEY` | Yes | - | Google Gemini API key |
| `GEMINI_MODEL` | No | gemini-2.5-flash | Gemini model to use |
| `SUPABASE_URL` | Yes | - | Supabase project URL |
| `SUPABASE_KEY` | Yes | - | Supabase anon/service key |
| `RUBE_MCP_JWT` | No | - | Rube MCP JWT token |
| `RUBE_MCP_BASE_URL` | No | https://rube.app | Rube MCP base URL |
| `MEMU_API_KEY` | No | - | MemU API key (uses mock if not provided) |
| `MEMU_API_BASE_URL` | No | https://api.memu.so | MemU API base URL |
| `REDIS_HOST` | No | fitola-redis | Redis hostname |
| `REDIS_PORT` | No | 6379 | Redis port |

### Docker Compose Configuration

Edit `docker-compose.yml`:

```yaml
services:
  backend:
    environment:
      - GEMINI_API_KEY=${GEMINI_API_KEY}
      # Add more as needed
    ports:
      - "8000:8000"  # Change if port conflict
    deploy:
      resources:
        limits:
          memory: 1G  # Adjust based on needs
```

### Kubernetes Configuration

Edit `k8s/configmap.yaml` for non-secret configuration:

```yaml
data:
  GEMINI_MODEL: "gemini-2.5-flash"
  RUBE_MCP_BASE_URL: "https://rube.app"
```

Edit `k8s/deployment.yaml` for scaling:

```yaml
spec:
  replicas: 5  # Increase for more capacity
  resources:
    limits:
      memory: "1Gi"  # Adjust based on usage
      cpu: "1000m"
```

## Monitoring

### Docker Monitoring

```bash
# Container stats
docker stats

# Logs
docker-compose logs -f backend

# Health checks
curl http://localhost:8000/health

# Redis monitor
docker exec -it fitola-redis redis-cli monitor
```

### Kubernetes Monitoring

```bash
# Pod status
kubectl get pods -n fitola

# Resource usage
kubectl top pods -n fitola
kubectl top nodes

# Logs
kubectl logs -f deployment/fitola-backend -n fitola

# Events
kubectl get events -n fitola --sort-by='.lastTimestamp'

# Describe pod for issues
kubectl describe pod <pod-name> -n fitola
```

### Metrics (Optional)

Install Prometheus and Grafana:

```bash
# Add Prometheus Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

# Access Grafana
kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80
```

## Troubleshooting

### Common Issues

#### 1. Container Won't Start

```bash
# Check logs
docker logs fitola-backend
# or
kubectl logs deployment/fitola-backend -n fitola

# Check environment variables
docker exec fitola-backend env
# or
kubectl exec deployment/fitola-backend -n fitola -- env
```

#### 2. Health Check Failing

```bash
# Test health endpoint
curl -v http://localhost:8000/health

# Check if port is accessible
telnet localhost 8000

# Verify Python dependencies
docker exec fitola-backend pip list
```

#### 3. Out of Memory

```bash
# Check memory usage
docker stats

# Increase memory limits in docker-compose.yml:
deploy:
  resources:
    limits:
      memory: 2G

# Or in Kubernetes deployment.yaml:
resources:
  limits:
    memory: "2Gi"
```

#### 4. Database Connection Issues

```bash
# Test Supabase connection
curl https://your-project.supabase.co

# Check secrets
kubectl get secret fitola-secrets -n fitola -o yaml
```

#### 5. Image Pull Errors

```bash
# Login to registry
docker login your-registry.com

# Create image pull secret
kubectl create secret docker-registry regcred \
  --docker-server=your-registry.com \
  --docker-username=your-username \
  --docker-password=your-password \
  -n fitola

# Add to deployment.yaml:
spec:
  imagePullSecrets:
  - name: regcred
```

### Debug Mode

Enable debug logging:

```bash
# Docker Compose
docker-compose up backend  # Run in foreground

# Kubernetes
kubectl logs -f deployment/fitola-backend -n fitola --all-containers=true
```

## Security

### Best Practices

1. **Never Commit Secrets**
   ```bash
   # Add to .gitignore
   .env
   k8s/secrets.yaml
   ```

2. **Use External Secrets Management**
   - AWS Secrets Manager
   - Google Secret Manager
   - HashiCorp Vault
   - Kubernetes External Secrets Operator

3. **Network Policies**
   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: fitola-network-policy
     namespace: fitola
   spec:
     podSelector:
       matchLabels:
         app: fitola-backend
     ingress:
     - from:
       - podSelector:
           matchLabels:
             app: nginx-ingress
   ```

4. **RBAC (Kubernetes)**
   ```bash
   # Create service account
   kubectl create serviceaccount fitola-sa -n fitola
   
   # Create role
   kubectl create role fitola-role --verb=get,list --resource=pods -n fitola
   
   # Bind role
   kubectl create rolebinding fitola-binding --role=fitola-role --serviceaccount=fitola:fitola-sa -n fitola
   ```

5. **TLS/SSL**
   ```bash
   # Install cert-manager
   kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
   
   # Configure Let's Encrypt in ingress.yaml
   ```

6. **Security Scanning**
   ```bash
   # Scan Docker image
   docker scan fitola/backend:latest
   
   # Or use Trivy
   trivy image fitola/backend:latest
   ```

### Hardening Checklist

- [ ] Run containers as non-root user
- [ ] Use read-only filesystem where possible
- [ ] Limit container capabilities
- [ ] Enable Pod Security Standards
- [ ] Use Network Policies
- [ ] Implement resource quotas
- [ ] Enable audit logging
- [ ] Regular security updates
- [ ] Vulnerability scanning
- [ ] Secret rotation policy

## Scaling

### Horizontal Pod Autoscaling

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: fitola-backend-hpa
  namespace: fitola
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: fitola-backend
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

### Load Testing

```bash
# Install k6
brew install k6  # macOS
# or
docker pull grafana/k6

# Run load test
k6 run --vus 100 --duration 30s loadtest.js
```

## Backup and Recovery

### Database Backup (Supabase)

Supabase provides automatic backups. For additional backups:

```bash
# Export data
pg_dump -h your-project.supabase.co -U postgres -d postgres > backup.sql
```

### Redis Backup

```bash
# Docker Compose
docker exec fitola-redis redis-cli BGSAVE

# Kubernetes
kubectl exec fitola-redis-0 -n fitola -- redis-cli BGSAVE
```

### Disaster Recovery Plan

1. **Regular Backups**: Daily automated backups
2. **Offsite Storage**: S3, GCS, or Azure Blob
3. **Testing**: Monthly restore drills
4. **Documentation**: Recovery procedures documented
5. **RTO/RPO**: Define acceptable downtime and data loss

## Performance Optimization

### Caching Strategy

- Redis for session data and leaderboards
- Application-level caching with TTL
- CDN for static assets

### Database Optimization

- Connection pooling
- Query optimization
- Indexes on frequent queries
- Read replicas for scaling

### Application Optimization

- Async operations
- Connection reuse
- Batch processing
- Background jobs for heavy operations

## CI/CD Integration

### GitHub Actions

```yaml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    
    - name: Build Docker image
      run: docker build -t fitola/backend:${{ github.sha }} .
    
    - name: Push to registry
      run: docker push fitola/backend:${{ github.sha }}
    
    - name: Deploy to Kubernetes
      run: kubectl set image deployment/fitola-backend backend=fitola/backend:${{ github.sha }} -n fitola
```

## Cost Optimization

### Cloud Provider Recommendations

**Google Cloud (GKE)**
- Use preemptible nodes for non-critical workloads
- Enable cluster autoscaling
- Use Cloud CDN

**AWS (EKS)**
- Use Spot instances
- Enable EKS autoscaling
- Use CloudFront CDN

**Azure (AKS)**
- Use low-priority VMs
- Enable cluster autoscaler
- Use Azure CDN

## Support

For deployment issues:
1. Check [Troubleshooting](#troubleshooting) section
2. Review logs carefully
3. Open GitHub issue with deployment logs
4. Join community discussions

---

**Deployment Checklist:**
- [ ] API keys configured
- [ ] Secrets not in git
- [ ] Health checks passing
- [ ] Monitoring configured
- [ ] Backups automated
- [ ] SSL/TLS enabled
- [ ] Scaling configured
- [ ] Documentation reviewed

**Ready to deploy? Run:** `./deploy.sh k8s` 🚀
