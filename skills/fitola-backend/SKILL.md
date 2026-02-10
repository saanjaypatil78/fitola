---
name: fitola-backend-development
description: FastAPI backend development skill for Fitola
version: 1.0.0
author: Fitola Team
tags: [python, fastapi, backend, api]
---

# Fitola Backend Development

Expert FastAPI development for Fitola backend services.

## Patterns

### Endpoint Structure
```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()

class WorkoutRequest(BaseModel):
    name: str
    duration: int
    calories: int

@app.post("/api/v1/workouts")
async def create_workout(workout: WorkoutRequest):
    try:
        result = await WorkoutService.create(workout)
        return {"success": True, "data": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

### Database Models
Use Pydantic for request/response models.

### Authentication
Implement JWT token-based authentication.

## Best Practices
1. Use async/await for I/O operations
2. Validate inputs with Pydantic
3. Implement proper error handling
4. Add OpenAPI documentation
5. Write unit tests with pytest
