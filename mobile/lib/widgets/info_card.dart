import 'package:flutter/material.dart';

/// A stateless card widget for displaying information with icon, label, and value.
/// Commonly used in profile and detail screens.
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;
  final VoidCallback? onTap;

  const InfoCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (iconColor ?? colorScheme.primary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  color: theme.textTheme.bodySmall?.color,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
