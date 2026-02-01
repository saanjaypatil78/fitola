import 'package:flutter/material.dart';
import 'package:fitola/config/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitola Home')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        children: [
          _buildFeatureCard(context, 'Dashboard', Icons.dashboard, AppRoutes.dashboard),
          _buildFeatureCard(context, 'Chat', Icons.chat, AppRoutes.chatList),
          _buildFeatureCard(context, 'Map', Icons.map, AppRoutes.fitbuddyMap),
          _buildFeatureCard(context, 'AI Trainer', Icons.fitness_center, AppRoutes.aiTrainer),
          _buildFeatureCard(context, 'Leaderboard', Icons.leaderboard, AppRoutes.leaderboard),
          _buildFeatureCard(context, 'Profile', Icons.person, AppRoutes.profile),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, String route) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
