import 'package:flutter/material.dart';

/// An information or alert card with colored background.
/// Used to display messages, warnings, errors, or informational content.
/// 
/// Types:
/// - info: Blue background for informational messages
/// - warning: Orange background for warnings
/// - error: Red background for errors
/// - success: Green background for success messages
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
    switch (type) {
      case InfoCardType.info:
        return _InfoCardColors(
          backgroundColor: const Color(0xFF2196F3).withOpacity(0.1),
          borderColor: const Color(0xFF2196F3).withOpacity(0.3),
          iconColor: const Color(0xFF2196F3),
          textColor: theme.brightness == Brightness.light 
              ? const Color(0xFF1565C0) 
              : const Color(0xFF90CAF9),
        );
      case InfoCardType.warning:
        return _InfoCardColors(
          backgroundColor: const Color(0xFFFF9800).withOpacity(0.1),
          borderColor: const Color(0xFFFF9800).withOpacity(0.3),
          iconColor: const Color(0xFFFF9800),
          textColor: theme.brightness == Brightness.light 
              ? const Color(0xFFE65100) 
              : const Color(0xFFFFB74D),
        );
      case InfoCardType.error:
        return _InfoCardColors(
          backgroundColor: const Color(0xFFF44336).withOpacity(0.1),
          borderColor: const Color(0xFFF44336).withOpacity(0.3),
          iconColor: const Color(0xFFF44336),
          textColor: theme.brightness == Brightness.light 
              ? const Color(0xFFC62828) 
              : const Color(0xFFE57373),
        );
      case InfoCardType.success:
        return _InfoCardColors(
          backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
          borderColor: const Color(0xFF4CAF50).withOpacity(0.3),
          iconColor: const Color(0xFF4CAF50),
          textColor: theme.brightness == Brightness.light 
              ? const Color(0xFF2E7D32) 
              : const Color(0xFF81C784),
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
