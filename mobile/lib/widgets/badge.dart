import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

/// A reusable badge widget for displaying counts, status, etc.
class Badge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? padding;

  const Badge({
    Key? key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? FitolaTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// A status badge for user availability
class StatusBadge extends StatelessWidget {
  final String status;
  final double size;

  const StatusBadge({
    Key? key,
    required this.status,
    this.size = 12,
  }) : super(key: key);

  Color get statusColor {
    switch (status.toLowerCase()) {
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: statusColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

/// A chip widget for displaying tags, categories, etc.
class FitolaChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const FitolaChip({
    Key? key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor ?? FitolaTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: backgroundColor ?? FitolaTheme.primaryColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: textColor ?? FitolaTheme.primaryColor,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor ?? FitolaTheme.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 4),
              InkWell(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(12),
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: textColor ?? FitolaTheme.primaryColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
