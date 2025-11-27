import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AiSuggestionChips extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onSelected;

  const AiSuggestionChips({
    super.key,
    required this.suggestions,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: suggestions.map((suggestion) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(
                suggestion,
                style: const TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 2,
              shadowColor: Colors.black.withAlpha(25),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: AppColors.primaryColor.withAlpha(25),
                  width: 1,
                ),
              ),
              onPressed: () => onSelected(suggestion),
            ),
          );
        }).toList(),
      ),
    );
  }
}
