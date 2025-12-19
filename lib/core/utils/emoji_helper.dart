class EmojiHelper {
  /// Converts unicode string (e.g., "U+1F602") to emoji character.
  /// Returns empty string if conversion fails.
  /// Handles emojis with code points above U+FFFF (surrogate pairs).
  static String unicodeToEmoji(String unicode) {
    try {
      // Remove "U+" prefix if present
      final codeString = unicode.replaceAll('U+', '').trim();
      if (codeString.isEmpty) return '';
      
      // Parse hex string to int
      final codePoint = int.parse(codeString, radix: 16);
      
      // Convert to emoji character using runes to handle surrogate pairs
      return String.fromCharCodes([codePoint]);
    } catch (e) {
      return '';
    }
  }

  /// Converts emoji character to unicode string format (e.g., "U+1F602")
  /// Handles emojis with code points above U+FFFF (surrogate pairs).
  static String emojiToUnicode(String emoji) {
    if (emoji.isEmpty) return '';
    
    // Use runes to get the actual Unicode code points, not UTF-16 code units
    // This handles emojis above U+FFFF correctly
    final runes = emoji.runes;
    if (runes.isEmpty) return '';
    
    // Get the first code point (most emojis are single code points)
    final codePoint = runes.first;
    // Convert to hex and pad to at least 4 digits (emojis above U+FFFF need 5+ digits)
    final hexString = codePoint.toRadixString(16).toUpperCase();
    // Pad to minimum 4 digits, but preserve longer hex strings for emojis above U+FFFF
    return 'U+${hexString.length < 4 ? hexString.padLeft(4, '0') : hexString}';
  }

  /// Formats reaction map for display
  /// Only includes reactions with count > 0
  static Map<String, int> filterReactions(Map<String, int> reactions) {
    return Map.fromEntries(
      reactions.entries.where((entry) => entry.value > 0),
    );
  }
}

