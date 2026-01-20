import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/profile/basic_profile_info.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_image.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:college_cupid/presentation/widgets/global/like_button.dart';
import 'package:college_cupid/presentation/widgets/global/reply_button.dart';
import 'package:college_cupid/presentation/widgets/confessions/reply_bottom_sheet.dart';

class DisplayProfileInfo extends ConsumerStatefulWidget {
  final UserProfile userProfile;
  final bool backButton;
  final VoidCallback? onPass;
  final VoidCallback? onSmash;
  final bool isMine;

  const DisplayProfileInfo(
      {required this.userProfile,
      this.backButton = false,
      this.isMine = false,
      this.onPass,
      this.onSmash,
      super.key});

  @override
  ConsumerState<DisplayProfileInfo> createState() => _DisplayProfileInfoState();
}

class _DisplayProfileInfoState extends ConsumerState<DisplayProfileInfo> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width - 32;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: LayoutBuilder(builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BasicProfileInfo(
                  maxHeight: maxHeight,
                  width: width,
                  userProfile: widget.userProfile,
                  backButton: widget.backButton,
                  isMine: widget.isMine,
                ),
                if (widget.userProfile.surpriseQuiz.isNotEmpty)
                  _surpriseQues(widget.userProfile.surpriseQuiz.first),
                if (widget.userProfile.surpriseQuiz.isEmpty)
                  const SizedBox(height: 16),
                _image(null, width, 1),
                const SizedBox(height: 8),
                if (widget.userProfile.interests.isNotEmpty) _buildInterests(),
                if (widget.userProfile.surpriseQuiz.length < 2)
                  const SizedBox(height: 16),
                if (widget.userProfile.surpriseQuiz.length >= 2)
                  _surpriseQues(widget.userProfile.surpriseQuiz[1]),
                if (widget.userProfile.images.length > 2)
                  _image(null, width, 2),
                if (widget.userProfile.surpriseQuiz.length >= 3)
                  _surpriseQues(widget.userProfile.surpriseQuiz[2]),
                const SizedBox(height: 24),
                // Smash or Pass Buttons
                if (!widget.backButton &&
                    !widget.isMine) // Only show on home screen
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: widget.onPass,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: CupidColors.offWhiteColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(FluentIcons.diamond_24_filled,
                                    color: Colors.black),
                                const SizedBox(width: 8),
                                Text(
                                  "Pass",
                                  style: CupidStyles.headingStyle.copyWith(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: widget.onSmash,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: CupidColors.offWhiteColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(FluentIcons.diamond_24_filled,
                                    color: Colors.black),
                                const SizedBox(width: 8),
                                Text(
                                  "Smash",
                                  style: CupidStyles.headingStyle.copyWith(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _surpriseQues(QuizQuestion ques) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ques.question,
                      style: CupidStyles.normalTextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ques.answer,
                      style: CupidStyles.normalTextStyle.setFontSize(16),
                    ),
                    const SizedBox(height: 8),
                    if (!widget.isMine)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ReplyButton(onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ReplyBottomSheet(
                                title: 'Reply to Answer',
                                onSend: (message) {
                                  // TODO: Implement reply logic for profile
                                },
                              ),
                            );
                          }),
                          const SizedBox(width: 8),
                          LikeButton(onTap: () {
                            // TODO: Implement like logic
                          }),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Loves",
              style: CupidStyles.normalTextStyle.setFontSize(16),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(
                _expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
              ),
            )
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(
              _expanded ? widget.userProfile.interests.length : 4, (index) {
            final extra = widget.userProfile.interests.length - 3;
            if (!_expanded && index == 3) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _expanded = true;
                  });
                },
                child: Text(
                  "+$extra more",
                  style: CupidStyles.normalTextStyle,
                ),
              );
            }
            return _interestChip(widget.userProfile.interests[index], index);
          }),
        ),
      ],
    );
  }

  DecoratedBox _interestChip(String label, int index) {
    final colors = {
      0: CupidColors.cupidPeach.withValues(alpha: 0.4),
      1: CupidColors.cupidBlue.withValues(alpha: 0.4),
      2: CupidColors.cupidYellow.withValues(alpha: 0.4),
    };
    final color = _expanded ? null : colors[index];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: color == null ? Border.all(color: Colors.black54) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        child: Text(
          label,
          style: CupidStyles.normalTextStyle,
        ),
      ),
    );
  }

  Widget _image(double? height, double width, int index) {
    final url = widget.userProfile.images[index].url;
    final blurHash = widget.userProfile.images[index].blurHash;
    return Stack(
      children: [
        ProfileImage(
          height: height,
          width: width,
          index: index,
          url: url,
          blurHash: blurHash,
        ),
        if (!widget.isMine)
          Positioned(
            bottom: 12,
            right: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ReplyButton(onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => ReplyBottomSheet(
                      title: 'Reply to Profile',
                      onSend: (message) {
                        // TODO: Implement reply logic for profile
                      },
                    ),
                  );
                }),
                const SizedBox(width: 8),
                LikeButton(onTap: () {
                  // TODO: Implement like logic
                }),
              ],
            ),
          ),
      ],
    );
  }
}
