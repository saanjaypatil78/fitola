import 'package:flutter/material.dart';

class VoiceVideoCallScreen extends StatelessWidget {
  const VoiceVideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Call')),
      body: const Center(child: Text('Voice/Video Call Screen')),
    );
  }
}
