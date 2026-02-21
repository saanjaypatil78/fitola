# Fitola Architecture Documentation

Complete technical architecture for the Fitola AI-powered fitness platform.

## Overview

Fitola is a cloud-native, microservices-based fitness platform combining:
- Mobile-first Flutter application
- FastAPI backend with advanced AI capabilities
- SimpleClaw workflow orchestration
- MemuBot adaptive self-improving AI
- Containerized deployment (Docker/Kubernetes)

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Client Layer                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Flutter    │  │     Web      │  │  Mobile App  │         │
│  │  (Android)   │  │   Browser    │  │    (iOS)     │         │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘         │
└─────────┼──────────────────┼──────────────────┼─────────────────┘
          │                  │                  │
          └──────────────────┴──────────────────┘
                             │
                    HTTP/WebSocket/REST
                             │
          ┌──────────────────┴──────────────────┐
          │                                     │
┌─────────▼──────────────────────────────────────────────────────┐
│                    API Gateway / Load Balancer                  │
│                    (Nginx / Kubernetes Ingress)                 │
└─────────┬──────────────────────────────────────────────────────┘
          │
          ▼
┌────────────────────────────────────────────────────────────────┐
│                   Application Layer (FastAPI)                   │
│  ┌────────────┐  ┌──────────────┐  ┌────────────────────────┐│
│  │  Core API  │  │  SimpleClaw  │  │      MemuBot          ││
│  │ Endpoints  │  │  Workflows   │  │   Adaptive AI         ││
│  └────────────┘  └──────────────┘  └────────────────────────┘│
│  ┌────────────────────────────────────────────────────────────┐│
│  │              Prompt Engineering Layer                      ││
│  └────────────────────────────────────────────────────────────┘│
└────────────────────────┬───────────────────────────────────────┘
                         │
       ┌─────────────────┼─────────────────┬──────────────┐
       │                 │                 │              │
       ▼                 ▼                 ▼              ▼
┌────────────┐  ┌────────────────┐  ┌───────────┐  ┌─────────┐
│  Supabase  │  │  Gemini AI     │  │   Redis   │  │ MemU API│
│  (Auth+DB) │  │  (2.5 Flash)   │  │  (Cache)  │  │ (Memory)│
└────────────┘  └────────────────┘  └───────────┘  └─────────┘

┌─────────────────────────────────────────────────────────────────┐
│                  Infrastructure Layer                            │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐               │
│  │  Docker    │  │ Kubernetes │  │   Vercel   │               │
│  │ Containers │  │ Orchestr.  │  │ Serverless │               │
│  └────────────┘  └────────────┘  └────────────┘               │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### 1. Frontend Layer

#### Flutter Mobile App
- **Framework**: Flutter 3.24.5
- **State Management**: Provider
- **Key Features**:
  - Responsive UI with Material Design 3
  - Real-time chat with WebSocket
  - Map integration (OpenStreetMap)
  - Offline capabilities
  - Multi-language support (30+)

**Key Screens**:
- Onboarding & Authentication
- FitBuddy Map (social fitness network)
- AI Plan Generator
- Chat & Messaging
- Progress Tracking
- Leaderboards

### 2. Backend Layer

#### FastAPI Application
- **Framework**: FastAPI (Python 3.10+)
- **ASGI Server**: Uvicorn
- **Architecture**: Async/Await throughout

**Core Modules**:

1. **API Endpoints** (`main.py`)
   - RESTful API design
   - WebSocket support
   - Health checks
   - CORS enabled

2. **SimpleClaw Integration** (`simpleclaw_integration.py`)
   - Zero-configuration workflow orchestration
   - 5 workflow types
   - Session management
   - Memory persistence

3. **MemuBot Integration** (`memubot_integration.py`)
   - 24/7 proactive memory
   - 9 memory categories
   - Pattern learning
   - Proactive suggestions

