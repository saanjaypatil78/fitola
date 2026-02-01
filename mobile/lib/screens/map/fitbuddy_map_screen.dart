import 'package:flutter/material.dart';

class FitbuddyMapScreen extends StatelessWidget {
  const FitbuddyMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FitBuddy Map')),
      body: const Center(child: Text('Map will be displayed here')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
