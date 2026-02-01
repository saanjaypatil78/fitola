import 'package:flutter/material.dart';
import 'package:fitola/config/routes.dart';

class AITrainerScreen extends StatelessWidget {
  const AITrainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Trainer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('AI-Powered Fitness Plans'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.workoutPlan),
              child: const Text('View Workout Plan'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.nutritionPlan),
              child: const Text('View Nutrition Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