4. **Adaptive Workflows** (`adaptive_workflows.py`)
   - Learning fitness plans
   - Predictive workouts
   - Proactive motivation
   - Adaptive nutrition
   - Smart goal tracking

5. **Self-Improving Orchestrator** (`self_improving_orchestrator.py`)
   - Combines MemuBot + SimpleClaw
   - Feedback loops
   - Continuous learning
   - Learning statistics

6. **Prompt Engineering** (`prompt_engineering.py`)
   - Advanced prompting techniques
   - Context-aware generation
   - Output format specification
   - Safety constraints

### 3. AI Layer

#### Gemini AI Integration
- **Model**: Gemini 2.5 Flash
- **Use Cases**:
  - Fitness plan generation
  - Nutrition plan creation
  - Chat assistance
  - Translation services
  - Body analysis

**Prompt Engineering Strategy**:
```python
# Example: Fitness Plan Generation
prompt = f"""
You are an expert AI fitness coach...

## USER PROFILE
- Age: {age}
- Goals: {goals}
- Experience: {experience_level}

## TASK
Create a personalized {duration_days}-day plan...

## OUTPUT FORMAT
[Structured format specification]
"""
```

#### MemuBot Memory System
- **Categories**: 9 organized memory types
- **Storage**: Persistent across sessions
- **Retrieval**: Context-aware search
- **Learning**: Pattern recognition

**Memory Categories**:
1. User Profile
2. Fitness Goals
3. Workout History
4. Nutrition Preferences
5. Progress Metrics
6. Preferences
7. Patterns
8. Motivations
9. Challenges

### 4. Data Layer

#### Supabase (PostgreSQL)
- **Purpose**: Primary database
- **Features**:
  - User authentication
  - Profile storage
  - Workout logs
  - Social connections
  - Real-time subscriptions

**Key Tables**:
- `users` - User profiles
- `workouts` - Workout history
- `plans` - Generated plans
- `messages` - Chat messages
- `leaderboard` - Rankings

#### Redis
- **Purpose**: Caching and real-time data
- **Use Cases**:
  - Session storage
  - Leaderboard rankings
  - Rate limiting
  - Real-time chat
  - Temporary data

#### MemU API (Optional)
- **Purpose**: Persistent AI memory
- **Features**:
  - Long-term memory storage
  - Pattern clustering
  - Semantic search
  - Memory clustering

### 5. Infrastructure Layer

#### Docker Containerization
**Dockerfile Features**:
- Multi-stage build (future optimization)
- Non-root user for security
- Health checks
- Minimal image size
- Production-ready

**Services**:
- `fitola-backend` - FastAPI application
- `fitola-redis` - Redis cache
- `fitola-nginx` - Reverse proxy (optional)

#### Kubernetes Orchestration
**Resources**:
- **Namespace**: `fitola`
- **Deployment**: 3 replicas (configurable)
- **Service**: ClusterIP with load balancing
- **Ingress**: HTTPS with Let's Encrypt
- **StatefulSet**: Redis with persistent storage
- **ConfigMap**: Non-secret configuration
- **Secret**: API keys and credentials

**High Availability**:
- Rolling updates (zero downtime)
- Pod anti-affinity
- Liveness/readiness probes
- Resource limits and requests
- Horizontal Pod Autoscaling

#### Deployment Options

1. **Local Development**: Docker Compose
2. **Kubernetes**: Production orchestration
3. **Vercel**: Serverless deployment

## Data Flow

### 1. Fitness Plan Generation

```
User Request (Mobile App)
    │
    ▼
API Endpoint (/api/v1/simpleclaw/fitness-plan)
    │
    ▼
SimpleClaw Orchestrator
    │
    ├──► Retrieve User Memory (MemuBot)
    │    └──► Past workouts, preferences, patterns
    │
    ├──► Adaptive Workflow Engine
    │    └──► Analyze patterns, generate insights
    │
    ├──► Prompt Engineering
    │    └──► Create enhanced prompt with context
    │
    ▼
Gemini AI (2.5 Flash)
    │
    ▼
Response Processing
    │
    ├──► Store in Memory (MemuBot)
    └──► Return to User
```

