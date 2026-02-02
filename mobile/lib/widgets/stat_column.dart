import 'package:flutter/material.dart';

/// A reusable widget that displays a statistic or value with a label below it.
/// Commonly used for displaying metrics, counts, or key values.
/// 
/// Examples:
/// - Profile stats (followers, following)
/// - Workout metrics (sets, reps, duration)
/// - Nutrition info (calories, protein, carbs)
class StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;
  final Color? labelColor;
  final IconData? icon;
  final double? iconSize;

  const StatColumn({
    Key? key,
    required this.value,
    required this.label,
    this.valueColor,
    this.labelColor,
    this.icon,
    this.iconSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: iconSize ?? 20,
            color: valueColor ?? theme.colorScheme.primary,
          ),
          const SizedBox(height: 4),
        ],
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: valueColor ?? theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: labelColor ?? theme.colorScheme.onSurface.withOpacity(0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
