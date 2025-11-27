import 'package:dinereserve/feature/ai_assistant/data/model/chat_message_model.dart';

abstract class AiAssistantState {}

class AiAssistantInitial extends AiAssistantState {}

class AiAssistantLoading extends AiAssistantState {}

class AiAssistantLoaded extends AiAssistantState {
  final List<ChatMessageModel> messages;
  final bool isTyping;

  AiAssistantLoaded({required this.messages, this.isTyping = false});

  AiAssistantLoaded copyWith({
    List<ChatMessageModel>? messages,
    bool? isTyping,
  }) {
    return AiAssistantLoaded(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class AiAssistantError extends AiAssistantState {
  final String message;

  AiAssistantError(this.message);
}
