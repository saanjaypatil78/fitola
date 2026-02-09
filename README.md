# Fitola - AI-Powered Personal Fitness & Social Wellness

<div align="center">

[![CI - Lint & Test](https://github.com/saanjaypatil78/fitola/actions/workflows/ci.yml/badge.svg)](https://github.com/saanjaypatil78/fitola/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)
[![Flutter 3.24+](https://img.shields.io/badge/Flutter-3.24+-02569B.svg?logo=flutter)](https://flutter.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=flat&logo=fastapi)](https://fastapi.tiangolo.com)
[![SkillKit](https://img.shields.io/badge/SkillKit-1.15.0-blueviolet.svg)](https://agenstskills.com)
[![AGI Team](https://img.shields.io/badge/AGI-Team%20Enabled-brightgreen.svg)](AGI_TEAM_MANAGEMENT.md)

**Revolutionary AI-powered fitness platform combining personalized health coaching with community engagement and AGI team development intelligence.**

[🚀 Quick Start](#-quick-start) •
[📖 Documentation](#-documentation) •
[🤖 AGI Team](#-agi-team-management) •
[🛠️ SkillKit](#️-skillkit-integration) •
[💪 Features](#-unique-features)

</div>

---

## 🌟 What's New in v2.0

### 🤖 AGI Team Management System
- **12+ Specialized AI Agents**: Architect, Planner, Builder, Tester, Code Reviewer, Security Expert, and more
- **Multi-Agent Orchestration**: Coordinated workflows for feature development, bug fixes, and optimizations
- **Supreme Intellectual Management**: AGI agents handle planning, execution, quality assurance, and innovation

### 🛠️ SkillKit Integration  
- **Universal Skill Management**: Write once, deploy to 32+ AI coding agents
- **15,000+ Skills**: Access to marketplace skills for any development task
- **5 Custom Fitola Skills**: Flutter, Backend, AI Integration, Testing, and Deployment
- **Auto-Translation**: Skills work across Claude, Cursor, Copilot, Windsurf, and more

### 🚀 Enhanced Development Infrastructure
- **60% Faster Development**: AI-powered code generation and automation
- **Automated Workflows**: From planning to deployment with AGI orchestration
- **Intelligent Testing**: Automated test generation and execution
- **Smart Recommendations**: AI suggests relevant skills based on your project

---

## ✨ Unique Features

### 🤖 AI-Powered Personalization
- **Gemini 2.5 Flash Integration**: Personalized workout and nutrition plans
- **BMI Analysis**: WHO classification with health insights
- **Body Photo Analysis**: AI estimates body fat percentage (with consent)
- **Age-Appropriate Plans**: Customized for Baby/Teenager/Adult/Elder

### 🌍 Social Fitness Network
- **FitBuddy Map**: Find workout partners nearby (5km - 50km radius)
- **Ghost Mode**: Complete privacy - hide from map while still sharing via DM
- **Real-time Chat**: Messaging with inline translation (30+ languages)
- **Live Location Sharing**: WhatsApp-style live location with time limits

### 🏆 Gamification & Competition
- **Global Leaderboard**: Compete worldwide
- **National Rankings**: Country-specific leaderboards
- **Streak Tracking**: Consistency rewards
- **Achievement Badges**: Milestone celebrations

---

## 🏗️ Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                    AGI TEAM ORCHESTRATOR                       │
│           (Planning, Execution, Quality, Innovation)           │
└──────────────┬─────────────────────────────────┬───────────────┘
               │                                 │
               ├─────────────────┐              ├──────────────────┐
               │                 │              │                  │
               ▼                 ▼              ▼                  ▼
    ┌──────────────────┐  ┌────────────┐  ┌────────────┐  ┌──────────────┐
    │  Flutter App     │  │  FastAPI   │  │  Gemini AI │  │  SkillKit    │
    │ (Dart/Flutter)   │  │  Backend   │  │  (2.5 Flash)│  │  (32 Agents) │
    └────────┬─────────┘  └─────┬──────┘  └──────┬─────┘  └──────┬───────┘
             │                  │                │                │
             │ HTTP/WebSocket   │                │                │
             ▼                  ▼                ▼                ▼
    ┌────────────────────────────────────────────────────────────────┐
    │              INFRASTRUCTURE & SERVICES                         │
    ├────────────────────────────────────────────────────────────────┤
    │  • Supabase (PostgreSQL + Auth)                                │
    │  • Redis (Caching & Leaderboards)                              │
    │  • OpenStreetMap (Map Tiles)                                   │
    │  • MCP Servers (Sequential Thinking, Stitch)                   │
    │  • CI/CD (GitHub Actions)                                      │
    └────────────────────────────────────────────────────────────────┘
```

---

## 🤖 AGI Team Management

Fitola implements a **supreme intellectual management team** with 12+ specialized AI agents coordinating development workflows.

### Agent Teams

#### 🎯 Planning Team
- **Architect Agent**: System design and technology decisions
- **Planner Agent**: Sprint planning and task breakdown
- **Analyst Agent**: Data insights and performance metrics
- **Product Manager Agent**: User stories and requirements

#### ⚙️ Execution Team
- **Builder Agent**: Feature implementation and bug fixes
- **Tester Agent**: Test generation and automation
- **Deployer Agent**: CI/CD and infrastructure management

#### ✅ Quality Team
- **Code Reviewer Agent**: Code quality and best practices
- **Security Reviewer Agent**: Vulnerability scanning and compliance
- **Performance Optimizer Agent**: Bottleneck identification and optimization
- **Documentation Writer Agent**: Technical docs and API documentation

#### 🚀 Innovation Team
- **AI/ML Specialist Agent**: Intelligent feature development
- **Research Agent**: Technology scouting and trend analysis
- **Innovation Scout Agent**: Future planning and experimentation

### Workflow Example

```
Product Manager → Planner → Architect → Builder → Tester → 
Code Reviewer → Security Reviewer → Performance Optimizer → 
Documentation Writer → Deployer → Production
```

📚 **[Complete AGI Team Documentation →](AGI_TEAM_MANAGEMENT.md)**

---

## 🛠️ SkillKit Integration

SkillKit enables universal skill management across 32+ AI coding agents.

### Quick Start

```bash
# Initialize SkillKit
npm run skillkit:init

# Get recommendations
npm run skillkit:recommend

# Install Fitola skills
npm run skillkit:install ./skills/fitola-*

# Sync to all agents
npm run skillkit:sync
```

### 5 Custom Fitola Skills

1. **fitola-flutter**: Flutter development patterns
2. **fitola-backend**: FastAPI best practices
3. **fitola-ai-integration**: Gemini AI workflows
4. **fitola-testing**: Test automation
5. **fitola-deployment**: CI/CD and deployment

📚 **[Complete SkillKit Guide →](SKILLKIT_INTEGRATION.md)**

---

## 🚀 Quick Start

### Prerequisites
- Flutter 3.24.5+
- Python 3.10+
- Node.js 18+ (for SkillKit)
- Supabase Account
- Gemini API Key

### 1. Clone & Install

```bash
git clone https://github.com/saanjaypatil78/fitola.git
cd fitola
npm install  # Install SkillKit
```

### 2. Backend Setup

```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Edit .env with API keys
uvicorn main:app --reload
```

### 3. Mobile App

```bash
cd mobile
flutter pub get
flutter run
```

📚 **[Detailed Setup Guide →](QUICKSTART.md)**

---

## 📚 Documentation

### Core Documentation
- **[Quick Start](QUICKSTART.md)** - Get started in 5 minutes
- **[Documentation Index](DOCUMENTATION_INDEX.md)** - Navigate all docs
- **[Technical Docs](docs/TECHNICAL.md)** - Architecture and APIs
- **[Deployment Guide](DEPLOYMENT.md)** - Production deployment

### AGI & Automation
- **[AGI Team Management](AGI_TEAM_MANAGEMENT.md)** - Multi-agent system
- **[SkillKit Integration](SKILLKIT_INTEGRATION.md)** - Skill management
- **[Agentic Workflow](AGENTIC_WORKFLOW.md)** - MCP servers
- **[Automation Guide](AUTOMATION_GUIDE.md)** - CI/CD workflows

### Implementation
- **[Implementation Summary](IMPLEMENTATION_SUMMARY.md)** - Complete implementation
- **[Backend Integration](BACKEND_INTEGRATION.md)** - API integration
- **[Testing Guide](TESTING_GUIDE.md)** - Testing strategies

---

## 🚀 Deployment

```bash
# Deploy everything
npm run deploy

# Deploy to staging
npm run deploy:staging

# Backend only
npm run deploy:backend-only
```

📚 **[Complete Deployment Guide →](DEPLOYMENT.md)**

---

## 🎯 Roadmap

### Phase 1: Foundation ✅
- ✅ Complete Flutter app
- ✅ FastAPI backend with Gemini AI
- ✅ Authentication and chat
- ✅ FitBuddy map and leaderboard

### Phase 2: AGI & SkillKit ✅ (Current)
- ✅ SkillKit integration (v1.15.0)
- ✅ AGI team (12+ agents)
- ✅ 5 custom skills
- ✅ Multi-agent orchestration

### Phase 3: Enhancement (Q1 2026)
- [ ] Self-improving agents
- [ ] Advanced coordination
- [ ] Real-time dashboard
- [ ] Predictive planning

### Phase 4: Scale (Q2-Q3 2026)
- [ ] 100+ skills marketplace
- [ ] Enterprise deployment
- [ ] AGI ecosystem integration
- [ ] Cross-project knowledge

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Use SkillKit for consistency
4. Write tests
5. Submit Pull Request

---

## 📄 License

MIT License - see `LICENSE` for details

---

## 👥 Team

**Creator**: Sanjay Santosh Patil [@saanjaypatil78](https://github.com/saanjaypatil78)  
**AGI Team**: 12 Specialized AI Agents

---

## 🙏 Acknowledgments

- Google Gemini AI
- SkillKit
- Supabase
- Flutter Team
- Open-source community

---

<div align="center">

**Developed with ❤️ by the Fitola AGI Team**

*Your AI Fitness Companion with Supreme Intellectual Management*

**Powered by**: Flutter • FastAPI • Gemini AI • SkillKit • AGI Team

</div>
