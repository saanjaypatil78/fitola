import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

/// Static utility class for building custom map markers with Material 3 theming.
/// Used in map and location-based features.
/// 
/// Note: Map markers use white borders intentionally as they appear on map tiles
/// (not app backgrounds) and need universal contrast against any map style.
class CustomMarkers {
  /// Builds a circular map marker for a user
  static Widget buildMarker({
    required String name,
    required String gender,
    required bool isAvailable,
    double size = 40,
  }) {
    final color = gender.toLowerCase() == 'female'
        ? FitolaTheme.femaleColor
        : FitolaTheme.maleColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isAvailable ? color : FitolaTheme.ghostColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 20),
    );
  }

  /// Builds a marker with custom icon
  static Widget buildCustomMarker({
    required IconData icon,
    Color? color,
    double size = 40,
  }) {
    final markerColor = color ?? FitolaTheme.primaryColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: markerColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.5),
    );
  }
}
