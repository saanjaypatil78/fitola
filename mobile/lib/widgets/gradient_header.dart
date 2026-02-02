import 'package:flutter/material.dart';

/// A header widget with gradient background, commonly used at the top of screens.
/// Supports custom gradient colors, icon, title, subtitle, and additional child content.
/// 
/// Used in:
/// - Profile screens
/// - Nutrition plan headers
/// - Leaderboard headers
/// - AI Trainer screens
class GradientHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final List<Color>? gradientColors;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final AlignmentGeometry? alignment;

  const GradientHeader({
    Key? key,
    this.title,
    this.subtitle,
    this.icon,
    this.gradientColors,
    this.child,
    this.padding,
    this.height,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultGradient = [
      theme.colorScheme.primary,
      theme.colorScheme.primary.withOpacity(0.8),
    ];
    
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors ?? defaultGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: child ?? _buildDefaultContent(context),
    );
  }

  Widget _buildDefaultContent(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: alignment != null 
          ? (alignment == Alignment.center ? CrossAxisAlignment.center : CrossAxisAlignment.start)
          : CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
        ],
        if (title != null)
          Text(
            title!,
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: alignment == Alignment.centerLeft 
                ? TextAlign.left 
                : TextAlign.center,
          ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: alignment == Alignment.centerLeft 
                ? TextAlign.left 
                : TextAlign.center,
          ),
        ],
      ],
    );
  }
}
