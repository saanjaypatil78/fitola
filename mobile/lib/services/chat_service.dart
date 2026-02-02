import 'package:fitola/models/chat_message.dart';
import 'package:fitola/services/api_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();
  
  final _apiClient = ApiClient();
  io.Socket? _socket;
  
  void connectSocket(String userId) {
    try {
      _socket = io.io(
        'wss://fitola.vercel.app',
        io.OptionBuilder()
            .setTransports(['websocket'])
            .setQuery({'userId': userId})
            .build(),
      );
      
      _socket?.connect();
      
      _socket?.onConnect((_) {
        print('Socket connected');
      });
      
      _socket?.onDisconnect((_) {
        print('Socket disconnected');
      });
      
      _socket?.onConnectError((error) {
        print('Socket connection error: $error');
      });
      
      _socket?.onError((error) {
        print('Socket error: $error');
      });
    } catch (e) {
      print('Failed to initialize socket: $e');
      throw ChatException('Socket connection failed: $e');
    }
  }
  
  void disconnectSocket() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
  
  void onNewMessage(Function(ChatMessage) callback) {
    _socket?.on('new_message', (data) {
      final message = ChatMessage.fromJson(data);
      callback(message);
    });
  }
  
  Future<List<ChatMessage>> getConversation(
    String userId,
    String otherUserId,
  ) async {
    try {
      final response = await _apiClient.get(
        '/chat/conversation/$userId/$otherUserId',
      );
      
      if (response['messages'] == null) {
        return [];
      }
      
      final messages = (response['messages'] as List)
          .map((m) => ChatMessage.fromJson(m))
          .toList();
      return messages;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ChatException('Failed to load conversation: $e');
    }
  }
  
  Future<ChatMessage> sendMessage(ChatMessage message) async {
    try {
      final response = await _apiClient.post('/chat/message', message.toJson());
      _socket?.emit('send_message', response);
      return ChatMessage.fromJson(response);
    } catch (e) {
      throw ChatException('Failed to send message: $e');
    }
  }
  
  Future<String> translateMessage(String message, String targetLanguage) async {
    try {
      final response = await _apiClient.post('/chat/translate', {
        'message': message,
        'target_language': targetLanguage,
      });
      return response['translated_message'] as String;
    } catch (e) {
      throw ChatException('Translation failed: $e');
    }
  }
  
  Future<String> uploadFile(String filePath) async {
    try {
      // In a real implementation, this would use multipart/form-data
      final response = await _apiClient.post('/chat/upload', {
        'file_path': filePath,
      });
      return response['file_url'] as String;
    } catch (e) {
      throw ChatException('File upload failed: $e');
    }
  }
  
  Future<void> markAsRead(String messageId) async {
    try {
      await _apiClient.put('/chat/message/$messageId/read', {});
    } catch (e) {
      throw ChatException('Failed to mark message as read: $e');
    }
  }
  
  Future<List<Map<String, dynamic>>> getConversationsList(String userId) async {
    try {
      final response = await _apiClient.get('/chat/conversations/$userId');
      
      if (response['conversations'] == null) {
        return [];
      }
      
      return List<Map<String, dynamic>>.from(response['conversations']);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ChatException('Failed to load conversations: $e');
    }
  }
  
  Future<void> sendChatRequest(String fromUserId, String toUserId) async {
    try {
      await _apiClient.post('/chat/request', {
        'from_user_id': fromUserId,
        'to_user_id': toUserId,
      });
    } catch (e) {
      throw ChatException('Failed to send chat request: $e');
    }
  }
  
  Future<void> acceptChatRequest(String requestId) async {
    try {
      await _apiClient.put('/chat/request/$requestId/accept', {});
    } catch (e) {
      throw ChatException('Failed to accept chat request: $e');
    }
  }
}

class ChatException implements Exception {
  final String message;
  ChatException(this.message);
  
  @override
  String toString() => message;
}
