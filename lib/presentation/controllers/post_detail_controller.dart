import 'package:get/get.dart';
import '../../data/models/post_model.dart';
import '../../data/models/comment_model.dart';
import '../../data/repositories/api_repository.dart';
import '../../core/services/reaction_storage_service.dart';

class PostDetailController extends GetxController {
  final ApiRepository _repository = ApiRepository();

  final Rx<PostModel?> post = Rx<PostModel?>(null);
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final RxMap<int, List<CommentModel>> replies = <int, List<CommentModel>>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingComments = false.obs;
  final RxString errorMessage = ''.obs;

  int? postId;

  @override
  void onInit() {
    super.onInit();
    postId = Get.parameters['id'] != null
        ? int.tryParse(Get.parameters['id']!)
        : null;
    if (postId != null) {
      fetchPostDetail();
      fetchComments();
    }
  }

  Future<void> fetchPostDetail() async {
    if (postId == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedPost = await _repository.getPostById(postId!);
      post.value = fetchedPost;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load post: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchComments() async {
    if (postId == null) return;

    try {
      isLoadingComments.value = true;
      errorMessage.value = '';
      final fetchedComments = await _repository.getRootComments(postId!);
      comments.value = fetchedComments;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load comments: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingComments.value = false;
    }
  }

  Future<void> loadCommentReplies(int commentId) async {
    if (replies.containsKey(commentId)) {
      return;
    }
    
    try {
      final fetchedReplies = await _repository.getCommentReplies(commentId);
      replies[commentId] = fetchedReplies;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load replies: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> createComment(String content) async {
    if (postId == null) return;

    try {
      final newComment = await _repository.createRootComment(
        postId: postId!,
        content: content,
      );
      comments.add(newComment);
      Get.snackbar(
        'Success',
        'Comment created',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create comment: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> replyToComment(int parentId, String content) async {
    if (postId == null) return;

    try {
      final newReply = await _repository.replyToComment(
        postId: postId!,
        content: content,
        parentId: parentId,
      );
      if (replies.containsKey(parentId)) {
        replies[parentId]!.add(newReply);
      } else {
        replies[parentId] = [newReply];
      }
      final parentIndex = comments.indexWhere((c) => c.id == parentId);
      if (parentIndex != -1) {
        final updatedComment = comments[parentIndex];
        comments[parentIndex] = CommentModel(
          id: updatedComment.id,
          content: updatedComment.content,
          postId: updatedComment.postId,
          parentId: updatedComment.parentId,
          attachments: updatedComment.attachments,
          reactions: updatedComment.reactions,
          replyCount: updatedComment.replyCount + 1,
          path: updatedComment.path,
          createdAt: updatedComment.createdAt,
          updatedAt: updatedComment.updatedAt,
          alias: updatedComment.alias,
        );
      }
      Get.snackbar(
        'Success',
        'Reply created',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create reply: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> reactToPost(String unicode) async {
    if (postId == null) return;

    try {
      final currentPost = post.value;
      if (currentPost == null) return;

      // Check if user has already reacted with this emoji using local storage
      final hasReacted = await ReactionStorageService.hasPostReaction(postId!, unicode);
      
      if (hasReacted) {
        // User already reacted with this emoji, remove the reaction
        final updatedPost = await _repository.reactToPost(
          postId: postId!,
          unicode: unicode,
          action: -1,
        );
        post.value = updatedPost;
        await ReactionStorageService.removePostReaction(postId!, unicode);
      } else {
        // User hasn't reacted with this emoji yet, add the reaction
        final updatedPost = await _repository.reactToPost(
          postId: postId!,
          unicode: unicode,
          action: 1,
        );
        post.value = updatedPost;
        await ReactionStorageService.addPostReaction(postId!, unicode);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to react: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }


  Future<void> refreshComments() async {
    await fetchComments();
  }
}

