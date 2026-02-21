# SimpleClaw Integration for Fitola

## Overview

This document describes the **SimpleClaw integration** implemented in Fitola to provide simplified AI workflow orchestration while avoiding the complexity of OpenClaw setup.

## What is SimpleClaw?

**SimpleClaw** is a lightweight deployment wrapper for AI workflow orchestration that provides:
- ✅ **Zero-configuration** setup
- ✅ **One-click execution** of AI workflows  
- ✅ **Instant deployment** (< 1 minute)
- ✅ **Simplified architecture** avoiding OpenClaw complexity
- ✅ **Enhanced prompt engineering** for better AI responses

## Why SimpleClaw Instead of OpenClaw?

### OpenClaw Challenges:
- Complex multi-stage pipeline setup
- Requires extensive configuration
- Heavy infrastructure requirements
- Steep learning curve
- Over-engineered for simple use cases

### SimpleClaw Benefits:
- 🚀 Simple, direct API calls
- 🎯 Focus on fitness domain
- 💡 Advanced prompt engineering built-in
- 🔄 Persistent memory without complexity
- 📦 Minimal dependencies

## Architecture

```
┌─────────────────────────────────────────┐
│         FastAPI Main Application        │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│     SimpleClaw Orchestrator             │
│  (simpleclaw_integration.py)            │
│                                          │
│  • WorkflowManager                      │
│  • Session Management                   │
│  • Memory Persistence                   │
└─────────────────┬───────────────────────┘
                  │
       ┌──────────┼──────────┐
       ▼          ▼           ▼
┌──────────┐ ┌──────────┐ ┌──────────┐
│ Fitness  │ │ Nutrition│ │   Chat   │
│ Workflow │ │ Workflow │ │ Workflow │
└─────┬────┘ └─────┬────┘ └─────┬────┘
      │            │            │
      └────────────┴────────────┘
                   │
                   ▼
      ┌────────────────────────┐
      │  Prompt Engineering     │
      │  (prompt_engineering.py)│
      │                         │
      │  • Context Building     │
      │  • Format Specification │
      │  • Safety Instructions  │
      └────────────┬────────────┘
                   │
                   ▼
           ┌───────────────┐
           │ Gemini 2.5    │
           │ Flash API     │
           └───────────────┘
```

## Core Components

### 1. SimpleClaw Orchestrator (`simpleclaw_integration.py`)

The main orchestrator that manages workflows:

```python
from simpleclaw_integration import get_simpleclaw_orchestrator

orchestrator = get_simpleclaw_orchestrator(gemini_client)

result = await orchestrator.start_workflow(
    user_id="user123",
    workflow_type="fitness_plan",
    user_data={...},
    parameters={...}
)
```

**Features:**
- Workflow execution management
- Session tracking
- Persistent memory per user
- Automatic context storage

### 2. Prompt Engineering Module (`prompt_engineering.py`)

Advanced prompt engineering for better AI responses:

```python
from prompt_engineering import FitnessPromptEngine

engine = FitnessPromptEngine()

# Generate enhanced prompts
prompt = engine.create_fitness_plan_prompt(
    user_context={...},
    parameters={...},
    history=[...]
)
```

**Techniques Applied:**
- ✅ Clear role definition
- ✅ Structured context formatting
- ✅ Specific output format requirements
- ✅ Safety constraints
- ✅ History-aware prompting
- ✅ Few-shot examples when needed

### 3. Workflow Types

Five specialized workflows:

1. **`fitness_plan`** - Generate personalized workout plans
2. **`nutrition_plan`** - Create meal and nutrition plans
3. **`chat_assistant`** - Context-aware fitness coaching
4. **`goal_tracking`** - Progress analysis and feedback
5. **`motivation`** - Personalized encouragement

## API Endpoints

### 1. Execute Workflow

**POST** `/api/v1/simpleclaw/workflow`

Execute any SimpleClaw workflow with one API call.

```json
{
  "user_id": "user123",
  "workflow_type": "fitness_plan",
  "user_data": {
    "age": 30,
    "weight": 75,
    "height": 180,
    "body_type": "Mesomorph",
    "goals": ["Weight Loss", "Muscle Gain"]
  },
  "parameters": {
    "duration_days": 30,
    "experience_level": "Intermediate"
  }
}
```

