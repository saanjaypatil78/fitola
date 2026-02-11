# Fitola Mobile Widgets Library

This directory contains reusable UI widgets for the Fitola mobile application. All widgets follow Material 3 design principles and integrate with the FitolaTheme.

## Widget Overview

### Visual Effects & Animation

#### ParallaxWidget
Advanced parallax scrolling effects for creating depth and visual interest.

**Components**:
- `ParallaxWidget`: Main parallax container for headers and sections
- `ParallaxListItem`: Parallax effect for individual list items
- `SimpleParallaxContainer`: Lightweight parallax wrapper
- `ParallaxFlowDelegate`: Custom flow delegate for parallax calculations

**Usage**:
```dart
ParallaxWidget(
  scrollController: _scrollController,
  height: 200,
  parallaxSpeed: 0.4,
  background: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
    ),
  ),
  foreground: YourContent(),
)
```

**Features**:
- Customizable parallax speed (0.0-1.0)
- Optional gradient overlays for text readability
- Efficient 60fps performance
- Support for custom backgrounds and foregrounds

**Documentation**: See `PARALLAX_USAGE_GUIDE.md` for detailed instructions

### Navigation & Actions

#### LoadingButton
A button that displays a loading indicator during async operations.
```dart
LoadingButton(
  text: 'Submit',
  icon: Icons.send,
  isLoading: isProcessing,
  onPressed: () => handleSubmit(),
)
```

#### StatusTranslateFab
Expandable floating action button for status management and chat translation.
- Already implemented in previous phase

### Data Display

#### StatColumn
Displays a statistic with value and label, commonly used for metrics.
```dart
StatColumn(
  value: '156',
  label: 'Workouts',
  icon: Icons.fitness_center,
  valueColor: Colors.purple,
)
```

#### IconBadge
Small badge widget for counts, status indicators, or labels.
```dart
IconBadge(
  icon: Icons.arrow_upward,
  text: '+5',
  backgroundColor: Colors.green,
)
```

### Cards & Containers

#### SelectableCard
Interactive card with selection state, perfect for choice grids.
```dart
SelectableCard(
  title: 'Weight Loss',
  icon: Icons.trending_down,
  isSelected: selectedGoal == 'weight_loss',
  onTap: () => selectGoal('weight_loss'),
)
```

#### GradientHeader
Eye-catching header with gradient background.
```dart
GradientHeader(
  title: 'Nutrition Plan',
  subtitle: '2,000 cal/day',
  icon: Icons.restaurant,
  gradientColors: [Colors.purple, Colors.deepPurple],
)
```

#### InfoCard
Contextual alert card with type-based styling.
```dart
InfoCard(
  message: 'Your workout plan is ready!',
  type: InfoCardType.success,
)
```

#### ExpandableInfoCard
Collapsible card for detailed information.
```dart
ExpandableInfoCard(
  title: 'Push-ups',
  subtitle: '3 sets × 12 reps',
  leading: CircleAvatar(child: Icon(Icons.fitness_center)),
  expandedContent: Column(
    children: [
      Text('Rest: 60 seconds'),
      Text('Notes: Keep back straight'),
    ],
  ),
)
```

#### FitnessCard
Simple card for fitness activities with icon and description.
- Already implemented in previous phase

### Lists & Tiles

#### StatusTile
List tile with optional status badge and avatar.
```dart
StatusTile(
  leading: CircleAvatar(backgroundImage: NetworkImage(userImage)),
  title: 'John Doe',
  subtitle: 'Last seen 5m ago',
  statusBadge: IconBadge(text: '3', backgroundColor: Colors.red),
  trailing: Icon(Icons.chevron_right),
  onTap: () => openChat(),
)
```

### Selection & Input

#### StyledChoiceChip
Themed choice chip for filters and selections.
```dart
StyledChoiceChip(
  label: 'Beginner',
  icon: Icons.star,
  isSelected: difficulty == 'beginner',
  onSelected: (selected) => setDifficulty('beginner'),
)
```

### Empty States

#### EmptyStateWidget
Friendly empty state with optional call-to-action.
```dart
EmptyStateWidget(
  icon: Icons.chat_bubble_outline,
  title: 'No Chats Yet',
  description: 'Start a conversation with a FitBuddy!',
  buttonText: 'Find FitBuddies',
  onButtonPressed: () => navigateToMap(),
)
```

### Communication

#### ChatBubble
Message bubble for chat interfaces.
- Already implemented in previous phase

### Dialogs

#### SafetyReminderDialog
Safety confirmation dialog for location sharing.
- Already implemented in previous phase

### Map Components

#### CustomMarkers
Map markers for FitBuddy locations.
- Already implemented in previous phase

## Design Principles

### Theme Integration
All widgets respect the FitolaTheme and support both light and dark modes:
- Primary color: `#6C63FF` (Purple)
- Secondary color: `#4CAF50` (Green)
- Border radius: `12px` for most components (cards, buttons, chips); `16px` for chat bubbles; `20px` for FAB elements
- Material 3 design system

### Accessibility
- Semantic text styles from theme
- Proper contrast ratios
- Touch-friendly minimum sizes

### Customization
Each widget supports:
- Color overrides for brand variations
- Optional icons and badges
- Flexible padding and sizing
- Custom child content where appropriate

## Usage

### Import All Widgets
```dart
import 'package:fitola/widgets/widgets.dart';
```

### Import Individual Widget
```dart
import 'package:fitola/widgets/loading_button.dart';
```

## Contributing

When adding new widgets:
1. Follow Material 3 design principles
2. Support both light and dark themes
3. Use consistent 12px border radius
4. Include comprehensive documentation
5. Add example usage in comments
6. Export in `widgets.dart`

## Widget Count
- **Total Widgets**: 16
- **Visual Effects**: 1 (ParallaxWidget)
- **Navigation & Actions**: 2
- **Data Display**: 2
- **Cards & Containers**: 5
- **Lists & Tiles**: 1
- **Selection & Input**: 1
- **Empty States**: 1
- **Communication**: 1
- **Dialogs**: 1
- **Map Components**: 1
