import 'package:flutter/material.dart';
import 'package:fitola/config/routes.dart';

class BodyTypeScreen extends StatelessWidget {
  const BodyTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Body Type')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.goals),
          child: const Text('Next: Goals'),
        ),
      ),
    );
  }
}
