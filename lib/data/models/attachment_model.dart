class AttachmentModel {
  final String type;
  final String format;
  final String content;
  final String? originalFileName;

  AttachmentModel({
    required this.type,
    required this.format,
    required this.content,
    this.originalFileName,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      type: json['type'] as String,
      format: json['format'] as String,
      content: json['content'] as String,
      originalFileName: json['original_file_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'format': format,
      'content': content,
      if (originalFileName != null) 'original_file_name': originalFileName,
    };
  }
}

