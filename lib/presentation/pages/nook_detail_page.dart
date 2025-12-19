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
              expandedHeight: 280,
              pinned: true,
              backgroundColor: AppConstants.backgroundColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                title: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppConstants.backgroundColor.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppConstants.primaryColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    nook.name,
                    style: const TextStyle(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppConstants.primaryColor.withValues(alpha: 0.3),
                        AppConstants.primaryColor.withValues(alpha: 0.1),
                        AppConstants.primaryColor.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppConstants.primaryColor.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -30,
                        left: -30,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppConstants.primaryColor.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      // Main icon container
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppConstants.primaryColor.withValues(alpha: 0.4),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppConstants.primaryColor.withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.group,
                            size: 72,
                            color: AppConstants.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(AppConstants.spacingMedium),
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                decoration: BoxDecoration(
                  color: AppConstants.surfaceColor,
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  border: Border.all(
                    color: AppConstants.primaryColor.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppConstants.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Expanded(
                      child: Text(
                        nook.description,
                        style: const TextStyle(
                          color: AppConstants.textSecondaryColor,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
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
                        Get.toNamed('/posts/${post.id}');
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

