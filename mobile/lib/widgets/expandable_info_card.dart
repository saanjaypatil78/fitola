import 'package:flutter/material.dart';

/// An expandable card widget for displaying collapsible information.
/// Used for exercises, meals, and other content that can be expanded.
///
/// Used in:
/// - Workout plan exercise cards
/// - Nutrition plan meal cards
/// - FAQ sections
class ExpandableInfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget expandedContent;
  final bool initiallyExpanded;
  final Color? backgroundColor;

  const ExpandableInfoCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    required this.expandedContent,
    this.initiallyExpanded = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: backgroundColor,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: leading,
          trailing: trailing,
          title: Text(
            title,
            style: theme.textTheme.titleLarge,
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall,
                )
              : null,
          iconColor: theme.colorScheme.primary,
          collapsedIconColor: theme.colorScheme.primary,
          initiallyExpanded: initiallyExpanded,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: expandedContent,
            ),
          ],
        ),
      ),
    );
  }
}