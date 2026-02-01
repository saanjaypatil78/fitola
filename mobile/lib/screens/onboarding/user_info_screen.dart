import 'package:flutter/material.dart';
import 'package:fitola/config/routes.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Information')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.bodyType),
          child: const Text('Next: Body Type'),
        ),
      ),
    );
  }
}
