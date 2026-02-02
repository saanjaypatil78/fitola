import 'package:flutter/material.dart';

/// A stateless custom floating action button with themed variants.
/// Provides consistent FAB styling across the app.
class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;
  final bool mini;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? heroTag;

  const CustomFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.mini = false,
    this.backgroundColor,
    this.foregroundColor,
    this.heroTag,
  }) : super(key: key);

  /// Extended FAB with text label
  const CustomFloatingActionButton.extended({
    Key? key,
    required this.onPressed,
    required this.icon,
    required String label,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
    this.heroTag,
  })  : mini = false,
        _label = label,
        super(key: key);

  final String? _label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(_label!),
        tooltip: tooltip,
        backgroundColor: backgroundColor ?? colorScheme.primary,
        foregroundColor: foregroundColor ?? colorScheme.onPrimary,
        heroTag: heroTag,
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      mini: mini,
      backgroundColor: backgroundColor ?? colorScheme.primary,
      foregroundColor: foregroundColor ?? colorScheme.onPrimary,
      heroTag: heroTag,
      child: Icon(icon),
    );
  }
}
