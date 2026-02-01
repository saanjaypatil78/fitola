import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';

class CustomMarkers {
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
}
