import 'package:flutter/material.dart';

/// A stateless styled list tile for navigation and actions.
/// Used in profile, settings, and menu screens.
class ActionListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool showTrailing;
  final Widget? trailing;
  final bool isDestructive;

  const ActionListTile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.showTrailing = true,
    this.trailing,
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveIconColor = isDestructive
        ? colorScheme.error
        : (iconColor ?? colorScheme.primary);
    final effectiveTitleColor = isDestructive ? colorScheme.error : null;

    return ListTile(
      leading: Icon(
        icon,
        color: effectiveIconColor,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: effectiveTitleColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodySmall,
            )
          : null,
      trailing: trailing ??
          (showTrailing && onTap != null
              ? Icon(
                  Icons.chevron_right,
                  color: theme.textTheme.bodySmall?.color,
                )
              : null),
      onTap: onTap,
    );
  }
}
