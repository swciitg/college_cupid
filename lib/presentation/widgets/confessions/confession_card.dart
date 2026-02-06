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
      margin: const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CupidColors.greyColor.withValues(alpha: 0.2),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    confession.typeOfConfession.displayName,
                    style: CupidTextStyles.label3.copyWith(
                      color: CupidColors.greySecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 8,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CupidColors.greyColor.withValues(alpha: 0.2),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      DateFormat('d MMM, yyyy').format(confession.createdAt),
                      style: CupidTextStyles.label3.copyWith(fontSize: 12),
                    ),
                  ),
                  if (!isMine) ...[
                    IconButton(
                      icon: const Icon(Icons.report_problem, size: 20, color: CupidColors.red),
                      onPressed: () {
                        onReport!();
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            confession.text,
            style: CupidTextStyles.title1.copyWith(
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _ActionButton(
                borderRadius: 20,
                icon: FluentIcons.add_12_regular,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: ReactionPicker(
                        selectedReaction: myReaction,
                        onReactionSelected: (reaction) {
                          if (onReact != null) onReact!(reaction);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  if (confession.reactions.isNotEmpty) ...[
                    SizedBox(
                      height: 24,
                      width: 30 + (confession.reactions.length > 1 ? 10.0 : 0.0), // Dynamic width
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
                  icon: FluentIcons.delete_24_regular,
                  color: Colors.red,
                  onTap: () {
                    if (onDelete != null) onDelete!();
                  },
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
  final Color? color;
  final double borderRadius;

  const _ActionButton(
      {required this.icon, required this.onTap, this.color, this.borderRadius = 10});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          border: Border.all(
            color: CupidColors.greyColor.withValues(alpha: 0.2),
          ),
        ),
        child: Icon(icon, size: 14, color: color ?? CupidColors.greyColor),
      ),
    );
  }
}
