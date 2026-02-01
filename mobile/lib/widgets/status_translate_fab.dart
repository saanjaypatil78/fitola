import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitola/config/theme.dart';
import 'package:fitola/models/fitbuddy.dart';
import 'package:fitola/providers/status_provider.dart';
import 'package:fitola/providers/chat_provider.dart';

class StatusTranslateFab extends StatefulWidget {
  const StatusTranslateFab({super.key});

  @override
  State<StatusTranslateFab> createState() => _StatusTranslateFabState();
}

class _StatusTranslateFabState extends State<StatusTranslateFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StatusProvider, ChatProvider>(
      builder: (context, statusProvider, chatProvider, child) {
        return AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status Options
                if (_isExpanded) ...[
                  _buildStatusOption(
                    context,
                    'Available',
                    Icons.check_circle,
                    FitolaTheme.availableColor,
                    () {
                      statusProvider.setAvailable();
                      _toggleExpanded();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildStatusOption(
                    context,
                    'Busy',
                    Icons.do_not_disturb,
                    FitolaTheme.busyColor,
                    () {
                      statusProvider.setBusy();
                      _toggleExpanded();
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildStatusOption(
                    context,
                    'Ghost',
                    Icons.visibility_off,
                    FitolaTheme.ghostColor,
                    () {
                      statusProvider.activateGhostMode();
                      _toggleExpanded();
                      _showGhostModeDialog(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  // Translation Toggle
                  _buildTranslationToggle(context, chatProvider),
                  const SizedBox(height: 12),
                ],
                // Main FAB
                FloatingActionButton(
                  onPressed: _toggleExpanded,
                  child: AnimatedRotation(
                    turns: _isExpanded ? 0.125 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      _isExpanded ? Icons.close : _getStatusIcon(statusProvider.currentStatus),
                    ),
                  ),
                  backgroundColor: _getStatusColor(statusProvider.currentStatus),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatusOption(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Opacity(
      opacity: _expandAnimation.value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            onPressed: onTap,
            backgroundColor: color,
            child: Icon(icon, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationToggle(BuildContext context, ChatProvider chatProvider) {
    return Opacity(
      opacity: _expandAnimation.value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              'Translate',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            onPressed: () {
              chatProvider.toggleTranslation(!chatProvider.isTranslationEnabled);
            },
            backgroundColor: chatProvider.isTranslationEnabled
                ? FitolaTheme.primaryColor
                : Colors.grey,
            child: const Icon(Icons.translate, size: 20),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(UserStatus status) {
    switch (status) {
      case UserStatus.available:
        return Icons.check_circle;
      case UserStatus.busy:
        return Icons.do_not_disturb;
      case UserStatus.ghost:
        return Icons.visibility_off;
    }
  }

  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.available:
        return FitolaTheme.availableColor;
      case UserStatus.busy:
        return FitolaTheme.busyColor;
      case UserStatus.ghost:
        return FitolaTheme.ghostColor;
    }
  }

  void _showGhostModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ghost Mode Activated'),
        content: const Text(
          'You are now hidden from the map. Other users cannot see your location. '
          'You can still share your location via direct messages.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
