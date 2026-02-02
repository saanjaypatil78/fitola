import 'package:flutter/material.dart';

/// A card widget that can be selected/deselected with visual feedback.
/// Changes elevation and border when selected.
/// 
/// Used for:
/// - Goal selection screens
/// - Plan type selection (workout vs nutrition)
/// - Choice grids where user picks one or more options
class SelectableCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? iconColor;

  const SelectableCard({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveSelectedColor = selectedColor ?? theme.colorScheme.primary;
    
    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? effectiveSelectedColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: isSelected 
                    ? effectiveSelectedColor 
                    : (iconColor ?? theme.colorScheme.onSurface.withOpacity(0.7)),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isSelected 
                      ? effectiveSelectedColor 
                      : theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
