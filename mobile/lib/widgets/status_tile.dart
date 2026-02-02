import 'package:flutter/material.dart';

/// A list tile widget with optional status badge and avatar.
/// Provides consistent styling for list items across the app.
/// 
/// Used in:
/// - Chat list with online status
/// - Profile action items
/// - Leaderboard entries
class StatusTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? statusBadge;
  final VoidCallback? onTap;
  final bool isDestructive;
  final EdgeInsetsGeometry? contentPadding;

  const StatusTile({
    Key? key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.statusBadge,
    this.onTap,
    this.isDestructive = false,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: contentPadding ?? const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  leading,
                  if (statusBadge != null)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: statusBadge!,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDestructive 
                            ? theme.colorScheme.error 
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
