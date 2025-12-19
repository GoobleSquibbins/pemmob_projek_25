import 'package:flutter/material.dart';
import '../../data/models/post_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/config/api_config.dart';
import 'image_carousel.dart';
import 'image_viewer.dart';
import 'reaction_display.dart';
import 'reaction_button.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback onTap;
  final Function(String unicode)? onReactionTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrls = post.attachments
        .map((attachment) => ApiConfig.getImageUrl(attachment.content))
        .toList();

    return Card(
      color: AppConstants.surfaceColor,
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMedium,
        vertical: AppConstants.spacingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  color: AppConstants.textPrimaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (post.content != null && post.content!.isNotEmpty) ...[
                const SizedBox(height: AppConstants.spacingSmall),
                Text(
                  post.content!,
                  style: const TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: 14,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (imageUrls.isNotEmpty) ...[
                const SizedBox(height: AppConstants.spacingMedium),
                ImageCarousel(
                  imageUrls: imageUrls,
                  height: 200,
                  onImageTap: (index) {
                    // Navigate to full screen viewer
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
                  GestureDetector(
                    onTap: () {
                      // Navigate to nook detail
                    },
                    child: Text(
                      post.nookName ?? post.nookId,
                      style: const TextStyle(
                        color: AppConstants.primaryColor,
                        fontSize: 12,
                      ),
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
              const SizedBox(height: AppConstants.spacingSmall),
              Row(
                children: [
                  ReactionButton(
                    onReactionSelected: (unicode) {
                      onReactionTap?.call(unicode);
                    },
                  ),
                  Expanded(
                    child: ReactionDisplay(
                      reactions: post.reactions,
                      onReactionTap: onReactionTap,
                      postId: post.id,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

