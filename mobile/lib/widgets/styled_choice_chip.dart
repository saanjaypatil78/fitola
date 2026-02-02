import 'package:flutter/material.dart';

/// A styled choice chip that follows the app's theme.
/// Provides consistent styling for selectable options.
/// 
/// Used in:
/// - Difficulty selection (Beginner, Intermediate, Advanced)
/// - Day selection in nutrition plans
/// - Filter options
class StyledChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;
  final Color? selectedColor;
  final IconData? icon;

  const StyledChoiceChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.selectedColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveSelectedColor = selectedColor ?? theme.colorScheme.primary;
    
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            ),
            const SizedBox(width: 6),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: effectiveSelectedColor,
      backgroundColor: theme.colorScheme.surface,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected 
              ? effectiveSelectedColor 
              : theme.colorScheme.outline.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      elevation: isSelected ? 2 : 0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
