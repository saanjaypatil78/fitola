# SkillKit Integration Guide for Fitola

## 🎯 Overview

SkillKit is integrated into Fitola to provide universal skill management across 32+ AI coding agents, enabling seamless development workflows and AGI team coordination.

## 🚀 Quick Start

### Installation

```bash
# SkillKit is already installed as a dev dependency
npm install

# Initialize SkillKit for your preferred agent
npx skillkit init

# Sync skills to all configured agents
npx skillkit sync
```

## 📦 What is SkillKit?

**SkillKit** is the universal package manager for AI agent skills. Write a skill once, deploy it to Claude, Cursor, Copilot, Windsurf, and 28 other agents automatically.

### Key Features

1. **Universal Compatibility**: One skill format works across all 32 agents
2. **15,000+ Skills**: Access pre-built skills from the marketplace
3. **Auto-Translation**: Skills automatically translate between agent formats
4. **Memory System**: Agents learn and improve over time
5. **Smart Recommendations**: Get skill suggestions based on your project
6. **Runtime Discovery**: Agents find and load skills on-demand

## 🏗️ Fitola Skill Architecture

```
fitola/
├── skills/                      # Custom Fitola skills
│   ├── fitola-flutter/          # Flutter development skills
│   │   ├── SKILL.md
│   │   └── scripts/
│   ├── fitola-backend/          # FastAPI backend skills
│   │   ├── SKILL.md
│   │   └── scripts/
│   ├── fitola-ai-integration/   # Gemini AI skills
│   │   ├── SKILL.md
│   │   └── scripts/
│   ├── fitola-testing/          # Testing automation skills
│   │   ├── SKILL.md
│   │   └── scripts/
│   └── fitola-deployment/       # Deployment skills
│       ├── SKILL.md
│       └── scripts/
├── skillkit.yaml                # SkillKit configuration
├── AGENTS.md                    # Agent configurations
└── .skillkit/                   # SkillKit internal directory
    ├── agents/                  # Agent-specific configurations
    ├── marketplace/             # Downloaded marketplace skills
    └── cache/                   # Skill cache
```

## 📝 Creating Custom Skills

### Skill Structure

```
skills/my-skill/
├── SKILL.md                     # Skill definition
├── README.md                    # Documentation
├── scripts/                     # Executable scripts
│   ├── setup.py
│   ├── build.sh
│   └── test.js
└── examples/                    # Usage examples
    └── example.md
```

### SKILL.md Format

```markdown
---
name: fitola-flutter-widget-generator
description: Generates Flutter widgets following Fitola design patterns
version: 1.0.0
author: Fitola Team
tags: [flutter, widgets, ui, mobile]
requires: [flutter-3.24+]
---

# Fitola Flutter Widget Generator

Generates custom Flutter widgets following Fitola's Material Design 3 patterns.

## Usage

When asked to create a new Flutter widget:

1. Analyze the design requirements
2. Choose appropriate Material Design 3 components
3. Implement responsive layouts
4. Add theme support (light/dark modes)
5. Include accessibility features
6. Generate comprehensive widget tests

## Patterns

### Widget Structure
```dart
class CustomWidget extends StatelessWidget {
  const CustomWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      // Implementation
    );
  }
}
```

### Theme Integration
```dart
final theme = Theme.of(context);
final colorScheme = theme.colorScheme;
```

## Examples

See `examples/` directory for complete widget examples.
```

## 🎨 Fitola-Specific Skills

### 1. Flutter Development

```bash
# Install Flutter skill
skillkit install ./skills/fitola-flutter

# Use in agent
"Generate a workout card widget using Fitola patterns"
```

**Includes:**
- Widget generation
- State management patterns
- UI/UX best practices
- Responsive design
- Accessibility features

### 2. Backend API Development

```bash
# Install backend skill
skillkit install ./skills/fitola-backend

# Use in agent
"Create a new FastAPI endpoint for workout tracking"
```

