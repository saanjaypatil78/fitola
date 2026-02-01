import 'package:flutter/material.dart';

class LocationShareScreen extends StatelessWidget {
  const LocationShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Location')),
      body: const Center(child: Text('Location Share Screen')),
    );
  }
}
