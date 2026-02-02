import 'package:flutter/material.dart';
import 'package:fitola/config/theme.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSent;
  final DateTime timestamp;
  final bool isTranslated;
  final bool isRead;
  final bool showTimestamp;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isSent,
    required this.timestamp,
    this.isTranslated = false,
    this.isRead = false,
    this.showTimestamp = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('MMM d, yyyy');
    final now = DateTime.now();
    final isToday = timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isSent ? FitolaTheme.primaryColor : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isSent ? const Radius.circular(16) : Radius.zero,
                bottomRight: isSent ? Radius.zero : const Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isTranslated) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.translate,
                        size: 12,
                        color: isSent ? Colors.white70 : Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Translated',
                        style: TextStyle(
                          fontSize: 10,
                          color: isSent ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  message,
                  style: TextStyle(
                    color: isSent ? Colors.white : Colors.black87,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeFormat.format(timestamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: isSent ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    if (isSent) ...[
                      const SizedBox(width: 4),
                      Icon(
                        isRead ? Icons.done_all : Icons.done,
                        size: 14,
                        color: isRead ? Colors.lightBlue[200] : Colors.white70,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (showTimestamp)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: Text(
                isToday ? timeFormat.format(timestamp) : dateFormat.format(timestamp),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: FitolaTheme.textSecondary,
                      fontSize: 11,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