**Includes:**
- FastAPI endpoints
- Pydantic models
- Database schemas
- Authentication
- Error handling

### 3. AI Integration

```bash
# Install AI skill
skillkit install ./skills/fitola-ai-integration

# Use in agent
"Implement Gemini AI feature for nutrition planning"
```

**Includes:**
- Gemini AI integration
- Prompt engineering
- Response parsing
- Error handling
- Rate limiting

### 4. Testing Automation

```bash
# Install testing skill
skillkit install ./skills/fitola-testing

# Use in agent
"Generate unit tests for the workout service"
```

**Includes:**
- Unit test generation
- Integration tests
- E2E test scenarios
- Mock data creation
- Coverage analysis

### 5. Deployment

```bash
# Install deployment skill
skillkit install ./skills/fitola-deployment

# Use in agent
"Deploy backend to Vercel with health checks"
```

**Includes:**
- CI/CD pipelines
- Docker configuration
- Kubernetes manifests
- Health checks
- Monitoring setup

## 🔧 SkillKit Commands

### Basic Commands

```bash
# Initialize SkillKit
npx skillkit init

# List available skills
npx skillkit list

# Search marketplace
npx skillkit search <query>

# Install skill
npx skillkit install <skill-name>

# Uninstall skill
npx skillkit uninstall <skill-name>

# Sync skills to agents
npx skillkit sync

# View skill documentation
npx skillkit read <skill-name>
```

### Advanced Commands

```bash
# Get smart recommendations
npx skillkit recommend

# Translate skill format
npx skillkit translate <skill> --to cursor

# Translate all skills
npx skillkit translate --all --to windsurf

# Start skill API server
npx skillkit serve

# Publish skill to marketplace
npx skillkit publish <skill-directory>

# Update all skills
npx skillkit update

# Check skill status
npx skillkit status
```

## 🌐 Marketplace Skills

### Recommended Skills for Fitola

```bash
# Code quality
skillkit install anthropics/code-review
skillkit install github/security-audit

# Framework-specific
skillkit install flutter/material-design
skillkit install python/fastapi-patterns

# Testing
skillkit install testing/e2e-automation
skillkit install testing/coverage-analyzer

# DevOps
skillkit install vercel/deployment
skillkit install docker/containerization

# AI/ML
skillkit install google/gemini-integration
skillkit install openai/prompt-engineering
```

## 🔄 Agent Configuration

### Supported Agents

SkillKit works with these agents:

1. **Claude Code** (`.claude/skills/`)
2. **Cursor** (`.cursor/skills/`)
3. **GitHub Copilot** (`.github/skills/`)
4. **Windsurf** (`.windsurf/skills/`)
5. **Cline**
6. **Codex**
7. **Gemini Code**
8. **OpenCode**
9. **And 24 more...**

### Agent Priority

Configure agent priority in `skillkit.yaml`:

```yaml
agents:
  priority:
    - claude-code
    - cursor
    - copilot
  
  config:
    claude-code:
      model: opus
      skills_dir: .claude/skills
    
    cursor:
      model: sonnet
      skills_dir: .cursor/skills
```

## 📊 Skill Recommendations

SkillKit analyzes your project and recommends relevant skills:

```bash
$ npx skillkit recommend

🎯 Smart Recommendations for Fitola

Based on your project stack (Flutter, Python, FastAPI):

● 92% vercel-deployment
   Deploy FastAPI apps to Vercel with zero config
   
● 87% flutter-material-3
   Material Design 3 component library
   
● 85% fastapi-best-practices
   FastAPI patterns and best practices
   
● 82% gemini-ai-integration
   Google Gemini AI integration patterns
   
● 78% supabase-patterns
   Supabase auth and database patterns

Install all: npx skillkit install --recommended
```

## 💾 Memory System

SkillKit includes a memory system for persistent agent learning:

