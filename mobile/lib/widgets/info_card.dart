import 'package:flutter/material.dart';

/// An information or alert card with colored background.
/// Used to display messages, warnings, errors, or informational content.
///
/// Types (colors are derived from the current [ThemeData.colorScheme]):
/// - info: Uses the theme's primary container colors for informational messages
/// - warning: Uses the theme's tertiary container colors for warnings
/// - error: Uses the theme's error container colors for errors
/// - success: Uses the theme's secondary container colors for success messages
class InfoCard extends StatelessWidget {
  final String message;
  final InfoCardType type;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const InfoCard({
    Key? key,
    required this.message,
    this.type = InfoCardType.info,
    this.icon,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Determine colors based on type
    final colors = _getColors(theme);
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? _getDefaultIcon(),
            color: colors.iconColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _InfoCardColors _getColors(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    switch (type) {
      case InfoCardType.info:
        return _InfoCardColors(
          backgroundColor: colorScheme.primaryContainer,
          borderColor: colorScheme.primary,
          iconColor: colorScheme.primary,
          textColor: colorScheme.onPrimaryContainer,
        );
      case InfoCardType.warning:
        return _InfoCardColors(
          backgroundColor: colorScheme.tertiaryContainer,
          borderColor: colorScheme.tertiary,
          iconColor: colorScheme.tertiary,
          textColor: colorScheme.onTertiaryContainer,
        );
      case InfoCardType.error:
        return _InfoCardColors(
          backgroundColor: colorScheme.errorContainer,
          borderColor: colorScheme.error,
          iconColor: colorScheme.error,
          textColor: colorScheme.onErrorContainer,
        );
      case InfoCardType.success:
        return _InfoCardColors(
          backgroundColor: colorScheme.secondaryContainer,
          borderColor: colorScheme.secondary,
          iconColor: colorScheme.secondary,
          textColor: colorScheme.onSecondaryContainer,
        );
    }
  }

  IconData _getDefaultIcon() {
    switch (type) {
      case InfoCardType.info:
        return Icons.info_outline;
      case InfoCardType.warning:
        return Icons.warning_amber_outlined;
      case InfoCardType.error:
        return Icons.error_outline;
      case InfoCardType.success:
        return Icons.check_circle_outline;
    }
  }
}

enum InfoCardType {
  info,
  warning,
  error,
  success,
}

class _InfoCardColors {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;

  _InfoCardColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
  });
}
