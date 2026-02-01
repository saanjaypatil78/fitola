import 'package:flutter/material.dart';
import 'package:fitola/config/routes.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text('User ${index + 1}'),
          subtitle: const Text('Points: 1000'),
          trailing: IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.ranking),
          ),
        ),
      ),
    );
  }
}
