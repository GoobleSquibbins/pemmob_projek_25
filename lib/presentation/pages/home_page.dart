import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/post_card.dart';
import '../../core/constants/app_constants.dart';
import '../../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Fesnuk',
          style: TextStyle(color: AppConstants.textPrimaryColor),
        ),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.posts.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppConstants.primaryColor,
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.posts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: AppConstants.textSecondaryColor),
                ),
                const SizedBox(height: AppConstants.spacingMedium),
                ElevatedButton(
                  onPressed: controller.fetchPosts,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.posts.isEmpty) {
          return const Center(
            child: Text(
              'No posts yet',
              style: TextStyle(color: AppConstants.textSecondaryColor),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshPosts,
          color: AppConstants.primaryColor,
          child: ListView.builder(
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              final postCard = PostCard(
                post: post,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.postDetail,
                    parameters: {'id': post.id.toString()},
                  );
                },
                onReactionTap: (unicode) {
                  controller.reactToPost(post.id, unicode);
                },
              );
              return postCard;
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.createPost);
        },
        backgroundColor: AppConstants.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

