import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/ai_assistant/presentation/view/widgets/ai_chat_header.dart';
import 'package:dinereserve/feature/ai_assistant/presentation/view/widgets/ai_input_area.dart';
import 'package:dinereserve/feature/ai_assistant/presentation/view/widgets/ai_message_bubble.dart';
import 'package:dinereserve/feature/ai_assistant/presentation/view/widgets/ai_suggestion_chips.dart';
import 'package:dinereserve/feature/ai_assistant/presentation/view/widgets/ai_typing_indicator.dart';
import 'package:dinereserve/feature/ai_assistant/presentation/view_model/ai_assistant_cubit.dart';
import 'package:dinereserve/feature/ai_assistant/presentation/view_model/ai_assistant_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiAssistantView extends StatelessWidget {
  const AiAssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AiAssistantCubit(),
      child: const _AiAssistantViewBody(),
    );
  }
}

class _AiAssistantViewBody extends StatefulWidget {
  const _AiAssistantViewBody();

  @override
  State<_AiAssistantViewBody> createState() => _AiAssistantViewBodyState();
}

class _AiAssistantViewBodyState extends State<_AiAssistantViewBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF7FAFC),
              Colors.white,
              AppColors.primaryColor.withAlpha(25),
            ],
          ),
        ),
        child: Column(
          children: [
            const AiChatHeader(),
            Expanded(
              child: BlocConsumer<AiAssistantCubit, AiAssistantState>(
                listener: (context, state) {
                  if (state is AiAssistantLoaded) {
                    _scrollToBottom();
                  }
                },
                builder: (context, state) {
                  if (state is AiAssistantLoaded) {
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemCount:
                          state.messages.length + (state.isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.messages.length) {
                          return const AiTypingIndicator();
                        }

                        final message = state.messages[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AiMessageBubble(message: message),
                            if (!message.isUser && message.suggestions != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 20,
                                  left: 40,
                                ),
                                child: AiSuggestionChips(
                                  suggestions: message.suggestions!,
                                  onSelected: (suggestion) {
                                    context
                                        .read<AiAssistantCubit>()
                                        .sendMessage(suggestion);
                                  },
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            AiInputArea(
              controller: _messageController,
              onSend: () {
                final text = _messageController.text;
                context.read<AiAssistantCubit>().sendMessage(text);
                _messageController.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
