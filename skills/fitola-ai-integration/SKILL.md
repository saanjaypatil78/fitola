---
name: fitola-ai-integration
description: Gemini AI integration skill for Fitola
version: 1.0.0
author: Fitola Team
tags: [ai, gemini, ml, nlp]
---

# Fitola AI Integration

Expert Gemini AI integration for Fitola intelligent features.

## Patterns

### Gemini API Usage
```python
from google import genai

client = genai.Client(api_key=GEMINI_API_KEY)
response = client.models.generate_content(
    model='gemini-2.5-flash',
    contents=prompt,
    config={'temperature': 0.7}
)
```

### Prompt Engineering
- Be specific and clear
- Provide context and examples
- Use structured output formats
- Implement retry logic

### Error Handling
- Handle rate limits
- Implement exponential backoff
- Validate AI responses
- Fallback to default behavior

## Use Cases
1. Workout plan generation
2. Nutrition advice
3. Chat translation
4. Body analysis
5. Goal recommendations