### 2. Proactive Motivation

```
Background Job / Scheduled Check
    │
    ▼
MemuBot Proactive Engine
    │
    ├──► Analyze User Patterns
    │    └──► Inactivity, goal deadlines, plateaus
    │
    ├──► Check Motivation Triggers
    │    └──► Days since workout, mood patterns
    │
    ▼
Decision: Send Motivation?
    │
    ├──► No: Skip
    │
    └──► Yes:
         │
         ├──► Retrieve Motivation History
         ├──► Generate Personalized Message
         ├──► Send Notification
         └──► Store Interaction
```

### 3. Adaptive Learning Loop

```
User Interaction
    │
    ▼
Store in Memory (MemuBot)
    │
    ▼
Pattern Recognition
    │
    ├──► Time patterns
    ├──► Exercise preferences
    ├──► Compliance patterns
    └──► Success factors
    │
    ▼
Update User Model
    │
    ▼
Next Interaction Uses Learned Patterns
    │
    └──► Better recommendations
         └──► Higher success rate
              └──► More learning...
```

## Security Architecture

### Authentication Flow

```
User Login
    │
    ▼
Supabase Auth
    │
    ├──► Email/Password
    ├──► Google OAuth
    └──► Social Providers
    │
    ▼
JWT Token Generated
    │
    ▼
Store in Secure Storage
    │
    ▼
Include in API Requests
    │
    └──► Bearer Token in Header
```

### Security Layers

