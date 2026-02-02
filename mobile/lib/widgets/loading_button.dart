import 'package:flutter/material.dart';

/// A button that shows a loading indicator when processing.
/// Disables interaction during loading state.
/// 
/// Used for:
/// - Login/Register buttons
/// - Form submissions
/// - API calls that require user feedback
class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;

  const LoadingButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveForegroundColor = foregroundColor ?? theme.colorScheme.onPrimary;
    
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: effectiveForegroundColor,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: elevation ?? 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 24),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(effectiveForegroundColor),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}
