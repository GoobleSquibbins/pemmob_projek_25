import 'attachment_model.dart';

class CommentModel {
  final int id;
  final String content;
  final int postId;
  final int? parentId;
  final List<AttachmentModel> attachments;
  final Map<String, int> reactions;
  final int replyCount;
  final String? path;
  final String createdAt;
  final String updatedAt;
  final String? alias;

  CommentModel({
    required this.id,
    required this.content,
    required this.postId,
    this.parentId,
    required this.attachments,
    required this.reactions,
    required this.replyCount,
    this.path,
    required this.createdAt,
    required this.updatedAt,
    this.alias,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      content: json['content'] as String,
      postId: json['post_id'] as int,
      parentId: json['parent_id'] as int?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reactions: (json['reactions'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      replyCount: json['reply_count'] as int? ?? 0,
      path: json['path'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      alias: json['alias'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'post_id': postId,
      if (parentId != null) 'parent_id': parentId,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'reactions': reactions,
      'reply_count': replyCount,
      if (path != null) 'path': path,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (alias != null) 'alias': alias,
    };
  }
}

