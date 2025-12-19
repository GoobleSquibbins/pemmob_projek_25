import 'package:flutter/material.dart';
import '../../data/models/comment_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';

class CommentItem extends StatefulWidget {
  final CommentModel comment;
  final Function(int commentId)? onReply;
  final Function(int commentId)? onLoadReplies;
  final List<CommentModel>? replies;

  const CommentItem({
    super.key,
    required this.comment,
    this.onReply,
    this.onLoadReplies,
    this.replies,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _isRepliesExpanded = false;
  bool _isLoadingReplies = false;

  @override
  void initState() {
    super.initState();
    if (widget.replies != null && widget.replies!.isNotEmpty) {
      _isRepliesExpanded = true;
    }
  }

  @override
  void didUpdateWidget(CommentItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update expanded state when replies are loaded
    if (widget.replies != null && widget.replies!.isNotEmpty && !_isRepliesExpanded) {
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

  void _toggleReplies() {
    if (_isRepliesExpanded) {
      // Hide replies - just toggle the state
      setState(() {
        _isRepliesExpanded = false;
      });
    } else {
      // Show replies - load if not already loaded
      if (widget.replies == null || widget.replies!.isEmpty) {
        _loadReplies();
      } else {
        // Replies already loaded, just show them
        setState(() {
          _isRepliesExpanded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasReplies = widget.comment.replyCount > 0;
    final isReply = widget.comment.parentId != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Comment container
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          margin: EdgeInsets.only(
            bottom: AppConstants.spacingSmall,
            left: isReply ? AppConstants.spacingMedium : 0,
          ),
          decoration: BoxDecoration(
            color: isReply 
                ? AppConstants.backgroundColor 
                : AppConstants.surfaceColor,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
            border: isReply
                ? Border(
                    left: BorderSide(
                      color: AppConstants.primaryColor.withValues(alpha: 0.5),
                      width: 3,
                    ),
                  )
                : null,
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
                    style: TextStyle(
                      color: isReply
                          ? AppConstants.textSecondaryColor.withValues(alpha: 0.7)
                          : AppConstants.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              Text(
                widget.comment.content,
                style: TextStyle(
                  color: isReply
                      ? AppConstants.textPrimaryColor.withValues(alpha: 0.9)
                      : AppConstants.textPrimaryColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              // Only show reply button for root comments, not replies
              if (widget.onReply != null && !isReply)
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
            ],
          ),
        ),
        if (hasReplies) ...[
          Padding(
            padding: EdgeInsets.only(
              left: isReply 
                  ? AppConstants.spacingMedium * 2 
                  : AppConstants.spacingMedium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle button for show/hide replies
                TextButton(
                  onPressed: _isRepliesExpanded ? _toggleReplies : _loadReplies,
                  child: Text(
                    _isRepliesExpanded
                        ? 'Hide ${widget.comment.replyCount} ${widget.comment.replyCount == 1 ? 'reply' : 'replies'}'
                        : 'View ${widget.comment.replyCount} ${widget.comment.replyCount == 1 ? 'reply' : 'replies'}',
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
                  else if (widget.replies != null && widget.replies!.isNotEmpty)
                    ...widget.replies!.map(
                      (reply) => CommentItem(
                        comment: reply,
                        onReply: widget.onReply,
                        onLoadReplies: widget.onLoadReplies,
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

