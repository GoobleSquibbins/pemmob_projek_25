class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Title is required';
    }
    return null;
  }

  static String? validatePostCreation({
    String? title,
    String? content,
    List<dynamic>? attachments,
  }) {
    final titleError = validateTitle(title);
    if (titleError != null && (attachments == null || attachments.isEmpty)) {
      return 'Either title or images are required';
    }
    return null;
  }

  static bool canSubmitPost({
    String? title,
    List<dynamic>? attachments,
  }) {
    final hasTitle = title != null && title.trim().isNotEmpty;
    final hasAttachments = attachments != null && attachments.isNotEmpty;
    return hasTitle || hasAttachments;
  }
}

