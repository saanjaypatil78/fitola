import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';
import 'package:fitola/models/fitbuddy.dart';

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

  /// Build a marker based on user status
  static Widget buildStatusMarker({
    required String name,
    required String gender,
    required UserStatus status,
    double size = 40,
  }) {
    final genderColor = gender.toLowerCase() == 'female'
        ? FitolaTheme.femaleColor
        : FitolaTheme.maleColor;

    Color markerColor;
    IconData icon;
    
    switch (status) {
      case UserStatus.available:
        markerColor = genderColor;
        icon = Icons.person;
        break;
      case UserStatus.busy:
        markerColor = FitolaTheme.busyColor;
        icon = Icons.do_not_disturb;
        break;
      case UserStatus.ghost:
        markerColor = FitolaTheme.ghostColor;
        icon = Icons.visibility_off;
        break;
    }

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

  /// Build a marker with initials
  static Widget buildInitialsMarker({
    required String name,
    required String gender,
    required UserStatus status,
    double size = 40,
  }) {
    final genderColor = gender.toLowerCase() == 'female'
        ? FitolaTheme.femaleColor
        : FitolaTheme.maleColor;

    Color markerColor;
    switch (status) {
      case UserStatus.available:
        markerColor = genderColor;
        break;
      case UserStatus.busy:
        markerColor = FitolaTheme.busyColor;
        break;
      case UserStatus.ghost:
        markerColor = FitolaTheme.ghostColor;
        break;
    }

    // Extract initials
    final parts = name.trim().split(' ');
    final initials = parts.length >= 2
        ? '${parts[0][0]}${parts[1][0]}'.toUpperCase()
        : name.isNotEmpty
            ? name[0].toUpperCase()
            : '?';

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
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Build a marker for current user location
  static Widget buildCurrentUserMarker({
    double size = 40,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer pulse animation circle
        Container(
          width: size * 1.5,
          height: size * 1.5,
          decoration: BoxDecoration(
            color: FitolaTheme.primaryColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),
        // Inner marker
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: FitolaTheme.primaryColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.navigation,
            color: Colors.white,
            size: size * 0.6,
          ),
        ),
      ],
    );
  }

  /// Build a marker for workout locations
  static Widget buildWorkoutMarker({
    required IconData icon,
    double size = 40,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: FitolaTheme.secondaryColor,
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
