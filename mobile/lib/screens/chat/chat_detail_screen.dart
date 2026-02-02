import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitola/config/theme.dart';
import 'package:fitola/providers/chat_provider.dart';
import 'package:fitola/models/chat_message.dart';
import 'package:fitola/widgets/chat_bubble.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTranslationEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    // Simulate loading messages
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _isLoading = false);
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // TODO: Send message through provider
    final chatProvider = context.read<ChatProvider>();
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'current_user',
      receiverId: 'other_user',
      message: text,
      timestamp: DateTime.now(),
      isRead: false,
    );
    
    chatProvider.sendMessage(message);
    _messageController.clear();
    
    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final userName = args?['userName'] ?? 'Chat';
    
    // Mock messages for display
    final mockMessages = [
      ChatMessage(
        id: '1',
        senderId: 'other_user',
        receiverId: 'current_user',
        message: 'Hey! Are you up for a workout today?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      ChatMessage(
        id: '2',
        senderId: 'current_user',
        receiverId: 'other_user',
        message: 'Absolutely! What time works for you?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
        isRead: true,
      ),
      ChatMessage(
        id: '3',
        senderId: 'other_user',
        receiverId: 'current_user',
        message: 'How about 6 PM at the gym?',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
        isRead: true,
      ),
      ChatMessage(
        id: '4',
        senderId: 'current_user',
        receiverId: 'other_user',
        message: 'Perfect! See you then 💪',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        isRead: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: FitolaTheme.primaryColor,
              child: Text(
                userName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // TODO: Implement voice call
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Voice call coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // TODO: Implement video call
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video call coming soon')),
              );
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      _isTranslationEnabled ? Icons.translate_off : Icons.translate,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(_isTranslationEnabled ? 'Disable Translation' : 'Enable Translation'),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _isTranslationEnabled = !_isTranslationEnabled;
                  });
                  context.read<ChatProvider>().toggleTranslation(_isTranslationEnabled);
                },
              ),
              const PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.block, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Block User', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Translation Banner
          if (_isTranslationEnabled)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: FitolaTheme.primaryColor.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.translate, size: 16, color: FitolaTheme.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'Translation enabled',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: FitolaTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          
          // Messages List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: mockMessages.length,
                    itemBuilder: (context, index) {
                      final message = mockMessages[index];
                      final isMe = message.senderId == 'current_user';
                      
                      return ChatBubble(
                        message: message.message,
                        isMe: isMe,
                        timestamp: message.timestamp,
                      );
                    },
                  ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      // TODO: Implement file attachment
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('File attachment coming soon')),
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: FitolaTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
