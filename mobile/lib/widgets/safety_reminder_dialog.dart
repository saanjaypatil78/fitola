import 'package:flutter/material.dart';

class SafetyReminderDialog extends StatelessWidget {
  const SafetyReminderDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Safety Reminder'),
      content: const Text(
        'You are about to enable precise location sharing. '
        'Please be mindful of your safety when sharing your location with others.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('I Understand'),
        ),
      ],
    );
  }
}
