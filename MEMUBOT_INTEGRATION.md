# MemuBot Integration Guide for Fitola

## Overview

This document describes the **MemuBot integration** implemented in Fitola - a 24/7 proactive memory framework that enables truly adaptive, self-improving AI for fitness coaching.

## What is MemuBot?

**MemuBot (MemU)** is an advanced memory framework for AI agents that provides:

### Core Capabilities
- **24/7 Proactive Operation**: Never sleeps, never forgets
- **Persistent Memory**: Structured like a file system (folders, files, links)
- **Continuous Learning**: Learns from every interaction
- **Pattern Recognition**: Identifies behavioral patterns automatically
- **Proactive Actions**: Anticipates needs before being asked
- **Cost Efficiency**: Reduces LLM token usage via smart caching
- **Self-Evolution**: Automatically organizes and improves memory

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    Fitola Application                     │
└────────────────────────┬─────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
         ▼               ▼               ▼
┌─────────────┐  ┌──────────────┐  ┌──────────────┐
│  MemuBot    │  │  Adaptive    │  │  SimpleClaw  │
│  Manager    │  │  Workflows   │  │ Orchestrator │
└──────┬──────┘  └──────┬───────┘  └──────┬───────┘
       │                │                  │
       └────────────────┼──────────────────┘
                        │
              ┌─────────┴──────────┐
              │                    │
              ▼                    ▼
      ┌───────────────┐    ┌─────────────┐
      │ Self-Improving│    │   Memory    │
      │  Orchestrator │    │  Categories │
      └───────────────┘    └─────────────┘
              │
              ▼
      ┌───────────────┐
      │  MemU API or  │
      │  Mock Storage │
      └───────────────┘
              │
              ▼
      ┌───────────────┐
      │  Gemini 2.5   │
      │  Flash AI     │
      └───────────────┘
```

## Components

### 1. MemuBot Manager (`memubot_integration.py`)

Core integration layer that handles:

**Memory Categories (9 types)**:
1. `user_profile` - Basic user information
2. `fitness_goals` - Short and long-term goals
3. `workout_history` - Completed workouts and performance
4. `nutrition_prefs` - Dietary preferences and restrictions
5. `progress_metrics` - Weight, measurements, achievements
6. `preferences` - User likes/dislikes
7. `patterns` - Discovered behavioral patterns
8. `motivations` - What motivates this user
9. `challenges` - Obstacles and how they were overcome

**Key Methods**:
```python
# Memorize interactions
await memubot.memorize_interaction(
    user_id="user123",
    interaction_type="workout_completed",
    content={"workout": "30min cardio"},
    category=MemoryCategory.WORKOUT_HISTORY
)

# Retrieve memories
memories = await memubot.retrieve_memories(
    user_id="user123",
    query="workout patterns",
    limit=5
)

# Learn patterns
await memubot.learn_pattern(
    user_id="user123",
    pattern_type="workout_preference",
    pattern_data={"preferred_time": "morning"}
)

