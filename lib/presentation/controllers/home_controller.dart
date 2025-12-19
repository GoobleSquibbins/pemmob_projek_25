import 'package:get/get.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/api_repository.dart';

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
      final currentPost = posts.firstWhere((p) => p.id == postId);
      final currentCount = currentPost.reactions[unicode] ?? 0;
      final action = currentCount > 0 ? -1 : 1;

      final updatedPost = await _repository.reactToPost(
        postId: postId,
        unicode: unicode,
        action: action,
      );

      final index = posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        posts[index] = updatedPost;
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

