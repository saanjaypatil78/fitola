import 'package:flutter/material.dart';
import 'package:fitola/config/routes.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text('User $index'),
          subtitle: const Text('Last message...'),
          onTap: () => Navigator.pushNamed(context, AppRoutes.chatDetail),
        ),
      ),
    );
  }
}
