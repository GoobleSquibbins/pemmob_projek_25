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

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PostDetailController());
    final commentController = TextEditingController();

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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageViewer(
                                        imageUrls: imageUrls,
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
                                  _showReplyDialog(
                                    context,
                                    controller,
                                    commentId,
                                  );
                                },
                                onReactionTap: (commentId, unicode) {
                                  controller.reactToComment(commentId, unicode);
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
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      style: const TextStyle(
                        color: AppConstants.textPrimaryColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
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
                        controller.createComment(commentController.text.trim());
                        commentController.clear();
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showReplyDialog(
    BuildContext context,
    PostDetailController controller,
    int parentId,
  ) {
    final replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppConstants.surfaceColor,
        title: const Text(
          'Reply',
          style: TextStyle(color: AppConstants.textPrimaryColor),
        ),
        content: TextField(
          controller: replyController,
          style: const TextStyle(color: AppConstants.textPrimaryColor),
          decoration: InputDecoration(
            hintText: 'Write a reply...',
            hintStyle: const TextStyle(
              color: AppConstants.textSecondaryColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusSmall,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusSmall,
              ),
              borderSide: const BorderSide(color: AppConstants.primaryColor),
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppConstants.textSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              if (replyController.text.trim().isNotEmpty) {
                controller.replyToComment(
                  parentId,
                  replyController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Reply',
              style: TextStyle(color: AppConstants.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

