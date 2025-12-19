import 'package:get/get.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/api_repository.dart';
import '../../core/services/reaction_storage_service.dart';

class HomeController extends GetxController {
  final ApiRepository _repository = ApiRepository();

  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedPosts = await _repository.getAllPosts();
      posts.value = fetchedPosts;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load posts: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPosts() async {
    await fetchPosts();
  }

  Future<void> reactToPost(int postId, String unicode) async {
    try {
      // Check if user has already reacted with this emoji using local storage
      final hasReacted = await ReactionStorageService.hasPostReaction(postId, unicode);
      
      if (hasReacted) {
        // User already reacted with this emoji, remove the reaction
        final updatedPost = await _repository.reactToPost(
          postId: postId,
          unicode: unicode,
          action: -1,
        );

        final index = posts.indexWhere((p) => p.id == postId);
        if (index != -1) {
          posts[index] = updatedPost;
        }
        await ReactionStorageService.removePostReaction(postId, unicode);
      } else {
        // User hasn't reacted with this emoji yet, add the reaction
        final updatedPost = await _repository.reactToPost(
          postId: postId,
          unicode: unicode,
          action: 1,
        );

        final index = posts.indexWhere((p) => p.id == postId);
        if (index != -1) {
          posts[index] = updatedPost;
        }
        await ReactionStorageService.addPostReaction(postId, unicode);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to react: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

