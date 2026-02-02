import 'package:flutter/material.dart';

/// A stateless section header widget for grouping content.
/// Used to create visual sections in lists and scrollable content.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const SectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final content = Padding(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}
