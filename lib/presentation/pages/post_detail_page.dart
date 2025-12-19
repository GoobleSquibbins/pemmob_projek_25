import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/post_detail_controller.dart';
import '../widgets/comment_item.dart';
import '../widgets/image_carousel.dart';
import '../widgets/image_viewer.dart';
import '../widgets/reaction_display.dart';
import '../widgets/reaction_button.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/config/api_config.dart';
import '../../data/models/comment_model.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController commentController = TextEditingController();
  int? _replyingToCommentId;
  String? _replyingToCommentContent;

  void _setReplyMode(int commentId, String commentContent) {
    setState(() {
      _replyingToCommentId = commentId;
      _replyingToCommentContent = commentContent;
    });
  }

  void _cancelReplyMode() {
    setState(() {
      _replyingToCommentId = null;
      _replyingToCommentContent = null;
    });
    commentController.clear();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostDetailController());

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Post',
          style: TextStyle(color: AppConstants.textPrimaryColor),
        ),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.post.value == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppConstants.primaryColor,
            ),
          );
        }

        final post = controller.post.value;
        if (post == null) {
          return const Center(
            child: Text(
              'Post not found',
              style: TextStyle(color: AppConstants.textSecondaryColor),
            ),
          );
        }

        final imageUrls = post.attachments
            .map((attachment) => ApiConfig.getImageUrl(attachment.content))
            .toList();

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshComments,
                color: AppConstants.primaryColor,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.spacingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              style: const TextStyle(
                                color: AppConstants.textPrimaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (post.content != null &&
                                post.content!.isNotEmpty) ...[
                              const SizedBox(height: AppConstants.spacingMedium),
                              Text(
                                post.content!,
                                style: const TextStyle(
                                  color: AppConstants.textSecondaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                            if (imageUrls.isNotEmpty) ...[
                              const SizedBox(height: AppConstants.spacingMedium),
                              ImageCarousel(
                                imageUrls: imageUrls,
                                height: 300,
                                onImageTap: (index) {
                                  final originalFileNames = post.attachments
                                      .map((attachment) => attachment.originalFileName)
                                      .toList();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageViewer(
                                        imageUrls: imageUrls,
                                        originalFileNames: originalFileNames,
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                            const SizedBox(height: AppConstants.spacingMedium),
                            Row(
                              children: [
                                Text(
                                  DateFormatter.formatRelativeTime(post.createdAt),
                                  style: const TextStyle(
                                    color: AppConstants.textSecondaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: AppConstants.spacingSmall),
                                Text(
                                  post.nookName ?? post.nookId,
                                  style: const TextStyle(
                                    color: AppConstants.primaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  post.alias ?? AppConstants.anonymousText,
                                  style: const TextStyle(
                                    color: AppConstants.textSecondaryColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.spacingMedium),
                            Row(
                              children: [
                                ReactionButton(
                                  onReactionSelected: (unicode) {
                                    controller.reactToPost(unicode);
                                  },
                                ),
                                Expanded(
                                  child: ReactionDisplay(
                                    reactions: post.reactions,
                                    onReactionTap: (unicode) {
                                      controller.reactToPost(unicode);
                                    },
                                    postId: post.id,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: AppConstants.surfaceColor),
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.spacingMedium),
                        child: Text(
                          'Comments',
                          style: TextStyle(
                            color: AppConstants.textPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (controller.isLoadingComments.value)
                        const Padding(
                          padding: EdgeInsets.all(AppConstants.spacingMedium),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        )
                      else if (controller.comments.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(AppConstants.spacingMedium),
                          child: Center(
                            child: Text(
                              'No comments yet',
                              style: TextStyle(
                                color: AppConstants.textSecondaryColor,
                              ),
                            ),
                          ),
                        )
                        else
                        ...controller.comments.map((comment) {
                          return Obx(() => CommentItem(
                                comment: comment,
                                replies: controller.replies[comment.id],
                                onReply: (commentId) {
                                  CommentModel? targetComment;
                                  // First try to find in root comments
                                  try {
                                    targetComment = controller.comments.firstWhere(
                                      (c) => c.id == commentId,
                                    );
                                  } catch (e) {
                                    // If not found, search in replies
                                    for (final replyList in controller.replies.values) {
                                      try {
                                        targetComment = replyList.firstWhere(
                                          (c) => c.id == commentId,
                                        );
                                        break;
                                      } catch (e) {
                                        // Continue searching
                                      }
                                    }
                                  }
                                  if (targetComment != null) {
                                    _setReplyMode(commentId, targetComment.content);
                                  }
                                },
                                onLoadReplies: (commentId) async {
                                  await controller.loadCommentReplies(commentId);
                                },
                              ));
                        }),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              decoration: BoxDecoration(
                color: AppConstants.surfaceColor,
                border: Border(
                  top: BorderSide(
                    color: AppConstants.backgroundColor,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_replyingToCommentId != null)
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingSmall),
                      margin: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusSmall,
                        ),
                        border: Border.all(
                          color: AppConstants.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.reply,
                            size: 16,
                            color: AppConstants.primaryColor,
                          ),
                          const SizedBox(width: AppConstants.spacingSmall),
                          Expanded(
                            child: Text(
                              'Replying to: ${_replyingToCommentContent != null ? (_replyingToCommentContent!.length > 50 ? "${_replyingToCommentContent!.substring(0, 50)}..." : _replyingToCommentContent) : "comment"}',
                              style: TextStyle(
                                color: AppConstants.primaryColor,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: _cancelReplyMode,
                            icon: const Icon(
                              Icons.close,
                              size: 18,
                              color: AppConstants.textSecondaryColor,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          style: const TextStyle(
                            color: AppConstants.textPrimaryColor,
                          ),
                          decoration: InputDecoration(
                            hintText: _replyingToCommentId != null
                                ? 'Write a reply...'
                                : 'Write a comment...',
                            hintStyle: const TextStyle(
                              color: AppConstants.textSecondaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusSmall,
                              ),
                              borderSide: BorderSide(
                                color: AppConstants.primaryColor.withValues(alpha: 0.3),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusSmall,
                              ),
                              borderSide: const BorderSide(
                                color: AppConstants.primaryColor,
                              ),
                            ),
                            filled: true,
                            fillColor: AppConstants.backgroundColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingSmall),
                      IconButton(
                        onPressed: () {
                          if (commentController.text.trim().isNotEmpty) {
                            if (_replyingToCommentId != null) {
                              controller.replyToComment(
                                _replyingToCommentId!,
                                commentController.text.trim(),
                              );
                              _cancelReplyMode();
                            } else {
                              controller.createComment(commentController.text.trim());
                              commentController.clear();
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

}

