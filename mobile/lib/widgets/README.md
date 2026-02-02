# Fitola Widgets Library

This directory contains all reusable UI widgets for the Fitola mobile application.

## Widget Categories

### Action Widgets
- **ActionButton**: Reusable button with icon, loading state, and variants (elevated/outlined)
- **IconActionButton**: Icon button with optional badge for notifications
- **QuickActionCard**: Card-based quick action button with icon and label

### Card Widgets
- **StatCard**: Statistics card with icon, value, title, and optional subtitle
- **StatCardCentered**: Centered variant of stat card
- **FitnessCard**: Card for fitness-related content

### Badge Widgets
- **Badge**: Generic badge for displaying counts, status labels
- **StatusBadge**: Circular status indicator for user availability
- **FitolaChip**: Material chip with icon, delete action, and custom styling

### Chat Widgets
- **ChatBubble**: Enhanced chat message bubble with:
  - Timestamp display
  - Translation indicator
  - Read receipts (double checkmark)
  - Proper alignment for sent/received messages

### Dialog Widgets
- **InfoDialog**: Information dialog with icon and message
- **ConfirmDialog**: Confirmation dialog with cancel/confirm actions
- **InputDialog**: Input dialog for text entry with validation
- **SafetyReminderDialog**: Location sharing safety reminder

### Empty States
- **EmptyState**: Generic empty state with icon, title, message, and optional action

### List Widgets
- **UserListTile**: User list item with avatar, name, status indicator
- **SectionHeader**: Section header with title and optional action button
- **TextDivider**: Divider with centered text label

### Loading States
- **LoadingCard**: Skeleton loading card with shimmer effect
- **LoadingListItem**: Skeleton loading list item
- **LoadingStatCard**: Skeleton loading for stat cards

### Map Widgets
- **CustomMarkers**: Various map marker types:
  - `buildMarker`: Basic user marker with gender color
  - `buildStatusMarker`: Marker with status-based color and icon
  - `buildInitialsMarker`: Marker with user initials
  - `buildCurrentUserMarker`: Current user location marker
  - `buildWorkoutMarker`: Workout location marker

### Progress Widgets
- **ProgressIndicatorWidget**: Linear progress bar with label and percentage
- **CircularProgressWidget**: Circular progress indicator with percentage text

### FAB Widgets
- **StatusTranslateFab**: Multi-action FAB for status and translation controls

## Usage

### Import All Widgets
```dart
import 'package:fitola/widgets/widgets.dart';
```

### Import Individual Widgets
```dart
import 'package:fitola/widgets/stat_card.dart';
import 'package:fitola/widgets/action_button.dart';
```

## Examples

### StatCard
```dart
StatCard(
  title: 'Workouts',
  value: '24',
  icon: Icons.fitness_center,
  color: Colors.blue,
  subtitle: '+3 this week',
  onTap: () => print('Tapped'),
)
```

### ActionButton
```dart
ActionButton(
  label: 'Save',
  icon: Icons.save,
  onPressed: () => print('Save'),
  isLoading: false,
)
```

### ChatBubble
```dart
ChatBubble(
  message: 'Hello, how are you?',
  isSent: true,
  timestamp: DateTime.now(),
  isTranslated: false,
  isRead: true,
)
```

### InfoDialog
```dart
// Using static method
await InfoDialog.show(
  context,
  title: 'Success',
  message: 'Your profile has been updated!',
  icon: Icons.check_circle,
  iconColor: Colors.green,
);
```

### EmptyState
```dart
EmptyState(
  icon: Icons.inbox,
  title: 'No Messages',
  message: 'You don\'t have any messages yet. Start a conversation!',
  actionLabel: 'Find FitBuddies',
  onAction: () => Navigator.pushNamed(context, '/map'),
)
```

### CustomMarkers
```dart
// Status-based marker
CustomMarkers.buildStatusMarker(
  name: 'John Doe',
  gender: 'male',
  status: UserStatus.available,
  size: 40,
)

// Initials marker
CustomMarkers.buildInitialsMarker(
  name: 'Jane Smith',
  gender: 'female',
  status: UserStatus.busy,
)
```

## Design Principles

1. **Consistency**: All widgets follow the Fitola theme and design patterns
2. **Reusability**: Widgets are generic and configurable via parameters
3. **Accessibility**: Proper semantics and labels where applicable
4. **Performance**: Optimized for smooth rendering and minimal rebuilds
5. **Type Safety**: Strong typing with optional parameters for flexibility

## Widget Guidelines

- Always use the theme colors from `FitolaTheme`
- Follow Material Design 3 principles
- Include proper documentation for each widget
- Add optional parameters for customization
- Use `const` constructors where possible
- Provide sensible default values

## Contributing

When adding new widgets:

1. Place them in the appropriate category file or create a new one
2. Export them in `widgets.dart`
3. Document usage with examples
4. Ensure they align with existing design patterns
5. Test with different screen sizes and themes