# Get proactive suggestions
suggestions = await memubot.get_proactive_suggestions(
    user_id="user123",
    context={"time": 7, "day": "Monday"}
)
```

### 2. Adaptive Workflows (`adaptive_workflows.py`)

Five self-improving workout types:

#### A. Learning Fitness Plan
Generates fitness plans that adapt based on:
- Past workout performance
- Exercise preferences
- Optimal workout times
- Recovery patterns

```python
result = await engine.execute_learning_fitness_plan(
    user_id="user123",
    user_data={
        "age": 30,
        "weight": 75,
        "height": 180,
        "goals": ["Muscle Gain"]
    },
    parameters={"duration_days": 30}
)
```

**Returns**:
- Adaptive fitness plan
- Insights used from memory
- Patterns identified
- Learning statistics

#### B. Predictive Workout
Predicts optimal workout for current context:
- Time of day patterns
- Recent workout history
- Energy levels
- Recovery state

```python
prediction = await engine.execute_predictive_workout(
    user_id="user123",
    context={
        "time": 8,
        "energy_level": "high",
        "days_since_workout": 1
    }
)
```

**Returns**:
- Workout prediction
- Confidence score
- Reasoning
- Context factors considered

#### C. Proactive Motivation
Detects when motivation is needed:
- Inactivity patterns
- Goal deadline approaching
- Plateau detection
- Historical effectiveness

```python
motivation = await engine.execute_proactive_motivation(
    user_id="user123",
    user_state={
        "days_since_workout": 4,
        "goal_deadline_approaching": True
    }
)
```

**Returns**:
- Should send motivation (boolean)
- Personalized message
- Trigger type detected
- Confidence score

#### D. Adaptive Nutrition
Nutrition plans that evolve based on:
- Compliance patterns
- Preferred meals
- Difficult times
- Historical success rates

```python
nutrition = await engine.execute_adaptive_nutrition(
    user_id="user123",
    user_data={
        "age": 30,
        "weight": 75,
        "city": "New York",
        "allergies": ["peanuts"]
    },
    parameters={"duration_days": 7}
)
```

**Returns**:
- Compliance-optimized plan
- Compliance insights
- Adaptive features applied

#### E. Smart Goal Tracking
Intelligent progress tracking:
- Adjusts targets based on progress
- Recognizes plateaus
- Celebrates micro-wins
- Predicts achievement timeline

```python
goal_result = await engine.execute_smart_goal_tracking(
    user_id="user123",
    goal="Lose 5kg",
    progress={
        "current_loss": "2kg",
        "completion_percentage": 40
    }
)
```

**Returns**:
- Progress analysis
- Adaptive recommendations
- Predicted timeline
- Pattern detection

### 3. Self-Improving Orchestrator (`self_improving_orchestrator.py`)

Combines all components for truly intelligent AI:

**Key Features**:
- Executes workflows with learning
- Provides proactive insights
- Accepts feedback for improvement
- Tracks learning statistics

```python
# Execute with learning
result = await orchestrator.execute_with_learning(
    user_id="user123",
    workflow_type="learning_fitness_plan",
    user_data={...},
    parameters={...}
)

# Get proactive insights
insights = await orchestrator.get_proactive_insights(
    user_id="user123",
    current_context={"time": 7, "energy_level": "high"}
)

# Provide feedback
feedback_result = await orchestrator.provide_feedback(
    user_id="user123",
    workflow_id="workout_001",
    feedback={"helpful": True, "what_worked": "timing"}
)

# Get learning stats
stats = await orchestrator.get_learning_stats("user123")
```

## API Endpoints

### 1. Execute Adaptive Workflow

**POST** `/api/v1/memubot/workflow`

Execute any self-improving workflow.

```json
{
  "user_id": "user123",
  "workflow_type": "learning_fitness_plan",
  "user_data": {
    "age": 30,
    "weight": 75,
    "height": 180,
    "goals": ["Muscle Gain"]
  },
  "parameters": {
    "duration_days": 30
  }
}
```

**Response**:
```json
{
  "workflow": "learning_fitness_plan",
  "plan": {...},
  "insights_used": {...},
  "adaptive_features": [...],
  "self_improving": true,
  "learning_metadata": {
    "context_memories_used": 15,
    "improvement_cycle": 42,
    "execution_time_seconds": 2.3,
    "patterns_learned": 8
  }
}
```

### 2. Get Proactive Insights

**GET** `/api/v1/memubot/proactive-insights/{user_id}`

Get AI-generated proactive suggestions.

**Parameters**:
- `user_id`: User identifier
- `context` (optional): Current context note

**Response**:
```json
{
  "timestamp": "2026-02-07T18:00:00Z",
  "proactive_suggestions": [
    {
      "type": "workout",
      "title": "Morning Workout",
      "reason": "Based on your usual morning routine",
      "confidence": 0.8
    }
  ],
  "motivation_needed": true,
  "motivation_message": "It's been a few days...",
  "workout_prediction": {...},
  "self_improved": true,
  "confidence_score": 0.85
}
```

### 3. Submit Feedback

**POST** `/api/v1/memubot/feedback`

Provide feedback for continuous improvement.

```json
{
  "user_id": "user123",
  "workflow_id": "workout_001",
  "helpful": true,
  "what_worked": "Personalized timing suggestions",
  "what_to_avoid": null
}
```

**Response**:
```json
{
  "feedback_processed": true,
  "learning_updated": true,
  "message": "Thank you! I'll use this to improve future recommendations."
}
```

### 4. Get Learning Stats

**GET** `/api/v1/memubot/learning-stats/{user_id}`

View what the AI has learned about the user.

**Response**:
```json
{
  "user_id": "user123",
  "total_interactions": 150,
  "patterns_learned": 23,
  "improvement_cycles": 42,
  "memory_enabled": true,
  "learning_categories": [
    "Workout Preferences",
    "Nutrition Compliance",
    "Motivation Triggers",
    "Performance Patterns",
    "Goal Progress"
  ],
  "ai_capabilities": [
    "Learns from every interaction",
    "Adapts plans to your patterns",
    "Predicts optimal workout times",
    "Provides proactive motivation",
    "Improves recommendations over time"
  ],
  "recent_learnings": [...]
}
```

### 5. Memorize Interaction

**POST** `/api/v1/memubot/memorize`

Manually store an interaction.

```json
{
  "user_id": "user123",
  "interaction_type": "workout_completed",
  "content": {
    "workout": "30min cardio",
    "calories": 250,
    "satisfaction": 5
  }
}
```

### 6. Retrieve Memories

**GET** `/api/v1/memubot/memories/{user_id}`

Search through user's memory.

**Parameters**:
- `query`: Search query
- `limit`: Maximum results (1-20)

**Response**:
```json
{
  "user_id": "user123",
  "query": "workout patterns",
  "memories": [
    {
      "content": {...},
      "memory_type": "pattern",
      "timestamp": "2026-02-07T10:00:00Z",
      "relevance": 0.92
    }
  ],
  "count": 5
}
```

## Usage Examples

### Example 1: Adaptive Fitness Plan

```python
import requests

