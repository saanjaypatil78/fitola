import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitola/config/routes.dart';
import 'package:fitola/config/theme.dart';
import 'package:fitola/providers/chat_provider.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    setState(() => _isLoading = true);
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.loadConversations();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final conversations = chatProvider.conversations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : conversations.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
                  onRefresh: _loadChats,
                  child: ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      // Placeholder data
                      final isOnline = index % 3 == 0;
                      final unreadCount = index % 4 == 0 ? index + 1 : 0;
                      final lastMessage = index % 2 == 0 
                          ? 'Hey! Ready for today\'s workout?' 
                          : 'Thanks for the fitness tips!';
                      final timestamp = index == 0 ? 'Now' : 
                                       index == 1 ? '5m ago' :
                                       index == 2 ? '1h ago' : 
                                       '${index}h ago';
                      
                      return _buildChatTile(
                        context,
                        'User ${index + 1}',
                        lastMessage,
                        timestamp,
                        isOnline,
                        unreadCount,
                        () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.chatDetail,
                            arguments: {
                              'userId': 'user_${index + 1}',
                              'userName': 'User ${index + 1}',
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.fitbuddyMap);
        },
        child: const Icon(Icons.add_comment),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No Conversations Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find FitBuddies on the map and start chatting!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: FitolaTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.fitbuddyMap);
              },
              icon: const Icon(Icons.map),
              label: const Text('Find FitBuddies'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTile(
    BuildContext context,
    String name,
    String lastMessage,
    String timestamp,
    bool isOnline,
    int unreadCount,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: FitolaTheme.primaryColor,
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (isOnline)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Text(
              timestamp,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: unreadCount > 0 ? FitolaTheme.primaryColor : FitolaTheme.textSecondary,
                fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (unreadCount > 0)
              Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: FitolaTheme.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
