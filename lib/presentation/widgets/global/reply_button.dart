import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class ReplyButton extends StatelessWidget {
  final VoidCallback onTap;

  const ReplyButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("DEBUG UI: ReplyButton tapped");
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: CupidColors.greyColor.withValues(alpha: 0.2),
          ),
        ),
        child:  Row(
          mainAxisSize: MainAxisSize.min,
            children: [
            Text(
            'Reply',
            style: CupidTextStyles.body1.copyWith(color: CupidColors.greySecondary, fontSize: 13),
            ),
            const SizedBox(width: 6),
            Transform.rotate(
              angle: -45 * 3.14159 / 180,
              child: Icon(FluentIcons.send_16_filled,
              color: CupidColors.greySecondary,
              size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
