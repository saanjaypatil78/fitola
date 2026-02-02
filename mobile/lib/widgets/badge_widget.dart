import 'package:flutter/material.dart';

/// A stateless badge widget for displaying counts and notifications.
/// Used for notification badges, counters, and status indicators.
class BadgeWidget extends StatelessWidget {
  final String? label;
  final int? count;
  final Color? backgroundColor;
  final Color? textColor;
  final double? size;

  const BadgeWidget({
    Key? key,
    this.label,
    this.count,
    this.backgroundColor,
    this.textColor,
    this.size,
  })  : assert(label != null || count != null,
            'Either label or count must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveSize = size ?? 20;
    final displayText = label ?? (count != null ? count.toString() : '');

    return Container(
      constraints: BoxConstraints(
        minWidth: effectiveSize,
        minHeight: effectiveSize,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.error,
        borderRadius: BorderRadius.circular(effectiveSize / 2),
      ),
      child: Center(
        child: Text(
          displayText,
          style: theme.textTheme.labelSmall?.copyWith(
            color: textColor ?? colorScheme.onError,
            fontWeight: FontWeight.bold,
            fontSize: effectiveSize * 0.6,
          ),
        ),
      ),
    );
  }
}
