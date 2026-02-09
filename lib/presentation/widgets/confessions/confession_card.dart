import 'package:college_cupid/domain/models/confession.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/presentation/widgets/confessions/reaction_picker.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:college_cupid/presentation/widgets/global/reply_button.dart';

class ConfessionCard extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final myProfile = ref.watch(userProvider).myProfile;
    final isAdmin = myProfile?.isAdmin ?? false;
    final canDelete = isMine || isAdmin;

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      icon: const Icon(Icons.report_problem,
                          size: 20, color: CupidColors.red),
                      onPressed: () {
                        onReport!();
                      },
                    ),
                  ],
                ],
              ),
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
              Builder(builder: (context) {
                return _ActionButton(
                  borderRadius: 20,
                  icon: FluentIcons.add_12_regular,
                  onTap: () {
                    final renderBox = context.findRenderObject() as RenderBox;
                    final position = renderBox.localToGlobal(Offset.zero);
                    final size = renderBox.size;
                    _showReactionOverlay(context, position, size);
                  },
                );
              }),
              const SizedBox(width: 8),
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
              if (canDelete) ...[
                _ActionButton(
                  icon: FluentIcons.delete_24_regular,
                  color: Colors.red,
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

  void _showReactionOverlay(BuildContext context, Offset position, Size size) {
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => overlayEntry.remove(),
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),
          Positioned(
            left: position.dx + size.width + 12, // Position to the right
            top: position.dy - 10, // Center vertically roughly
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                child: ReactionPicker(
                  selectedReaction: myReaction,
                  onReactionSelected: (reaction) {
                    if (onReact != null) onReact!(reaction);
                    overlayEntry.remove();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(overlayEntry);
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final BoxDecoration? shapeDecoration;
  final Color? color;
  final double borderRadius;

  const _ActionButton(
      {required this.icon,
      required this.onTap,
      this.color,
      this.borderRadius = 10,
      this.shapeDecoration});

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
