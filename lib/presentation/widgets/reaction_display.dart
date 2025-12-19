import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/emoji_helper.dart';

class ReactionDisplay extends StatelessWidget {
  final Map<String, int> reactions;
  final Function(String unicode)? onReactionTap;

  const ReactionDisplay({
    super.key,
    required this.reactions,
    this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    final filteredReactions = EmojiHelper.filterReactions(reactions);

    if (filteredReactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: AppConstants.spacingSmall,
      runSpacing: AppConstants.spacingSmall,
      children: filteredReactions.entries.map((entry) {
        final emoji = EmojiHelper.unicodeToEmoji(entry.key);
        final count = entry.value;

        return GestureDetector(
          onTap: onReactionTap != null
              ? () => onReactionTap!(entry.key)
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppConstants.surfaceColor,
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
              border: Border.all(
                color: AppConstants.primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 4),
                Text(
                  count.toString(),
                  style: TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

