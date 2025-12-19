import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import '../../core/utils/emoji_helper.dart';
import '../../core/constants/app_constants.dart';

class EmojiPickerWidget extends StatelessWidget {
  final Function(String unicode) onEmojiSelected;

  const EmojiPickerWidget({
    super.key,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          final unicode = EmojiHelper.emojiToUnicode(emoji.emoji);
          if (unicode.isNotEmpty) {
            onEmojiSelected(unicode);
          }
        },
        config: Config(
          height: 300,
          checkPlatformCompatibility: true,
          emojiViewConfig: EmojiViewConfig(
            backgroundColor: AppConstants.backgroundColor,
            emojiSizeMax: 28,
          ),
          skinToneConfig: const SkinToneConfig(),
          categoryViewConfig: CategoryViewConfig(
            backgroundColor: AppConstants.surfaceColor,
            iconColorSelected: AppConstants.primaryColor,
          ),
          bottomActionBarConfig: BottomActionBarConfig(
            backgroundColor: AppConstants.surfaceColor,
          ),
        ),
      ),
    );
  }
}