```yaml
# skillkit.yaml
memory:
  enabled: true
  provider: mcp-memory
  storage: .skillkit/memory
  
  contexts:
    - fitola-patterns
    - code-conventions
    - architecture-decisions
    - user-preferences
```

### Memory Features

- **Pattern Learning**: Agents learn project patterns over time
- **Convention Memory**: Remembers coding conventions
- **Decision History**: Stores architectural decisions
- **User Preferences**: Learns developer preferences

## 🔐 Security

### Skill Validation

All skills are validated before execution:

- Input validation
- File path security
- Script sandboxing
- Size and pattern checks

### Trusted Sources

```yaml
# skillkit.yaml
security:
  trusted_sources:
    - anthropics/
    - github/
    - vercel/
    - ./skills/
  
  allow_remote: false
  require_signature: true
```

## 🚦 CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/skillkit.yml
name: SkillKit Sync

on:
  push:
    paths:
      - 'skills/**'
      - 'skillkit.yaml'

jobs:
  sync-skills:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - name: Install SkillKit
        run: npm install -D skillkit
      - name: Sync skills
        run: npx skillkit sync --validate
```

## 📈 Metrics & Analytics

Track skill usage and performance:

```bash
# View skill metrics
npx skillkit metrics

# Skill usage
npx skillkit stats <skill-name>

# Team analytics
npx skillkit analytics --team
```

## 🔗 API Server Mode

Run SkillKit as an API server for runtime skill discovery:

```bash
# Start server
npx skillkit serve --port 3000

# API endpoints
GET  /api/skills              # List all skills
GET  /api/skills/:name        # Get skill details
POST /api/skills/:name/invoke # Invoke skill
GET  /api/recommend           # Get recommendations
```

## 🛠️ Troubleshooting

### Skill Not Loading

```bash
# Verify skill format
npx skillkit validate ./skills/my-skill

# Check agent configuration
npx skillkit status

# Re-sync skills
npx skillkit sync --force
```

### Translation Issues

```bash
# Debug translation
npx skillkit translate my-skill --to cursor --debug

# Verify compatibility
npx skillkit check-compat my-skill
```

### Performance Issues

```bash
# Clear cache
npx skillkit cache clear

# Optimize skill loading
npx skillkit optimize

# View performance metrics
npx skillkit metrics --performance
```

## 📚 Resources

- **Official Documentation**: https://agenstskills.com/docs
- **Skill Marketplace**: https://agenstskills.com/marketplace
- **API Reference**: https://agenstskills.com/api
- **GitHub**: https://github.com/rohitg00/skillkit
- **Discord Community**: [Join us]

## 🎯 Best Practices

1. **Modular Skills**: Keep skills focused and single-purpose
2. **Clear Documentation**: Write comprehensive SKILL.md files
3. **Version Control**: Use semantic versioning for skills
4. **Testing**: Include tests for skill scripts
5. **Security**: Validate inputs and sandbox scripts
6. **Compatibility**: Test skills across multiple agents
7. **Updates**: Keep skills updated with latest patterns

## 🔄 Migration Guide

### From Custom Scripts to SkillKit

Before:
```bash
./scripts/generate-widget.sh MyWidget
```

After:
```bash
skillkit install ./skills/fitola-flutter
# Agent automatically uses skill: "Generate MyWidget"
```

### From Agent-Specific Skills

Before:
```
.claude/skills/widget-gen.md
.cursor/skills/widget-gen.mdc
.github/skills/widget-gen.md
```

After:
```
skills/fitola-flutter/SKILL.md  # Works everywhere!
```

## 🎉 Success Stories

> "SkillKit reduced our onboarding time from 2 weeks to 2 days. New developers can immediately use our custom skills across any agent." - *Fitola Engineering*

> "We went from maintaining 32 different skill formats to just one. SkillKit is a game-changer." - *Development Team*

---

**Powered by SkillKit** 🚀

*One Skill. 32 Agents. Infinite Possibilities.*
