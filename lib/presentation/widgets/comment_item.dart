import 'package:flutter/material.dart';
import '../../data/models/comment_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import 'reaction_display.dart';
import 'reaction_button.dart';

class CommentItem extends StatefulWidget {
  final CommentModel comment;
  final Function(int commentId)? onReply;
  final Function(int commentId, String unicode)? onReactionTap;
  final Function(int commentId)? onLoadReplies;
  final List<CommentModel>? replies;

  const CommentItem({
    super.key,
    required this.comment,
    this.onReply,
    this.onReactionTap,
    this.onLoadReplies,
    this.replies,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _isRepliesExpanded = false;
  bool _isLoadingReplies = false;
  List<CommentModel> _loadedReplies = [];

  @override
  void initState() {
    super.initState();
    if (widget.replies != null && widget.replies!.isNotEmpty) {
      _loadedReplies = widget.replies!;
      _isRepliesExpanded = true;
    }
  }

  Future<void> _loadReplies() async {
    if (_isRepliesExpanded || _isLoadingReplies) return;

    setState(() {
      _isLoadingReplies = true;
      _isRepliesExpanded = true;
    });

    if (widget.onLoadReplies != null) {
      await widget.onLoadReplies!(widget.comment.id);
    }

    setState(() {
      _isLoadingReplies = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasReplies = widget.comment.replyCount > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          margin: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
          decoration: BoxDecoration(
            color: AppConstants.surfaceColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.comment.alias ?? AppConstants.anonymousText,
                    style: TextStyle(
                      color: widget.comment.alias != null
                          ? AppConstants.primaryColor
                          : AppConstants.textSecondaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingSmall),
                  Text(
                    DateFormatter.formatRelativeTime(widget.comment.createdAt),
                    style: const TextStyle(
                      color: AppConstants.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              Text(
                widget.comment.content,
                style: const TextStyle(
                  color: AppConstants.textPrimaryColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              Row(
                children: [
                  if (widget.onReply != null)
                    TextButton.icon(
                      onPressed: () => widget.onReply!(widget.comment.id),
                      icon: const Icon(
                        Icons.reply,
                        size: 16,
                        color: AppConstants.primaryColor,
                      ),
                      label: const Text(
                        'Reply',
                        style: TextStyle(
                          color: AppConstants.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (widget.onReactionTap != null)
                    ReactionButton(
                      onReactionSelected: (unicode) {
                        widget.onReactionTap!(widget.comment.id, unicode);
                      },
                    ),
                  Expanded(
                    child: ReactionDisplay(
                      reactions: widget.comment.reactions,
                      onReactionTap: (unicode) {
                        widget.onReactionTap?.call(
                          widget.comment.id,
                          unicode,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (hasReplies) ...[
          Padding(
            padding: const EdgeInsets.only(left: AppConstants.spacingMedium),
            child: Column(
              children: [
                if (!_isRepliesExpanded)
                  TextButton(
                    onPressed: _loadReplies,
                    child: Text(
                      'View ${widget.comment.replyCount} ${widget.comment.replyCount == 1 ? 'reply' : 'replies'}',
                      style: const TextStyle(
                        color: AppConstants.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (_isRepliesExpanded) ...[
                  if (_isLoadingReplies)
                    const Padding(
                      padding: EdgeInsets.all(AppConstants.spacingMedium),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    )
                  else if (_loadedReplies.isNotEmpty)
                    ..._loadedReplies.map(
                      (reply) => CommentItem(
                        comment: reply,
                        onReply: widget.onReply,
                        onReactionTap: widget.onReactionTap,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

