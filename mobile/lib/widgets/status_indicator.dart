import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';
import 'package:fitola/models/fitbuddy.dart';

/// A stateless visual status indicator component.
/// Used to display user availability status (available, busy, ghost).
class StatusIndicator extends StatelessWidget {
  final UserStatus status;
  final double size;
  final bool showLabel;

  const StatusIndicator({
    Key? key,
    required this.status,
    this.size = 12,
    this.showLabel = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (showLabel) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIndicator(),
          const SizedBox(width: 8),
          Text(
            _getStatusLabel(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return _buildIndicator();
  }

  Widget _buildIndicator() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getStatusColor(),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: size > 12 ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case UserStatus.available:
        return FitolaTheme.availableColor;
      case UserStatus.busy:
        return FitolaTheme.busyColor;
      case UserStatus.ghost:
        return FitolaTheme.ghostColor;
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case UserStatus.available:
        return 'Available';
      case UserStatus.busy:
        return 'Busy';
      case UserStatus.ghost:
        return 'Ghost';
    }
  }
}
