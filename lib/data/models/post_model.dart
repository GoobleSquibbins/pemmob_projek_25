import 'attachment_model.dart';

class PostModel {
  final int id;
  final String title;
  final String? content;
  final String nookId;
  final String? nookName;
  final List<AttachmentModel> attachments;
  final Map<String, int> reactions;
  final int? commentCount;
  final String createdAt;
  final String updatedAt;
  final String? alias;

  PostModel({
    required this.id,
    required this.title,
    this.content,
    required this.nookId,
    this.nookName,
    required this.attachments,
    required this.reactions,
    this.commentCount,
    required this.createdAt,
    required this.updatedAt,
    this.alias,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String?,
      nookId: json['nook_id'] as String,
      nookName: json['nook_name'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      reactions: (json['reactions'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      commentCount: json['comment_count'] as int?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      alias: json['alias'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (content != null) 'content': content,
      'nook_id': nookId,
      if (nookName != null) 'nook_name': nookName,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'reactions': reactions,
      if (commentCount != null) 'comment_count': commentCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (alias != null) 'alias': alias,
    };
  }
}

