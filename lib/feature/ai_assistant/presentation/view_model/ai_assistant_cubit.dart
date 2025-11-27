import 'dart:async';
import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/feature/ai_assistant/data/model/chat_message_model.dart';
import 'package:dinereserve/feature/ai_assistant/data/repo/ai_repository.dart';
import 'package:dinereserve/feature/ai_assistant/data/service/ai_context_service.dart';
import 'package:dinereserve/feature/ai_assistant/presentation/view_model/ai_assistant_state.dart';
import 'package:dinereserve/feature/profile_restaurant/data/profile_restaurant_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AiAssistantCubit extends Cubit<AiAssistantState> {
  late final AiRepository _aiRepository;
  late final AiContextService _contextService;
  final _uuid = const Uuid();
  List<ChatMessageModel> _messages = [];
  String? _systemPrompt;

  AiAssistantCubit() : super(AiAssistantInitial()) {
    _aiRepository = AiRepository();
    _contextService = AiContextService(
      getIt.get<GetRestaurantRepo>(),
      getIt.get<SupabaseClient>(),
    );
    _initChat();
  }

  Future<void> _initChat() async {
    // Initial welcome message
    _messages = [
      ChatMessageModel(
        id: _uuid.v4(),
        message:
            "Hello! 👋\n\nI'm your DineReserve AI Assistant. I can help you find restaurants, check your bookings, and answer any questions you have.\n\nHow can I help you today?",
        isUser: false,
        suggestions: [
          "Find Italian restaurants 🍝",
          "My bookings 📅",
          "Recommend a place 📍",
        ],
      ),
    ];
    emit(AiAssistantLoaded(messages: _messages));

    // Load system prompt in background
    _systemPrompt = await _contextService.getSystemPrompt();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final currentState = state;
    if (currentState is AiAssistantLoaded) {
      // Add user message
      final userMessage = ChatMessageModel(
        id: _uuid.v4(),
        message: text,
        isUser: true,
      );

      _messages = List.from(_messages)..add(userMessage);
      emit(currentState.copyWith(messages: _messages, isTyping: true));

      try {
        // Ensure system prompt is loaded
        _systemPrompt ??= await _contextService.getSystemPrompt();

        // Get response from AI
        final responseText = await _aiRepository.sendMessage(
          history: _messages, // Send full history including current message
          systemPrompt: _systemPrompt!,
        );

        // Parse response for suggestions (simple heuristic)
        List<String>? suggestions;
        if (responseText.contains("?")) {
          suggestions = ["Yes", "No", "Tell me more"];
        }

        final botMessage = ChatMessageModel(
          id: _uuid.v4(),
          message: responseText,
          isUser: false,
          suggestions: suggestions,
        );

        _messages = List.from(_messages)..add(botMessage);
        emit(currentState.copyWith(messages: _messages, isTyping: false));
      } catch (e) {
        // Add error message
        final errorMessage = ChatMessageModel(
          id: _uuid.v4(),
          message:
              "I apologize, but I'm having trouble connecting right now. Please try again later.",
          isUser: false,
        );
        _messages = List.from(_messages)..add(errorMessage);
        emit(currentState.copyWith(messages: _messages, isTyping: false));
      }
    }
  }
}