1. **Transport Security**
   - TLS/SSL encryption
   - Certificate management (Let's Encrypt)
   - HTTPS enforced

2. **Authentication**
   - JWT tokens
   - OAuth 2.0
   - Session management

3. **Authorization**
   - Role-based access control (RBAC)
   - User data isolation
   - API key validation

4. **Application Security**
   - Input validation (Pydantic)
   - SQL injection prevention (ORM)
   - XSS protection
   - CSRF tokens
   - Rate limiting

5. **Infrastructure Security**
   - Container security scanning
   - Non-root containers
   - Read-only filesystems
   - Network policies
   - Secrets management

6. **Data Security**
   - Encryption at rest
   - Encryption in transit
   - Data anonymization
   - GDPR compliance

## Scalability

### Horizontal Scaling

```
Load Balancer (Kubernetes Ingress)
    │
    ├──► Backend Pod 1
    ├──► Backend Pod 2
    ├──► Backend Pod 3
    ├──► Backend Pod 4
    └──► Backend Pod N
    
Each pod:
- Independent FastAPI instance
- Shared Redis cache
- Shared Supabase DB
- Stateless (session in Redis)
```

### Auto-Scaling Strategy

**Metrics for Scaling**:
- CPU utilization > 70%
- Memory usage > 80%
- Request queue depth > 10
- Response time > 1s

**HPA Configuration**:
```yaml
minReplicas: 3
maxReplicas: 10
targetCPUUtilization: 70%
targetMemoryUtilization: 80%
```

### Caching Strategy

1. **Application Level**
   - In-memory caching (TTL)
   - Response caching

2. **Redis Level**
   - Session data (30 min TTL)
   - Leaderboards (5 min TTL)
   - User preferences (1 hour TTL)

3. **CDN Level** (Future)
   - Static assets
   - API responses (selective)

## Monitoring & Observability

### Metrics

**Application Metrics**:
- Request rate
- Response time (p50, p95, p99)
- Error rate
- Active connections

**Business Metrics**:
- Active users
- Plans generated
- Workouts completed
- Retention rate

**Infrastructure Metrics**:
- CPU usage
- Memory usage
- Disk I/O
- Network throughput

### Logging

**Log Levels**:
- ERROR: Application errors
- WARNING: Degraded performance
- INFO: Important events
- DEBUG: Detailed debugging

**Structured Logging**:
```python
logger.info("Fitness plan generated", extra={
    "user_id": user_id,
    "duration_days": 30,
    "workflow": "learning_fitness_plan",
    "execution_time": 2.3
})
```

### Health Checks

**Endpoints**:
- `/health` - Basic health check
- `/health/live` - Liveness probe
- `/health/ready` - Readiness probe

**Checks**:
- ✅ API server running
- ✅ Database connectivity
- ✅ Redis connectivity
- ✅ External API availability

## Performance Optimization

### Database Optimization

1. **Connection Pooling**
   - Pool size: 20
   - Max overflow: 10
   - Pool recycle: 3600s

2. **Query Optimization**
   - Indexes on foreign keys
   - Composite indexes
   - Query explain analysis

3. **Caching**
   - Redis for frequently accessed data
   - Application-level caching

### API Optimization

1. **Async Operations**
   - All I/O operations async
   - Concurrent request handling

2. **Response Compression**
   - Gzip compression
   - Payload optimization

3. **Connection Reuse**
   - HTTP connection pooling
   - Persistent connections

## Disaster Recovery

### Backup Strategy

1. **Database Backups**
   - Supabase automatic backups
   - Daily snapshots
   - 30-day retention

2. **Redis Backups**
   - Periodic RDB snapshots
   - AOF persistence
   - Separate storage

3. **Application State**
   - Stateless design
   - Session in Redis
   - Easy recovery

### Recovery Procedures

**RTO (Recovery Time Objective)**: < 1 hour
**RPO (Recovery Point Objective)**: < 24 hours

**Steps**:
1. Restore database from backup
2. Redeploy application pods
3. Restore Redis from snapshot
4. Verify health checks
5. Resume traffic

## Future Enhancements

### Planned Features

1. **Voice Integration**
   - Wispr Flow integration
   - Voice-activated workouts
   - Audio coaching

2. **Advanced Analytics**
   - ML-powered insights
   - Predictive analytics
   - Trend analysis

3. **Wearable Integration**
   - Fitbit sync
   - Apple Watch integration
   - Google Fit integration

4. **Social Features**
   - Challenges
   - Group workouts
   - Community sharing

### Technical Improvements

1. **Microservices**
   - Split into specialized services
   - Service mesh (Istio)
   - Event-driven architecture

2. **AI Enhancements**
   - Multi-model support
   - Fine-tuned models
   - Edge AI deployment

3. **Performance**
   - GraphQL API
   - Server-side rendering
   - Progressive Web App

## Technology Stack Summary

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Frontend** | Flutter 3.24.5 | Cross-platform mobile |
| **Backend** | FastAPI + Python 3.10 | REST API |
| **AI Core** | Gemini 2.5 Flash | AI generation |
| **Workflow** | SimpleClaw | Orchestration |
| **Memory** | MemuBot | Adaptive learning |
| **Database** | Supabase (PostgreSQL) | Primary data store |
| **Cache** | Redis | Session & real-time |
| **Container** | Docker | Containerization |
| **Orchestration** | Kubernetes | Production deployment |
| **Proxy** | Nginx | Reverse proxy |
| **Monitoring** | Prometheus + Grafana | Metrics & dashboards |
| **Logging** | ELK Stack | Log aggregation |

## Conclusion

Fitola's architecture is designed for:
- ✅ **Scalability**: Handles growth seamlessly
- ✅ **Reliability**: High availability and fault tolerance
- ✅ **Security**: Defense in depth
- ✅ **Performance**: Optimized for speed
- ✅ **Maintainability**: Clean, modular code
- ✅ **Intelligence**: Self-improving AI

The combination of SimpleClaw workflow orchestration and MemuBot adaptive AI creates a truly intelligent fitness coaching platform that learns and improves with every interaction.

---

**Architecture Version**: 2.0  
**Last Updated**: 2026-02-07  
**Maintained By**: Fitola Engineering Team
