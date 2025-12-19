import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service to track user reactions locally using SharedPreferences.
/// Stores reactions per post/comment to prevent duplicate reactions of the same emoji.
class ReactionStorageService {
  static const String _postReactionsKey = 'post_reactions';
  static const String _commentReactionsKey = 'comment_reactions';

  /// Checks if a post has already been reacted to with a specific emoji (unicode).
  /// Returns true if the user has already reacted with this emoji.
  static Future<bool> hasPostReaction(int postId, String unicode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reactionsJson = prefs.getString(_postReactionsKey);
      
      if (reactionsJson == null) return false;
      
      final reactions = jsonDecode(reactionsJson) as Map<String, dynamic>;
      final postKey = postId.toString();
      
      if (!reactions.containsKey(postKey)) return false;
      
      final postReactions = reactions[postKey] as List<dynamic>;
      return postReactions.contains(unicode);
    } catch (e) {
      return false;
    }
  }

  /// Checks if a comment has already been reacted to with a specific emoji (unicode).
  /// Returns true if the user has already reacted with this emoji.
  static Future<bool> hasCommentReaction(int commentId, String unicode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reactionsJson = prefs.getString(_commentReactionsKey);
      
      if (reactionsJson == null) return false;
      
      final reactions = jsonDecode(reactionsJson) as Map<String, dynamic>;
      final commentKey = commentId.toString();
      
      if (!reactions.containsKey(commentKey)) return false;
      
      final commentReactions = reactions[commentKey] as List<dynamic>;
      return commentReactions.contains(unicode);
    } catch (e) {
      return false;
    }
  }

  /// Adds a reaction to a post. Returns true if successful.
  static Future<bool> addPostReaction(int postId, String unicode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reactionsJson = prefs.getString(_postReactionsKey);
      
      Map<String, dynamic> reactions;
      if (reactionsJson == null) {
        reactions = {};
      } else {
        reactions = jsonDecode(reactionsJson) as Map<String, dynamic>;
      }
      
      final postKey = postId.toString();
      List<dynamic> postReactions;
      
      if (reactions.containsKey(postKey)) {
        postReactions = List<dynamic>.from(reactions[postKey] as List<dynamic>);
      } else {
        postReactions = [];
      }
      
      // Only add if not already present
      if (!postReactions.contains(unicode)) {
        postReactions.add(unicode);
        reactions[postKey] = postReactions;
        await prefs.setString(_postReactionsKey, jsonEncode(reactions));
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Adds a reaction to a comment. Returns true if successful.
  static Future<bool> addCommentReaction(int commentId, String unicode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reactionsJson = prefs.getString(_commentReactionsKey);
      
      Map<String, dynamic> reactions;
      if (reactionsJson == null) {
        reactions = {};
      } else {
        reactions = jsonDecode(reactionsJson) as Map<String, dynamic>;
      }
      
      final commentKey = commentId.toString();
      List<dynamic> commentReactions;
      
      if (reactions.containsKey(commentKey)) {
        commentReactions = List<dynamic>.from(reactions[commentKey] as List<dynamic>);
      } else {
        commentReactions = [];
      }
      
      // Only add if not already present
      if (!commentReactions.contains(unicode)) {
        commentReactions.add(unicode);
        reactions[commentKey] = commentReactions;
        await prefs.setString(_commentReactionsKey, jsonEncode(reactions));
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Removes a reaction from a post. Returns true if successful.
  static Future<bool> removePostReaction(int postId, String unicode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reactionsJson = prefs.getString(_postReactionsKey);
      
      if (reactionsJson == null) return true;
      
      final reactions = jsonDecode(reactionsJson) as Map<String, dynamic>;
      final postKey = postId.toString();
      
      if (!reactions.containsKey(postKey)) return true;
      
      final postReactions = List<dynamic>.from(reactions[postKey] as List<dynamic>);
      postReactions.remove(unicode);
      
      if (postReactions.isEmpty) {
        reactions.remove(postKey);
      } else {
        reactions[postKey] = postReactions;
      }
      
      await prefs.setString(_postReactionsKey, jsonEncode(reactions));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Removes a reaction from a comment. Returns true if successful.
  static Future<bool> removeCommentReaction(int commentId, String unicode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reactionsJson = prefs.getString(_commentReactionsKey);
      
      if (reactionsJson == null) return true;
      
      final reactions = jsonDecode(reactionsJson) as Map<String, dynamic>;
      final commentKey = commentId.toString();
      
      if (!reactions.containsKey(commentKey)) return true;
      
      final commentReactions = List<dynamic>.from(reactions[commentKey] as List<dynamic>);
      commentReactions.remove(unicode);
      
      if (commentReactions.isEmpty) {
        reactions.remove(commentKey);
      } else {
        reactions[commentKey] = commentReactions;
      }
      
      await prefs.setString(_commentReactionsKey, jsonEncode(reactions));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets all reactions for a post. Returns list of unicode strings.
  static Future<List<String>> getPostReactions(int postId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reactionsJson = prefs.getString(_postReactionsKey);
      
      if (reactionsJson == null) return [];
      
      final reactions = jsonDecode(reactionsJson) as Map<String, dynamic>;
      final postKey = postId.toString();
      
      if (!reactions.containsKey(postKey)) return [];
      
      final postReactions = reactions[postKey] as List<dynamic>;
      return postReactions.map((e) => e.toString()).toList();
    } catch (e) {
      return [];
    }
  }

  /// Gets all reactions for a comment. Returns list of unicode strings.
  static Future<List<String>> getCommentReactions(int commentId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reactionsJson = prefs.getString(_commentReactionsKey);
      
      if (reactionsJson == null) return [];
      
      final reactions = jsonDecode(reactionsJson) as Map<String, dynamic>;
      final commentKey = commentId.toString();
      
      if (!reactions.containsKey(commentKey)) return [];
      
      final commentReactions = reactions[commentKey] as List<dynamic>;
      return commentReactions.map((e) => e.toString()).toList();
    } catch (e) {
      return [];
    }
  }
}

