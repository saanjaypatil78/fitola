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
  
  Map<String, List<ChatMessage>> get conversations => _conversations;
  List<Map<String, dynamic>> get conversationsList => _conversationsList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isTranslationEnabled => _translationService.isTranslationEnabled;
  
  void initialize(String userId) {
    _chatService.connectSocket(userId);
    _chatService.onNewMessage(_handleNewMessage);
    loadConversationsList(userId);
  }
  
  void dispose() {
    _chatService.disconnectSocket();
    super.dispose();
  }
  
  void _handleNewMessage(ChatMessage message) {
    final conversationId = message.conversationId ?? '${message.senderId}_${message.receiverId}';
    
    if (_conversations[conversationId] == null) {
      _conversations[conversationId] = [];
    }
    
    _conversations[conversationId]!.add(message);
    notifyListeners();
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
      _handleNewMessage(sentMessage);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
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
