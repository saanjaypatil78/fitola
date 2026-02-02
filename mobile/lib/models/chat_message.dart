import 'model_utils.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String? conversationId;
  final String message;
  final MessageType type;
  final String? fileUrl;
  final String? fileName;
  final bool isTranslated;
  final String? translatedMessage;
  final DateTime timestamp;
  final bool isRead;
  
  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.conversationId,
    required this.message,
    this.type = MessageType.text,
    this.fileUrl,
    this.fileName,
    this.isTranslated = false,
    this.translatedMessage,
    required this.timestamp,
    this.isRead = false,
  });
  
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      conversationId: json['conversation_id'] as String?,
      message: json['message'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MessageType.text,
      ),
      fileUrl: json['file_url'] as String?,
      fileName: json['file_name'] as String?,
      isTranslated: json['is_translated'] as bool? ?? false,
      translatedMessage: json['translated_message'] as String?,
      timestamp: parseDateTimeRequired(json['timestamp']),
      isRead: json['is_read'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'conversation_id': conversationId,
      'message': message,
      'type': type.toString().split('.').last,
      'file_url': fileUrl,
      'file_name': fileName,
      'is_translated': isTranslated,
      'translated_message': translatedMessage,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }
  
  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? conversationId,
    String? message,
    MessageType? type,
    String? fileUrl,
    String? fileName,
    bool? isTranslated,
    String? translatedMessage,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      conversationId: conversationId ?? this.conversationId,
      message: message ?? this.message,
      type: type ?? this.type,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      isTranslated: isTranslated ?? this.isTranslated,
      translatedMessage: translatedMessage ?? this.translatedMessage,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ChatMessage &&
        other.id == id &&
        other.senderId == senderId &&
        other.receiverId == receiverId &&
        other.conversationId == conversationId &&
        other.message == message &&
        other.type == type &&
        other.fileUrl == fileUrl &&
        other.fileName == fileName &&
        other.isTranslated == isTranslated &&
        other.translatedMessage == translatedMessage &&
        other.timestamp == timestamp &&
        other.isRead == isRead;
  }
  
  @override
  int get hashCode {
    return Object.hash(
      id,
      senderId,
      receiverId,
      conversationId,
      message,
      type,
      fileUrl,
      fileName,
      isTranslated,
      translatedMessage,
      timestamp,
      isRead,
    );
  }
  
  @override
  String toString() {
    return 'ChatMessage(id: $id, senderId: $senderId, receiverId: $receiverId, type: $type)';
  }
}

enum MessageType {
  text,
  image,
  document,
  voice,
  location,
}
