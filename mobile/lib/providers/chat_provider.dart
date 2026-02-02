import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fitola/models/chat_message.dart';
import 'package:fitola/services/chat_service.dart';
import 'package:fitola/services/translation_service.dart';

class ChatProvider with ChangeNotifier {
  final _chatService = ChatService();
  final _translationService = TranslationService();
  
  Map<String, List<ChatMessage>> _conversations = {};
  List<Map<String, dynamic>> _conversationsList = [];
  bool _isLoading = false;
  String? _error;
  Timer? _pollingTimer;
  String? _currentUserId;
  
  Map<String, List<ChatMessage>> get conversations => _conversations;
  List<Map<String, dynamic>> get conversationsList => _conversationsList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isTranslationEnabled => _translationService.isTranslationEnabled;
  
  void initialize(String userId) {
    _currentUserId = userId;
    loadConversationsList(userId);
    _startPolling();
  }
  
  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }
  
  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _pollForNewMessages(),
    );
  }
  
  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }
  
  Future<void> _pollForNewMessages() async {
    if (_currentUserId == null) return;
    
    try {
      // Reload conversations list to check for new messages
      final newConversationsList = await _chatService.getConversationsList(_currentUserId!);
      
      // Check if there are any changes by comparing both length and content
      bool hasChanges = false;
      
      if (newConversationsList.length != _conversationsList.length) {
        hasChanges = true;
      } else {
        // Compare last message timestamps or message counts
        for (int i = 0; i < newConversationsList.length; i++) {
          final newConv = newConversationsList[i];
          final oldConv = _conversationsList.length > i ? _conversationsList[i] : null;
          
          if (oldConv == null || 
              newConv['last_message_time'] != oldConv['last_message_time'] ||
              newConv['unread_count'] != oldConv['unread_count']) {
            hasChanges = true;
            break;
          }
        }
      }
      
      if (hasChanges) {
        _conversationsList = newConversationsList;
        notifyListeners();
      }
    } catch (e) {
      // Silent fail for polling
    }
  }
  
  Future<void> loadConversation(String userId, String otherUserId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      final messages = await _chatService.getConversation(userId, otherUserId);
      final conversationId = '${userId}_$otherUserId';
      _conversations[conversationId] = messages;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> loadConversationsList(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      _conversationsList = await _chatService.getConversationsList(userId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> sendMessage(ChatMessage message) async {
    try {
      final sentMessage = await _chatService.sendMessage(message);
      
      // Add message to local state
      final conversationId = sentMessage.conversationId ?? 
          '${sentMessage.senderId}_${sentMessage.receiverId}';
      
      if (_conversations[conversationId] == null) {
        _conversations[conversationId] = [];
      }
      
      _conversations[conversationId]!.add(sentMessage);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
  
  Future<void> sendChatRequest(String fromUserId, String toUserId) async {
    try {
      await _chatService.sendChatRequest(fromUserId, toUserId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<void> acceptChatRequest(String requestId) async {
    try {
      await _chatService.acceptChatRequest(requestId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
  Future<String> translateMessage(String message) async {
    try {
      return await _translationService.translate(message);
    } catch (e) {
      return message;
    }
  }
  
  void toggleTranslation(bool enabled) {
    _translationService.toggleTranslation(enabled);
    notifyListeners();
  }
  
  Future<void> markAsRead(String messageId) async {
    try {
      await _chatService.markAsRead(messageId);
    } catch (e) {
      // Silent fail
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
