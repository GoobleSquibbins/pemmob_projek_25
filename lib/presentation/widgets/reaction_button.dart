import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import 'emoji_picker_widget.dart';

class ReactionButton extends StatelessWidget {
  final Function(String unicode) onReactionSelected;

  const ReactionButton({
    super.key,
    required this.onReactionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add_reaction_outlined),
      color: AppConstants.primaryColor,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: AppConstants.backgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.borderRadiusMedium),
            ),
          ),
          builder: (context) => EmojiPickerWidget(
            onEmojiSelected: (unicode) {
              Navigator.pop(context);
              onReactionSelected(unicode);
            },
          ),
        );
      },
    );
  }
}

