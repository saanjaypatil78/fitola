import 'package:flutter/material.dart';

/// A small badge widget that displays an icon with optional text.
/// Used for status indicators, counts, and labels.
/// 
/// Examples:
/// - Unread message count
/// - Rank change indicators (up/down arrows)
/// - Status labels (Active, New, etc.)
class IconBadge extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final bool isCircular;

  const IconBadge({
    Key? key,
    this.icon,
    this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.size,
    this.padding,
    this.isCircular = true,
  })  : assert(
          icon != null || (text != null && text.isNotEmpty),
          'IconBadge requires either a non-null icon or non-empty text.',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBgColor = backgroundColor ?? theme.colorScheme.primary;
    final effectiveFgColor = foregroundColor ?? Colors.white;
    final bool hasText = text != null && text!.isNotEmpty;
    final bool hasIcon = icon != null;
    final IconData? effectiveIcon = hasIcon ? icon : (hasText ? null : Icons.circle);

    // Use min constraints instead of fixed size to allow badges to grow for longer text
    final bool isTextOnly = hasText && effectiveIcon == null;
    final BoxConstraints? constraints;
    if (size != null) {
      // Respect provided size as minimum square dimension, but allow growth
      constraints = BoxConstraints(
        minWidth: size!,
        minHeight: size!,
      );
    } else if (isTextOnly) {
      // Default minimum size for text-only badges; can expand for multi-character text
      constraints = const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      );
    } else {
      constraints = null;
    }

    return Container(
      constraints: constraints,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        borderRadius: isCircular
            ? BorderRadius.circular(100)
            : BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (effectiveIcon != null)
            Icon(
              effectiveIcon,
              size: 16,
              color: effectiveFgColor,
            ),
          if (effectiveIcon != null && hasText)
            const SizedBox(width: 4),
          if (hasText)
            Text(
              text!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: effectiveFgColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}