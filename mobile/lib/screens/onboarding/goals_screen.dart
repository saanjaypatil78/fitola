import 'package:flutter/material.dart';
import 'package:fitola/config/routes.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Goals')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
          child: const Text('Complete Onboarding'),
        ),
      ),
    );
  }
}
