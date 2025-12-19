class EmojiHelper {
  /// Converts unicode string (e.g., "U+1F602") to emoji character.
  /// Returns empty string if conversion fails.
  static String unicodeToEmoji(String unicode) {
    try {
      // Remove "U+" prefix if present
      final codeString = unicode.replaceAll('U+', '');
      
      // Parse hex string to int
      final codePoint = int.parse(codeString, radix: 16);
      
      // Convert to emoji character
      return String.fromCharCode(codePoint);
    } catch (e) {
      return '';
    }
  }

  /// Converts emoji character to unicode string format (e.g., "U+1F602")
  static String emojiToUnicode(String emoji) {
    if (emoji.isEmpty) return '';
    
    final codePoint = emoji.codeUnitAt(0);
    return 'U+${codePoint.toRadixString(16).toUpperCase().padLeft(4, '0')}';
  }

  /// Formats reaction map for display
  /// Only includes reactions with count > 0
  static Map<String, int> filterReactions(Map<String, int> reactions) {
    return Map.fromEntries(
      reactions.entries.where((entry) => entry.value > 0),
    );
  }
}

