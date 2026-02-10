# Parallax Effects Usage Guide

## Quick Start Guide

This guide will help you add parallax effects to any screen in the Fitola app.

## Step-by-Step Tutorial

### Method 1: Simple Header Parallax (Recommended for Most Screens)

This is the easiest way to add a parallax effect to a screen's header section.

#### Step 1: Import the Widget

```dart
import 'package:fitola/widgets/parallax_widget.dart';
```

#### Step 2: Add a ScrollController

```dart
class _YourScreenState extends State<YourScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  // ... rest of your state
}
```

#### Step 3: Use ParallaxWidget in Your Build Method

Replace your existing header Container with ParallaxWidget:

**Before:**
```dart
Container(
  padding: const EdgeInsets.all(24),
  decoration: BoxDecoration(
    color: FitolaTheme.primaryColor,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    ),
  ),
  child: YourHeaderContent(),
)
```

**After:**
```dart
ParallaxWidget(
  scrollController: _scrollController,
  height: 200,  // Adjust based on your content
  parallaxSpeed: 0.4,  // 0.0 = no parallax, 1.0 = maximum effect
  background: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          FitolaTheme.primaryColor,
          FitolaTheme.primaryColor.withOpacity(0.8),
        ],
      ),
    ),
  ),
  foreground: Padding(
    padding: const EdgeInsets.all(24),
    child: YourHeaderContent(),
  ),
)
```

#### Step 4: Connect ScrollController to ScrollView

```dart
SingleChildScrollView(
  controller: _scrollController,
  child: Column(
    children: [
      // Your ParallaxWidget here
      ParallaxWidget(...),
      // Rest of your content
    ],
  ),
)
```

### Method 2: List Item Parallax

Use this for creating parallax effects in scrollable lists where each item has its own parallax background.

#### Example Implementation:

```dart
class MyListScreen extends StatelessWidget {
  final List<WorkoutPlan> plans = [...];
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        final itemKey = GlobalKey();
        
        return ParallaxListItem(
          itemKey: itemKey,
          imageUrl: plan.imageUrl,
          title: plan.title,
          subtitle: plan.description,
          height: 200,
          parallaxIntensity: 0.3,
          onTap: () => Navigator.push(...),
        );
      },
    );
  }
}
```

### Method 3: Custom Parallax Animation

For more control, create custom parallax effects using AnimatedBuilder.

```dart
class _YourScreenState extends State<YourScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              double offset = 0;
              if (_scrollController.hasClients) {
                offset = _scrollController.offset * 0.5;
              }
              
              return Transform.translate(
                offset: Offset(0, -offset),
                child: YourWidget(),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

## Configuration Options

### ParallaxWidget Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `background` | Widget | Required | The background layer that moves with parallax |
| `foreground` | Widget? | null | Content displayed over the background |
| `scrollController` | ScrollController? | null | Controller to track scroll position |
| `height` | double | 300 | Height of the parallax container |
| `parallaxSpeed` | double | 0.5 | Speed factor (0.0-1.0) |
| `addGradientOverlay` | bool | true | Add gradient for text readability |
| `gradientColors` | List<Color>? | null | Custom gradient colors |

### Recommended parallaxSpeed Values

- **0.2-0.3**: Subtle effect, professional look
- **0.4-0.5**: Moderate effect (recommended for most screens)
- **0.6-0.8**: Pronounced effect, dynamic feel
- **0.9-1.0**: Maximum effect, use sparingly

## Design Patterns

### Pattern 1: Gradient Background

```dart
ParallaxWidget(
  background: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          FitolaTheme.primaryColor,
          FitolaTheme.primaryColor.withOpacity(0.7),
        ],
      ),
    ),
  ),
)
```

### Pattern 2: With Decorative Circles

```dart
ParallaxWidget(
  background: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [FitolaTheme.primaryColor, Colors.deepPurple],
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        // Add more circles as needed
      ],
    ),
  ),
)
```

### Pattern 3: With Custom Pattern

```dart
ParallaxWidget(
  background: Container(
    color: FitolaTheme.primaryColor,
    child: CustomPaint(
      painter: MyCustomPatternPainter(),
    ),
  ),
)
```

## Common Use Cases

### Use Case 1: Profile Header

Perfect for user profile screens where you want to showcase the user's information with depth.

```dart
ParallaxWidget(
  scrollController: _scrollController,
  height: 280,
  parallaxSpeed: 0.35,
  background: GradientBackground(),
  foreground: ProfileHeaderContent(user: user),
)
```

### Use Case 2: Feature Introduction

Great for introducing new features or sections of your app.

```dart
ParallaxWidget(
  height: 200,
  parallaxSpeed: 0.4,
  background: FeatureBackground(),
  foreground: FeatureTitle(),
)
```

### Use Case 3: Content Cards

Ideal for creating engaging content cards in a list.

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return ParallaxListItem(
      itemKey: GlobalKey(),
      imageUrl: items[index].image,
      title: items[index].title,
      onTap: () => handleTap(index),
    );
  },
)
```

## Best Practices

### DO ✅

1. **Use appropriate parallax speed**: Start with 0.4 and adjust
2. **Add gradient overlays**: Ensure text readability
3. **Dispose controllers**: Always dispose ScrollController in dispose()
4. **Test on devices**: Parallax effects are best experienced on real devices
5. **Keep content above parallax**: Use the `foreground` parameter
6. **Use consistent heights**: Maintain similar heights across similar screens

### DON'T ❌

1. **Don't overuse**: Not every screen needs parallax
2. **Don't make it too fast**: Values above 0.8 can be jarring
3. **Don't forget performance**: Test on low-end devices
4. **Don't ignore accessibility**: Ensure text remains readable
5. **Don't create too many layers**: Keep it simple
6. **Don't use very tall parallax containers**: Keep height reasonable (150-300px)

## Troubleshooting

### Issue: Parallax not working

**Solution**: Ensure the ScrollController is:
1. Initialized in your state
2. Passed to both ParallaxWidget and SingleChildScrollView
3. Disposed in the dispose() method

### Issue: Jerky scrolling

**Solution**: 
1. Reduce parallaxSpeed value
2. Optimize background widget (avoid complex rendering)
3. Use const constructors where possible

### Issue: Text not readable

**Solution**:
1. Set `addGradientOverlay: true`
2. Customize `gradientColors` for better contrast
3. Add additional Text shadows

### Issue: Content overlapping

**Solution**:
1. Adjust the `height` parameter
2. Ensure foreground content fits within the height
3. Use proper padding

## Performance Tips

1. **Use const constructors** wherever possible
2. **Optimize background images**: Use appropriate resolutions
3. **Limit decoration complexity**: Simple gradients perform better than complex patterns
4. **Test on older devices**: Ensure smooth 60fps performance
5. **Use cached images**: For network images in ParallaxListItem

## Examples from Fitola App

Check these screens for reference implementations:

1. **Dashboard Screen**: Simple header with pattern
2. **AI Trainer Screen**: Header with decorative circles
3. **Profile Screen**: User-focused parallax header
4. **Splash Screen**: Animated entrance with parallax-like effects

## Need Help?

- Review the comprehensive documentation in `PARALLAX_EFFECTS_IMPLEMENTATION.md`
- Check the widget source code in `mobile/lib/widgets/parallax_widget.dart`
- Look at existing implementations in the screens listed above
- Experiment with different values to find what works best for your screen

## Next Steps

After adding parallax effects:
1. Test scrolling performance
2. Verify text readability
3. Test on different screen sizes
4. Get user feedback
5. Iterate and refine

---

Happy coding! 🎨✨
