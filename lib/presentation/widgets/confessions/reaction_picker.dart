import 'package:flutter/material.dart';
import 'package:flutter_chat_reactions/src/widgets/rections_row.dart';

class ReactionPicker extends StatelessWidget {
  final Function(String) onReactionSelected;
  final String? selectedReaction;

  const ReactionPicker({
    super.key,
    required this.onReactionSelected,
    this.selectedReaction,
  });

  @override
  Widget build(BuildContext context) {
    return ReactionsRow(
      reactions: const ['❤️', '😂', '🔥', '😢', '😡', '👍'],
      alignment: Alignment.centerLeft,
      onReactionTap: (reaction, index) {
        onReactionSelected(reaction);
      },
    );
  }
}
