import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

/// A reusable action button with icon and optional loading state
class ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;

  const ActionButton({
    Key? key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : icon != null
                ? Icon(icon)
                : const SizedBox.shrink(),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? FitolaTheme.primaryColor,
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : icon != null
              ? Icon(icon)
              : const SizedBox.shrink(),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? FitolaTheme.primaryColor,
        foregroundColor: textColor ?? Colors.white,
      ),
    );
  }
}

/// A reusable icon button with optional badge
class IconActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final int? badgeCount;
  final Color? color;

  const IconActionButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.badgeCount,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: tooltip,
      color: color,
    );

    if (badgeCount != null && badgeCount! > 0) {
      return Stack(
        children: [
          button,
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badgeCount! > 99 ? '99+' : badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    return button;
  }
}
