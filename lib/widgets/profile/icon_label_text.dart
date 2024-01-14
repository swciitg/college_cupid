import 'package:flutter/material.dart';

class IconLabelText extends StatelessWidget {
  final String text;
  final IconData icon;

  const IconLabelText({required this.text, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            textAlign: TextAlign.left,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