response = requests.post(
    "http://localhost:8000/api/v1/memubot/workflow",
    json={
        "user_id": "john_doe",
        "workflow_type": "learning_fitness_plan",
        "user_data": {
            "age": 28,
            "weight": 80,
            "height": 175,
            "body_type": "Ectomorph",
            "goals": ["Muscle Gain"]
        },
        "parameters": {
            "duration_days": 30,
            "experience_level": "Beginner"
        }
    }
)

plan = response.json()
print(f"Generated plan with {plan['learning_metadata']['context_memories_used']} memories")
print(f"Adaptive features: {len(plan['adaptive_features'])}")
```

### Example 2: Proactive Insights

```python
# Get proactive insights in the morning
response = requests.get(
    "http://localhost:8000/api/v1/memubot/proactive-insights/jane_smith",
    params={"context": "morning_routine"}
)

insights = response.json()

if insights['motivation_needed']:
    print(f"Motivation: {insights['motivation_message']}")

if insights['workout_prediction']:
    prediction = insights['workout_prediction']
    print(f"Suggested workout: {prediction['workout_type']}")
    print(f"Confidence: {prediction['confidence']}")
```

### Example 3: Continuous Learning Loop

```python
user_id = "mike_jones"

# 1. User completes workout
requests.post(
    "http://localhost:8000/api/v1/memubot/memorize",
    json={
        "user_id": user_id,
        "interaction_type": "workout_completed",
        "content": {
            "type": "strength_training",
            "duration": 45,
            "satisfaction": 5,
            "notes": "Felt great, perfect timing"
        }
    }
)

# 2. Get next workout prediction (now informed by completion)
prediction = requests.post(
    "http://localhost:8000/api/v1/memubot/workflow",
    json={
        "user_id": user_id,
        "workflow_type": "predictive_workout",
        "user_data": {},
        "parameters": {"context": "next_day"}
    }
).json()

# 3. Provide feedback on prediction
requests.post(
    "http://localhost:8000/api/v1/memubot/feedback",
    json={
        "user_id": user_id,
        "workflow_id": prediction.get("session_id"),
        "helpful": True,
        "what_worked": "Predicted perfect recovery time"
    }
)

# 4. AI has now learned and improved!
stats = requests.get(
    f"http://localhost:8000/api/v1/memubot/learning-stats/{user_id}"
).json()

print(f"AI has learned from {stats['total_interactions']} interactions")
print(f"Patterns identified: {stats['patterns_learned']}")
```

## Configuration

### Environment Variables

```bash
# MemU API Configuration (optional, uses mock mode if not provided)
export MEMU_API_KEY="your_memu_api_key_here"
export MEMU_API_BASE_URL="https://api.memu.so"  # Default

