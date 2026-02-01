import 'package:flutter/material.dart';

class NutritionPlanScreen extends StatelessWidget {
  const NutritionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition Plan')),
      body: const Center(child: Text('Nutrition Plan Screen')),
    );
  }
}
