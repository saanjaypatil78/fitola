import 'package:flutter/material.dart';

/// A widget that creates a parallax scrolling effect
/// 
/// The parallax effect creates depth by moving the background
/// at a different speed than the foreground content as the user scrolls.
class ParallaxWidget extends StatelessWidget {
  /// The background widget that will have the parallax effect
  final Widget background;
  
  /// The foreground content displayed over the background
  final Widget? foreground;
  
  /// The scroll controller to track scroll position
  final ScrollController? scrollController;
  
  /// The height of the parallax container
  final double height;
  
  /// Speed factor for the parallax effect (0.0 to 1.0)
  /// Higher values = more pronounced effect
  final double parallaxSpeed;
  
  /// Whether to add a gradient overlay for better text readability
  final bool addGradientOverlay;
  
  /// Gradient overlay colors
  final List<Color>? gradientColors;

  const ParallaxWidget({
    super.key,
    required this.background,
    this.foreground,
    this.scrollController,
    this.height = 300,
    this.parallaxSpeed = 0.5,
    this.addGradientOverlay = true,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: scrollController ?? ScrollController(),
            builder: (context, child) {
              double offset = 0;
              if (scrollController != null && scrollController!.hasClients) {
                offset = scrollController!.offset * parallaxSpeed;
              }
              
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Stack(
                  children: [
                    // Parallax background
                    Positioned(
                      top: -offset,
                      left: 0,
                      right: 0,
                      height: height + 100, // Extra height for parallax movement
                      child: background,
                    ),
                    
                    // Gradient overlay for text readability
                    if (addGradientOverlay)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: gradientColors ?? [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    
                    // Foreground content
                    if (foreground != null)
                      Positioned.fill(
                        child: foreground!,
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// A widget that creates a parallax effect for list items
/// Each item in the list has its own parallax effect based on its position
class ParallaxListItem extends StatelessWidget {
  /// The background image URL or asset path
  final String imageUrl;
  
  /// The title text displayed on the card
  final String title;
  
  /// Optional subtitle text
  final String? subtitle;
  
  /// Global key for the list item to calculate position
  final GlobalKey itemKey;
  
  /// Parallax effect intensity (0.0 to 1.0)
  final double parallaxIntensity;
  
  /// Height of the list item
  final double height;
  
  /// Callback when the item is tapped
  final VoidCallback? onTap;

  const ParallaxListItem({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    required this.itemKey,
    this.parallaxIntensity = 0.3,
    this.height = 200,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              // Parallax background image
              _buildParallaxBackground(context),
              
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              
              // Content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Tap handler
              if (onTap != null)
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: itemKey,
        parallaxIntensity: parallaxIntensity,
      ),
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 64, color: Colors.grey),
            );
          },
        ),
      ],
    );
  }
}

/// Flow delegate that handles the parallax positioning calculation
class ParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;
  final double parallaxIntensity;

  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
    this.parallaxIntensity = 0.3,
  }) : super(repaint: scrollable.position);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
      height: constraints.maxHeight + 100, // Extra height for parallax
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
      Offset.zero,
      ancestor: scrollableBox,
    );

    // Calculate parallax offset based on scroll position
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction = (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);
    final parallaxOffset = (scrollFraction - 0.5) * 200 * parallaxIntensity;

    // Paint the background image with parallax offset
    final childSize = context.getChildSize(0)!;
    context.paintChild(
      0,
      transform: Matrix4.translationValues(0, parallaxOffset, 0),
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey ||
        parallaxIntensity != oldDelegate.parallaxIntensity;
  }
}

/// A simple parallax container that creates depth effect on scroll
class SimpleParallaxContainer extends StatelessWidget {
  final Widget child;
  final double offset;
  final double baseOffset;

  const SimpleParallaxContainer({
    super.key,
    required this.child,
    this.offset = 0,
    this.baseOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, baseOffset + offset * 0.5),
      child: child,
    );
  }
}
