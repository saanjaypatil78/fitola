import 'package:flutter/material.dart';

/// A stateless card widget for displaying statistics with icon, title, value, and subtitle.
/// Used across dashboard, ranking, and profile screens.
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final Color? iconColor;
  final VoidCallback? onTap;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: iconColor ?? colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
