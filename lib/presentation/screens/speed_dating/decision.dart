import 'package:flutter/material.dart';

class DecisionDialog extends StatelessWidget {
  final Function(bool) onDecision;

  const DecisionDialog({super.key, required this.onDecision});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Chat Time Over"),
      content: const Text(
          "Do you want to continue chatting with this person in a regular chat?"),
      actions: [
        TextButton(
          onPressed: () => onDecision(false),
          child: const Text("No"),
        ),
        ElevatedButton(
          onPressed: () => onDecision(true),
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
