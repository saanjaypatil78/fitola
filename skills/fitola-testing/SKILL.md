---
name: fitola-testing
description: Testing automation skill for Fitola
version: 1.0.0
author: Fitola Team
tags: [testing, automation, qa, ci-cd]
---

# Fitola Testing

Comprehensive testing automation for Fitola.

## Testing Strategy

### Unit Tests
```dart
// Flutter unit test
test('Workout service calculates calories correctly', () {
  final workout = Workout(duration: 30, intensity: 'high');
  expect(workout.calculateCalories(), equals(250));
});
```

```python
# Python unit test
def test_workout_creation():
    workout = create_workout(name="Test", duration=30)
    assert workout.id is not None
    assert workout.duration == 30
```

### Widget Tests
Test Flutter widgets in isolation with proper mocking.

### Integration Tests
Test complete user flows end-to-end.

### E2E Tests
Automated testing with Flutter Driver or Patrol.

## Best Practices
1. Test behavior, not implementation
2. Use descriptive test names
3. Mock external dependencies
4. Aim for >85% coverage
5. Run tests in CI/CD
