import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/feature/ai_assistant/data/model/chat_message_model.dart';
import 'package:dinereserve/feature/ai_assistant/presentation/view/widgets/ai_restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

class AiMessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const AiMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildBotAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: isUser
                        ? const LinearGradient(
                            colors: [AppColors.primaryColor, Color(0xFF6366F1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isUser ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(24),
                      topRight: const Radius.circular(24),
                      bottomLeft: Radius.circular(isUser ? 24 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isUser
                            ? AppColors.primaryColor.withAlpha(26)
                            : Colors.black.withAlpha(26),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isUser
                      ? Text(
                          message.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : _buildBotMessageContent(context),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isUser) _buildUserAvatar(),
        ],
      ),
    );
  }

  Widget _buildBotMessageContent(BuildContext context) {
    // Check for restaurant tags like [RES:123]
    final parts = message.message.split(RegExp(r'(\[RES:.*?\])'));

    if (parts.length == 1 && !parts[0].contains('[RES:')) {
      // Normal markdown text
      return MarkdownBody(
        data: message.message,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 15,
            height: 1.5,
          ),
          strong: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          listBullet: const TextStyle(color: AppColors.primaryColor),
        ),
      );
    }

    // Mixed content with restaurant cards
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: parts.map((part) {
        if (part.startsWith('[RES:') && part.endsWith(']')) {
          // Extract ID
          final id = part.substring(5, part.length - 1);
          return AiRestaurantCard(
            restaurantId: id,
            restaurantName: "View Restaurant Details", // Placeholder
            imageUrl: null,
          );
        } else if (part.trim().isNotEmpty) {
          return MarkdownBody(
            data: part,
            styleSheet: MarkdownStyleSheet(
              p: const TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 15,
                height: 1.5,
              ),
              strong: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
              listBullet: const TextStyle(color: AppColors.primaryColor),
            ),
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }

  Widget _buildBotAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryColor, Color(0xFF6366F1)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withAlpha(26),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFEDF2F7),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.person_rounded,
        color: Color(0xFFA0AEC0),
        size: 18,
      ),
    );
  }
}
