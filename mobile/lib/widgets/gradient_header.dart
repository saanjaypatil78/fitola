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
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: child ?? _buildDefaultContent(context),
    );
  }

  Widget _buildDefaultContent(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine text alignment based on provided alignment
    final textAlign = _getTextAlign(alignment);
    final crossAxisAlign = _getCrossAxisAlignment(alignment);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlign,
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
            textAlign: textAlign,
          ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: textAlign,
          ),
        ],
      ],
    );
  }
  
  CrossAxisAlignment _getCrossAxisAlignment(AlignmentGeometry? align) {
    if (align == null) return CrossAxisAlignment.center;
    if (align == Alignment.centerLeft || align == Alignment.topLeft || align == Alignment.bottomLeft) {
      return CrossAxisAlignment.start;
    }
    if (align == Alignment.centerRight || align == Alignment.topRight || align == Alignment.bottomRight) {
      return CrossAxisAlignment.end;
    }
    return CrossAxisAlignment.center;
  }
  
  TextAlign _getTextAlign(AlignmentGeometry? align) {
    if (align == null) return TextAlign.center;
    if (align == Alignment.centerLeft || align == Alignment.topLeft || align == Alignment.bottomLeft) {
      return TextAlign.left;
    }
    if (align == Alignment.centerRight || align == Alignment.topRight || align == Alignment.bottomRight) {
      return TextAlign.right;
    }
    return TextAlign.center;
  }
}
