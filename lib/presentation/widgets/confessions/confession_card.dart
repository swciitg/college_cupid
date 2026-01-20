import 'package:college_cupid/domain/models/confession.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/presentation/widgets/confessions/reaction_picker.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConfessionCard extends StatelessWidget {
  final Confession confession;
  final Function(String)? onReact;
  final VoidCallback? onReply;

  const ConfessionCard({
    super.key,
    required this.confession,
    this.onReact,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CupidColors.cupidBlue
                      .withOpacity(0.2), // Reuse existing color
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  confession.typeOfConfession.displayName,
                  style: CupidStyles.normalTextStyle.copyWith(
                    color: CupidColors.cupidBlue, // Reuse existing color
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                DateFormat('d MMM, yyyy').format(confession.createdAt),
                style: CupidStyles.lightTextStyle.copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            confession.text,
            style: CupidStyles.normalTextStyle.copyWith(
              fontSize: 16,
              height: 1.5,
              color: CupidColors.blackColor,
            ),
          ),
          if (confession.song.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: CupidColors.offWhiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(FluentIcons.music_note_2_24_filled,
                      size: 20, color: CupidColors.cupidGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      confession.song,
                      overflow: TextOverflow.ellipsis,
                      style: CupidStyles.normalTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: CupidColors.cupidGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              _ActionButton(
                icon: FluentIcons.add_24_regular,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: ReactionPicker(
                        onReactionSelected: (reaction) {
                          if (onReact != null) onReact!(reaction);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
              Row(
                children: [
                  if (confession.reactions.isNotEmpty) ...[
                    SizedBox(
                      height: 24,
                      width: 40 +
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
                      style: CupidStyles.normalTextStyle,
                    ),
                  ] else ...[
                    const Icon(FluentIcons.heart_24_regular, size: 24),
                    const SizedBox(width: 4),
                    const Text('Like'),
                  ]
                ],
              ),
              const Spacer(),
              if (confession.encryptedEmail == 'me') ...[
                _ActionButton(
                  icon: FluentIcons.delete_24_regular,
                  color: Colors.red.withOpacity(0.7),
                  onTap: () {}, // Delete logic if "By You"
                ),
                const SizedBox(width: 12),
              ],
              GestureDetector(
                onTap: onReply,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: CupidColors.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: CupidColors.greyColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Reply',
                        style: CupidStyles.normalTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(FluentIcons.send_24_regular, size: 18),
                    ],
                  ),
                ),
              ),
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

  const _ActionButton({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: CupidColors.greyColor.withOpacity(0.2),
          ),
        ),
        child: Icon(icon, size: 20, color: color ?? CupidColors.greyColor),
      ),
    );
  }
}
