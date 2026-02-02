import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A stateless chat bubble widget with Material 3 theming.
/// Used in chat and messaging screens.
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSent;
  final DateTime timestamp;
  final bool showTimestamp;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isSent,
    required this.timestamp,
    this.showTimestamp = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSent
                    ? colorScheme.primaryContainer
                    : colorScheme.surfaceVariant,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isSent ? 16 : 4),
                  bottomRight: Radius.circular(isSent ? 4 : 16),
                ),
              ),
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSent
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (showTimestamp) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  DateFormat('HH:mm').format(timestamp),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