**Response:**
```json
{
  "session_id": "user123_fitness_plan_1675789234.56",
  "workflow_result": {
    "workflow": "fitness_plan",
    "status": "completed",
    "plan": "...[detailed plan]...",
    "timestamp": "2026-02-07T17:52:24.788Z"
  },
  "status": "success"
}
```

### 2. Simplified Chat

**POST** `/api/v1/simpleclaw/chat`

Context-aware fitness coaching chat:

```json
{
  "user_id": "user123",
  "message": "What exercises should I do for lower back pain?",
  "user_data": {
    "age": 35,
    "goals": ["Pain Management"]
  }
}
```

### 3. Get Session Info

**GET** `/api/v1/simpleclaw/session/{session_id}`

Retrieve information about a workflow session.

### 4. Get User Memory

**GET** `/api/v1/simpleclaw/memory/{user_id}`

Access user's interaction history for context.

### 5. Enhanced Fitness Plan

**POST** `/api/v1/simpleclaw/fitness-plan`

Alternative to standard fitness plan endpoint with better prompting:

```json
{
  "user_id": "user123",
  "age_group": "Adult",
  "weight": 75.0,
  "height": 180.0,
  "body_type": "Mesomorph",
  "goals": ["Weight Loss"],
  "duration_days": 30
}
```

### 6. Enhanced Nutrition Plan

**POST** `/api/v1/simpleclaw/nutrition-plan`

Alternative to standard nutrition endpoint with detailed meal plans.

## Prompt Engineering Details

### Fitness Plan Prompts

Enhanced prompts include:

1. **System Role**: Expert AI fitness coach definition
2. **User Profile**: Comprehensive physical and experience data
3. **Goals**: Clear fitness objectives
4. **Context History**: Recent interactions for continuity
5. **Output Format**: Structured day-by-day breakdown
6. **Safety**: Age-appropriate and limitation-aware

**Example Prompt Structure:**
```
You are an expert AI fitness coach with deep knowledge in...

## USER PROFILE
- Age: 30 years (Adult)
- Physical Stats: 75kg, 180cm
- Body Type: Mesomorph
...

## TASK
Create a comprehensive, personalized 30-day fitness plan that:
1. Progression: Start at appropriate intensity...
2. Safety First: Consider age, limitations...
...

## OUTPUT FORMAT
### Overview
[Brief summary]

### Weekly Breakdown
**Day 1: [Focus Area]**
- Warm-up: [5-10 minutes]
...
```

### Nutrition Plan Prompts

Include:
- Calculated BMR and TDEE
- Macro/micronutrient requirements
- Local ingredient preferences
- Allergy safety
- Meal timing optimization

### Chat Prompts

Feature:
- User context awareness
- Conversation history
- Goal-aligned responses
- Safety reminders
- Encouraging tone

## Memory and Context Management

SimpleClaw maintains persistent memory:

```python
# Automatic memory storage
orchestrator._store_context(
    user_id="user123",
    workflow_type="fitness_plan",
    context={...},
    parameters={...}
)

# Retrieve for context-aware responses
history = orchestrator.get_user_memory("user123")
# Returns last 10 interactions
```

**Memory Structure:**
```python
{
    "timestamp": "2026-02-07T17:52:24.788Z",
    "workflow": "fitness_plan",
    "context": {...},
    "parameters": {...}
}
```

## Comparison: Standard vs SimpleClaw Endpoints

| Feature | Standard Endpoints | SimpleClaw Endpoints |
|---------|-------------------|---------------------|
| **Setup** | None required | None required |
| **Prompting** | Basic | Advanced engineering |
| **Context** | Stateless | Persistent memory |
| **Output Quality** | Good | Better/More detailed |
| **Personalization** | Limited | High |
| **History Awareness** | No | Yes |
| **Safety Checks** | Basic | Enhanced |

## Usage Examples

### Example 1: Generate Fitness Plan

