import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/emoji_helper.dart';
import '../../core/services/reaction_storage_service.dart';

class ReactionDisplay extends StatelessWidget {
  final Map<String, int> reactions;
  final Function(String unicode)? onReactionTap;
  final int? postId;
  final int? commentId;

  const ReactionDisplay({
    super.key,
    required this.reactions,
    this.onReactionTap,
    this.postId,
    this.commentId,
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
        final unicode = entry.key;

        return FutureBuilder<bool>(
          future: _checkIfUserReacted(unicode),
          builder: (context, snapshot) {
            final isUserReaction = snapshot.data ?? false;
            
            return GestureDetector(
              onTap: onReactionTap != null
                  ? () => onReactionTap!(unicode)
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  // Semi-transparent background for user's own reactions
                  color: isUserReaction
                      ? AppConstants.primaryColor.withValues(alpha: 0.2)
                      : AppConstants.surfaceColor,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                  border: Border.all(
                    // Stronger border for user's own reactions
                    color: isUserReaction
                        ? AppConstants.primaryColor.withValues(alpha: 0.6)
                        : AppConstants.primaryColor.withValues(alpha: 0.3),
                    width: isUserReaction ? 1.5 : 1,
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
                        color: isUserReaction
                            ? AppConstants.primaryColor
                            : AppConstants.textSecondaryColor,
                        fontSize: 12,
                        fontWeight: isUserReaction ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Future<bool> _checkIfUserReacted(String unicode) async {
    if (postId != null) {
      return await ReactionStorageService.hasPostReaction(postId!, unicode);
    } else if (commentId != null) {
      return await ReactionStorageService.hasCommentReaction(commentId!, unicode);
    }
    return false;
  }
}

