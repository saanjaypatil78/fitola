import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

/// A reusable list tile widget for user profiles
class UserListTile extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final String? status;
  final Widget? trailing;
  final VoidCallback? onTap;

  const UserListTile({
    Key? key,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.status,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  Color get statusColor {
    if (status == null) return Colors.grey;
    switch (status!.toLowerCase()) {
      case 'available':
        return FitolaTheme.availableColor;
      case 'busy':
        return FitolaTheme.busyColor;
      case 'ghost':
        return FitolaTheme.ghostColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: FitolaTheme.primaryColor,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          if (status != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        name,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
    );
  }
}

/// A reusable section header widget for lists
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final EdgeInsets? padding;

  const SectionHeader({
    Key? key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (actionLabel != null && onActionTap != null)
            TextButton(
              onPressed: onActionTap,
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}

/// A reusable divider with text
class TextDivider extends StatelessWidget {
  final String text;
  final EdgeInsets? padding;

  const TextDivider({
    Key? key,
    required this.text,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: FitolaTheme.textSecondary,
                  ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}
