---
name: fitola-flutter-development
description: Flutter development skill for Fitola mobile app
version: 1.0.0
author: Fitola Team
tags: [flutter, mobile, ui, material-design]
---

# Fitola Flutter Development

Expert Flutter development following Fitola architecture and Material Design 3.

## Patterns

### Widget Structure
```dart
class CustomWidget extends StatelessWidget {
  const CustomWidget({Key? key, required this.title}) : super(key: key);
  final String title;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: EdgeInsets.all(16.0), child: Text(title)),
    );
  }
}
```

### State Management
Use Provider pattern with ChangeNotifier for state management.

### API Integration
Use ApiService with retry logic and error handling.

## Best Practices
1. Use const constructors
2. Implement lazy loading
3. Support dark/light modes
4. Add accessibility labels
5. Write widget tests
