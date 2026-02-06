import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';

class ReactionPicker extends StatelessWidget {
  final Function(String) onReactionSelected;
  final String? selectedReaction;

  const ReactionPicker({
    super.key,
    required this.onReactionSelected,
    this.selectedReaction,
  });

  final List<String> _reactions = const ['❤️', '😂', '🔥', '😢', '😡', '👍'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _reactions.map((reaction) {
            final isSelected = reaction == selectedReaction;
            return GestureDetector(
              onTap: () => onReactionSelected(reaction),
              child: Container(
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color:
                      isSelected ? CupidColors.primary.withValues(alpha: 0.7) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  reaction,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
