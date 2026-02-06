import 'package:college_cupid/domain/models/confession.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/presentation/widgets/confessions/reaction_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:college_cupid/presentation/widgets/global/reply_button.dart';

class ConfessionCard extends StatelessWidget {
  final Confession confession;
  final Function(String)? onReact;
  final VoidCallback? onReply;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;
  final String? myReaction;
  final bool isMine;

  const ConfessionCard({
    super.key,
    required this.confession,
    this.onReact,
    this.onReply,
    this.onDelete,
    this.onReport,
    this.myReaction,
    this.isMine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupidColors.surfaceS0,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              chip(confession.typeOfConfession.displayName),
              chip(DateFormat('d MMM, yyyy').format(confession.createdAt))
            ],
          ),
          const SizedBox(height: 16),
          Text(
            confession.text,
            style: CupidTextStyles.title1.copyWith(
              color: CupidColors.greySecondary,
              fontSize: 25,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Builder(
                builder: (context) {
                  final GlobalKey buttonKey = GlobalKey();

                  return _ActionButton(
                    key: buttonKey,
                    icon: Icons.add,
                    onTap: () {
                      final RenderBox renderBox = buttonKey.currentContext!
                          .findRenderObject() as RenderBox;
                      final buttonPosition =
                          renderBox.localToGlobal(Offset.zero);
                      final buttonSize = renderBox.size;

                      showGeneralDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierLabel: 'Dismiss',
                        barrierColor: Colors.black45,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Stack(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => Navigator.pop(context),
                                child: const SizedBox.expand(),
                              ),
                              Positioned(
                                top: buttonPosition.dy -
                                    60, // Adjust offset as needed
                                left: buttonPosition.dx,
                                child: ScaleTransition(
                                  scale: CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.easeOutBack,
                                  ),
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: ReactionPicker(
                                        selectedReaction: myReaction,
                                        onReactionSelected: (reaction) {
                                          if (onReact != null)
                                            onReact!(reaction);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  if (confession.reactions.isNotEmpty) ...[
                    SizedBox(
                      height: 24,
                      width: 30 +
                          (confession.reactions.length > 1
                              ? 10.0
                              : 0.0), // Dynamic width
                      child: Stack(
                        children: [
                          if (confession.reactions.length > 1)
                            Positioned(
                              left: 16,
                              child: Text(
                                confession.reactions.last.reaction,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          Text(
                            confession.reactions.first.reaction,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${confession.reactions.length}',
                      style: CupidTextStyles.label2,
                    ),
                  ] else
                    ...[]
                ],
              ),
              const Spacer(),
              if (isMine) ...[
                _ActionButton(
                  icon: Icons.delete_outline,
                  color: CupidColors.red,
                  onTap: () {
                    if (onDelete != null) onDelete!();
                  },
                  shapeDecoration: BoxDecoration(
                      border: Border.all(
                          color: CupidColors.borderSecondary, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(width: 12),
              ],
              ReplyButton(onTap: () {
                if (onReply != null) onReply!();
              }),
            ],
          )
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final BoxDecoration? shapeDecoration;
  final Color? color;

  const _ActionButton(
      {super.key,
      required this.icon,
      required this.onTap,
      this.color,
      this.shapeDecoration});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: shapeDecoration ??
            BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: CupidColors.borderSecondary,
              ),
            ),
        child: Center(
            child: Icon(icon, size: 18, color: color ?? CupidColors.grey700)),
      ),
    );
  }
}

Widget chip(String label) {
  return Container(
    height: 24,
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: CupidColors.borderSecondary),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    child: Center(
      child: Text(label,
          style: CupidTextStyles.label3
              .copyWith(color: CupidColors.greySecondary)),
    ),
  );
}
