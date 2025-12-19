import '../models/nook_model.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/attachment_model.dart';
import '../services/api_service.dart';

class ApiRepository {
  final ApiService _apiService;

  ApiRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  // Nooks
  Future<List<NookModel>> getAllNooks() async {
    final response = await _apiService.get('/nooks');
    final data = response['data'] as List<dynamic>;
    return data
        .map((json) => NookModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<NookModel> getNookById(String id) async {
    final response = await _apiService.get('/nooks/$id');
    final data = response['data'] as Map<String, dynamic>;
    return NookModel.fromJson(data);
  }

  // Posts
  Future<List<PostModel>> getAllPosts() async {
    final response = await _apiService.get('/posts');
    final data = response['data'] as List<dynamic>;
    return data
        .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<PostModel> getPostById(int id) async {
    final response = await _apiService.get('/posts/$id');
    final data = response['data'] as Map<String, dynamic>;
    return PostModel.fromJson(data);
  }

  Future<List<PostModel>> getPostsByNookId(String nookId) async {
    final response = await _apiService.get('/posts/nook/$nookId');
    final data = response['data'] as List<dynamic>;
    return data
        .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<PostModel> createPost({
    required String title,
    String? content,
    required String nookId,
    List<Map<String, dynamic>>? attachments,
    String? alias,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'nook_id': nookId,
    };

    if (content != null && content.isNotEmpty) {
      body['content'] = content;
    }

    if (attachments != null && attachments.isNotEmpty) {
      body['attachment'] = attachments;
    }

    if (alias != null && alias.isNotEmpty) {
      body['alias'] = alias;
    }

    final response = await _apiService.post('/posts', body);
    final data = response['data'] as Map<String, dynamic>;
    return PostModel.fromJson(data);
  }

  Future<PostModel> reactToPost({
    required int postId,
    required String unicode,
    required int action,
  }) async {
    final body = {
      'post_id': postId,
      'unicode': unicode,
      'action': action,
    };

    final response = await _apiService.post('/posts/react', body);
    final data = response['data'] as Map<String, dynamic>;
    return PostModel.fromJson(data);
  }

  // Comments
  Future<List<CommentModel>> getRootComments(int postId) async {
    final response = await _apiService.get('/comments/post/$postId');
    final data = response['data'] as List<dynamic>;
    return data
        .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<CommentModel>> getCommentReplies(int commentId) async {
    final response = await _apiService.get('/comments/$commentId/replies');
    final data = response['data'] as List<dynamic>;
    return data
        .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<CommentModel> createRootComment({
    required int postId,
    required String content,
    List<AttachmentModel>? attachments,
  }) async {
    final body = {
      'post_id': postId,
      'content': content,
      'attachments': attachments?.map((a) => a.toJson()).toList() ?? [],
    };

    final response = await _apiService.post('/comments', body);
    final data = response['data'] as Map<String, dynamic>;
    return CommentModel.fromJson(data);
  }

  Future<CommentModel> replyToComment({
    required int postId,
    required String content,
    required int parentId,
  }) async {
    final body = {
      'post_id': postId,
      'content': content,
      'parent_id': parentId,
    };

    final response = await _apiService.post('/comments/reply', body);
    final data = response['data'] as Map<String, dynamic>;
    return CommentModel.fromJson(data);
  }

  Future<CommentModel> reactToComment({
    required int commentId,
    required String unicode,
    required int action,
  }) async {
    final body = {
      'comment_id': commentId,
      'unicode': unicode,
      'action': action,
    };

    final response = await _apiService.post('/comments/react', body);
    final data = response['data'] as Map<String, dynamic>;
    return CommentModel.fromJson(data);
  }
}

