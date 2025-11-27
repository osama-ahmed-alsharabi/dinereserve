enum MessageType { text, image, suggestion }

class ChatMessageModel {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;
  final List<String>? suggestions;

  ChatMessageModel({
    required this.id,
    required this.message,
    required this.isUser,
    DateTime? timestamp,
    this.type = MessageType.text,
    this.suggestions,
  }) : timestamp = timestamp ?? DateTime.now();

  ChatMessageModel copyWith({
    String? id,
    String? message,
    bool? isUser,
    DateTime? timestamp,
    MessageType? type,
    List<String>? suggestions,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}
