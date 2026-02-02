import 'package:flutter/material.dart';

/// A stateless widget for displaying activity timeline items.
/// Used in dashboard, activity feeds, and history screens.
class ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? time;
  final Color? iconColor;
  final VoidCallback? onTap;

  const ActivityItem({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.time,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? colorScheme.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor ?? colorScheme.primary,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall,
                )
              : null,
          trailing: time != null
              ? Text(
                  time!,
                  style: theme.textTheme.bodySmall,
                )
              : null,
        ),
      ),
    );
  }
}