```python
import httpx

async def create_fitness_plan():
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "http://localhost:8000/api/v1/simpleclaw/workflow",
            json={
                "user_id": "john_doe",
                "workflow_type": "fitness_plan",
                "user_data": {
                    "age": 28,
                    "weight": 80,
                    "height": 175,
                    "body_type": "Ectomorph",
                    "goals": ["Muscle Gain"]
                },
                "parameters": {
                    "duration_days": 30,
                    "experience_level": "Beginner",
                    "equipment": "Gym access"
                }
            }
        )
        return response.json()
```

### Example 2: Context-Aware Chat

```python
async def chat_with_ai():
    async with httpx.AsyncClient() as client:
        # First interaction
        response1 = await client.post(
            "http://localhost:8000/api/v1/simpleclaw/chat",
            json={
                "user_id": "jane_smith",
                "message": "I want to lose weight",
                "user_data": {"age": 32, "weight": 70}
            }
        )
        
        # Second interaction - has context from first
        response2 = await client.post(
            "http://localhost:8000/api/v1/simpleclaw/chat",
            json={
                "user_id": "jane_smith",
                "message": "How many calories should I eat?",
                "user_data": {"age": 32, "weight": 70}
            }
        )
        # AI remembers the weight loss goal!
```

### Example 3: Track Progress

```python
async def track_goal():
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "http://localhost:8000/api/v1/simpleclaw/workflow",
            json={
                "user_id": "mike_jones",
                "workflow_type": "goal_tracking",
                "user_data": {
                    "goals": ["Weight Loss"]
                },
                "parameters": {
                    "goal": "Lose 5kg",
                    "days_elapsed": 15,
                    "current_progress": {
                        "weight_lost": "2.5kg",
                        "workouts_completed": 12,
                        "diet_adherence": "85%"
                    }
                }
            }
        )
        return response.json()
```

## Best Practices

### 1. Provide Rich User Context

Always include comprehensive user data:
```python
user_data = {
    "age": 30,
    "age_group": "Adult",
    "weight": 75,
    "height": 180,
    "body_type": "Mesomorph",
    "goals": ["Weight Loss", "Strength"],
    "experience_level": "Intermediate",
    "limitations": "None"
}
```

### 2. Use Consistent User IDs

For memory persistence across sessions:
```python
user_id = "user_123"  # Use same ID across all calls
```

### 3. Retrieve Memory When Needed

Check user history for context:
```python
GET /api/v1/simpleclaw/memory/user_123
```

### 4. Choose Appropriate Workflows

- Use `fitness_plan` for structured workout programs
- Use `nutrition_plan` for meal planning
- Use `chat_assistant` for Q&A and general advice
- Use `goal_tracking` for progress analysis
- Use `motivation` for encouragement

## Performance Considerations

- **Response Time**: 2-5 seconds per workflow (Gemini API dependent)
- **Memory**: In-memory storage (last 10 interactions per user)
- **Concurrency**: Async operations for multiple users
- **Scalability**: Add external cache (Redis) for production

## Future Enhancements

1. **Advanced Memory**: Integrate vector database for semantic search
2. **Multi-Model Support**: Support Claude, GPT-4, etc.
3. **Workflow Chaining**: Connect multiple workflows automatically
4. **Real-time Feedback**: WebSocket support for streaming responses
5. **Analytics**: Track workflow success metrics

## Troubleshooting

### Issue: "AI client not initialized"

**Solution**: Ensure `GEMINI_API_KEY` is set in `.env`:
```bash
GEMINI_API_KEY=your_api_key_here
```

### Issue: Workflow execution fails

**Solution**: Check workflow_type is valid:
- `fitness_plan`
- `nutrition_plan`
- `chat_assistant`
- `goal_tracking`
- `motivation`

### Issue: No context in responses

**Solution**: Ensure you're using consistent `user_id` across calls.

## Conclusion

SimpleClaw integration provides a **production-ready, simplified AI workflow orchestration** for Fitola without the complexity of OpenClaw. It combines:

- ✅ Zero-configuration deployment
- ✅ Advanced prompt engineering
- ✅ Persistent memory
- ✅ Five specialized workflows
- ✅ Easy API integration

Perfect for fitness applications that need powerful AI capabilities with minimal setup overhead.