# For self-hosted MemU server
export MEMU_API_BASE_URL="http://your-server:8000"
```

### Mock Mode vs Production

**Mock Mode** (default):
- No API key required
- Stores memory in-memory (lost on restart)
- Perfect for development and testing
- All features work identically

**Production Mode** (with API key):
- Persistent memory across restarts
- Scalable to millions of users
- Advanced memory clustering
- Optimized retrieval performance

## Benefits Over Traditional AI

| Feature | Traditional AI | MemuBot-Enhanced AI |
|---------|---------------|-------------------|
| **Memory** | Stateless | Persistent across sessions |
| **Learning** | Static | Continuous from every interaction |
| **Personalization** | Generic | Deep, evolving personalization |
| **Proactivity** | Reactive only | Anticipates needs |
| **Improvement** | Manual updates | Self-improving automatically |
| **Context** | Limited | Full history available |
| **Patterns** | None | Automatic pattern detection |
| **Cost** | High token usage | Optimized via caching |

## Performance

- **Response Time**: 2-5 seconds per workflow (Gemini dependent)
- **Memory Retrieval**: < 100ms (mock mode), < 500ms (production)
- **Learning Speed**: Instant pattern recognition
- **Scalability**: Supports millions of users (production mode)
- **Storage**: Minimal (structured, deduplicated memory)

## Best Practices

### 1. Frequent Memorization
Memorize significant interactions:
```python
# After workouts
await memubot.memorize_interaction(..., category=MemoryCategory.WORKOUT_HISTORY)

# After meals
await memubot.memorize_interaction(..., category=MemoryCategory.NUTRITION_PREFS)

# After achievements
await memubot.memorize_interaction(..., category=MemoryCategory.PROGRESS_METRICS)
```

### 2. Use Appropriate Categories
Organize memory for better retrieval:
- User profile changes → `USER_PROFILE`
- Workout completions → `WORKOUT_HISTORY`
- Goal updates → `FITNESS_GOALS`
- Discovered patterns → `PATTERNS`

### 3. Leverage Proactive Insights
Check regularly for suggestions:
```python
# Morning check
insights = await orchestrator.get_proactive_insights(user_id, {
    "time": 7,
    "context": "morning_check"
})

# Pre-workout check
insights = await orchestrator.get_proactive_insights(user_id, {
    "context": "pre_workout"
})
```

### 4. Close Feedback Loops
Always collect and submit feedback:
```python
# After user rates recommendation
await orchestrator.provide_feedback(
    user_id=user_id,
    workflow_id=workflow_id,
    feedback={
        "helpful": rating >= 4,
        "what_worked": user_comment if helpful else None,
        "what_to_avoid": user_comment if not helpful else None
    }
)
```

### 5. Monitor Learning Stats
Regularly check AI learning progress:
```python
stats = await orchestrator.get_learning_stats(user_id)
# Log to analytics
# Show to user for transparency
```

## Testing

Comprehensive test suite included (`backend/test_memubot.py`):

```bash
cd backend
python test_memubot.py
```

Tests cover:
- ✅ MemuBot Manager (7 tests)
- ✅ Adaptive Workflows (5 tests)
- ✅ Self-Improving Orchestrator (4 tests)
- ✅ Memory Categories (9 tests)
- ✅ Continuous Learning (4 tests)

**Total: 29 tests, all passing**

## Troubleshooting

### Issue: "memu-py not installed"
**Solution**: This is expected in mock mode. For production, install:
```bash
pip install memu-py
```

### Issue: Memory not persisting
**Solution**: Either:
1. Use production mode with API key, or
2. Implement custom persistence layer for mock mode

### Issue: Low confidence scores
**Solution**: AI needs more interaction data. Collect more user interactions over time.

### Issue: Patterns not being detected
**Solution**: Ensure sufficient diversity in interactions (at least 10+ per category).

## Security Considerations

✅ **No secrets in logs**: API keys never logged
✅ **User data isolation**: Each user's memory is separate  
✅ **Input validation**: All inputs validated via Pydantic
✅ **Safe prompt injection**: User data sanitized before AI
✅ **Graceful degradation**: Falls back to mock mode if API fails

## Future Enhancements

Potential improvements:
1. **Vector Search**: Semantic similarity for better retrieval
2. **Multi-Model Support**: Claude, GPT-4, etc.
3. **Real-time Streaming**: WebSocket updates
4. **Workflow Chaining**: Auto-chain related workflows
5. **A/B Testing**: Test different adaptation strategies
6. **Analytics Dashboard**: Visualize learning metrics

## Conclusion

The MemuBot integration transforms Fitola from a reactive AI assistant into a **truly intelligent, proactive, self-improving fitness coach** that:

✅ **Never forgets** user preferences and history  
✅ **Learns continuously** from every interaction  
✅ **Adapts automatically** to user patterns  
✅ **Anticipates needs** before being asked  
✅ **Improves itself** without manual intervention  
✅ **Provides transparency** into what it has learned  

This represents the future of AI-powered fitness coaching - an AI that truly understands and grows with each user.
