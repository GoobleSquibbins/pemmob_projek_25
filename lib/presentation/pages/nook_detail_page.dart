import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nook_detail_controller.dart';
import '../widgets/post_card.dart';
import '../../core/constants/app_constants.dart';
import '../../routes/app_routes.dart';

class NookDetailPage extends StatelessWidget {
  const NookDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NookDetailController());

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Obx(() {
        if (controller.isLoadingNook.value && controller.nook.value == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppConstants.primaryColor,
            ),
          );
        }

        final nook = controller.nook.value;
        if (nook == null) {
          return const Center(
            child: Text(
              'Nook not found',
              style: TextStyle(color: AppConstants.textSecondaryColor),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              backgroundColor: AppConstants.backgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  nook.name,
                  style: const TextStyle(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.2),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.group,
                      size: 64,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                child: Text(
                  nook.description,
                  style: const TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Divider(
                color: AppConstants.surfaceColor,
                height: 1,
              ),
            ),
            if (controller.isLoading.value && controller.posts.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppConstants.primaryColor,
                  ),
                ),
              )
            else if (controller.posts.isEmpty)
              const SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No posts in this nook',
                    style: TextStyle(color: AppConstants.textSecondaryColor),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = controller.posts[index];
                      return PostCard(
                      post: post,
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.postDetail,
                          parameters: {'id': post.id.toString()},
                        );
                      },
                      onReactionTap: (unicode) {
                        // Reactions handled in post detail page
                      },
                    );
                  },
                  childCount: controller.posts.length,
                ),
              ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(
            AppRoutes.createPost,
            parameters: {'nookId': controller.nookId ?? ''},
          );
        },
        backgroundColor: AppConstants.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

