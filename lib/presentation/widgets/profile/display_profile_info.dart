import 'dart:developer';

import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/widgets/profile/basic_profile_info.dart';
import 'package:college_cupid/presentation/widgets/profile/logout_button.dart';
import 'package:college_cupid/presentation/widgets/profile/storage_status_card.dart';
import 'package:college_cupid/presentation/widgets/profile/profile_image.dart';
import 'package:college_cupid/presentation/widgets/profile/voice_player.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:college_cupid/presentation/widgets/global/reply_button.dart';
import 'package:college_cupid/presentation/widgets/confessions/reply_bottom_sheet.dart';
import 'package:college_cupid/repositories/updates_repository.dart';
import 'package:college_cupid/functions/snackbar.dart';

class DisplayProfileInfo extends ConsumerStatefulWidget {
  final UserProfile userProfile;
  final bool backButton;
  final VoidCallback? onPass;
  final VoidCallback? onSmash;
  final bool isMine;
  final bool showPass;

  const DisplayProfileInfo(
      {required this.userProfile,
      this.backButton = false,
      this.isMine = false,
      this.showPass = true,
      this.onPass,
      this.onSmash,
      super.key});

  @override
  ConsumerState<DisplayProfileInfo> createState() => _DisplayProfileInfoState();
}

class _DisplayProfileInfoState extends ConsumerState<DisplayProfileInfo> {
  var _expanded = false;

  // Merge surpriseQuiz and voiceRecordings to get all answered questions
  List<QuizQuestion> _getAllQuestions() {
    final Map<String, QuizQuestion> questionsMap = {};

    // Add all text quiz answers
    for (var quiz in widget.userProfile.surpriseQuiz) {
      questionsMap[quiz.question] = quiz;
    }

    // Add voice recordings - either merge with existing or add new
    for (var voice in widget.userProfile.voiceRecordings) {
      if (voice.question.isNotEmpty && voice.answer.isNotEmpty) {
        if (questionsMap.containsKey(voice.question)) {
          // Merge: add audioPath to existing question
          questionsMap[voice.question] = questionsMap[voice.question]!.copyWith(
            audioPath: voice.answer,
          );
        } else {
          // Add new question with only audio answer
          questionsMap[voice.question] = QuizQuestion(
            question: voice.question,
            answer: '',
            audioPath: voice.answer,
          );
        }
      }
    }

    return questionsMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width - 16;
    final allQuestions = _getAllQuestions();

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: LayoutBuilder(builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
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
                if (allQuestions.isNotEmpty) _surpriseQues(allQuestions[0], 0),
                if (allQuestions.isEmpty) const SizedBox(height: 16),
                _image(null, width, 1),
                const SizedBox(height: 8),
                if (widget.userProfile.interests.isNotEmpty) _buildInterests(),
                if (allQuestions.length < 2) const SizedBox(height: 16),
                if (allQuestions.length >= 2) _surpriseQues(allQuestions[1], 1),
                if (widget.userProfile.images.length > 2) _image(null, width, 2),
                if (allQuestions.length >= 3) _surpriseQues(allQuestions[2], 2),
                const SizedBox(height: 24),
                if (!widget.isMine) // Only show if not my profile
                  Row(
                    children: [
                      if (widget.showPass) ...[
                        Expanded(
                          child: GestureDetector(
                            onTap: widget.onPass,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: CupidColors.offWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(FluentIcons.diamond_24_filled, color: Colors.black),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Pass",
                                    style: CupidTextStyles.label1.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        child: GestureDetector(
                          onTap: widget.onSmash,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: CupidColors.offWhiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(FluentIcons.heart_24_filled, color: Colors.black),
                                const SizedBox(width: 8),
                                Text(
                                  "Like",
                                  style: CupidTextStyles.label1.copyWith(
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
                if (widget.isMine) const StorageStatusCard(),
                if (widget.isMine) const LogoutButton(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _surpriseQues(QuizQuestion ques, int index) {
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupidColors.greyElement),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ques.question,
                        style: CupidTextStyles.label3.copyWith(
                          fontWeight: FontWeight.w600,
                          color: CupidColors.greySecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildAnswer(ques),
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
                                onSend: (message) async {
                                  final success = await ref.read(updatesRepoProvider).replyToUser(
                                      widget.userProfile.email, message, "QUESTIONS", index);
                                  if (success) {
                                    showSnackBar("Reply sent successfully!");
                                  } else {
                                    showSnackBar("Failed to send reply");
                                  }
                                },
                              ),
                            );
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

  Widget _buildAnswer(QuizQuestion ques) {
    // Check if there's audio in the question itself (merged data)
    if (ques.audioPath != null && ques.audioPath!.isNotEmpty) {
      return VoicePlayer(audioUrl: ques.audioPath!);
    }

    // Check if there's a voice recording for this question (fallback)
    final voiceRecording = widget.userProfile.voiceRecordings.firstWhere(
      (recording) => recording.question == ques.question,
      orElse: () => VoiceRecording(question: '', answer: ''),
    );

    // If there's a voice recording, show audio player
    if (voiceRecording.answer.isNotEmpty) {
      return VoicePlayer(audioUrl: voiceRecording.answer);
    }

    // Otherwise show text answer
    return Text(
      ques.answer,
      style: CupidTextStyles.label1.copyWith(
        color: CupidColors.greySecondary,
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
              style: CupidTextStyles.title2.copyWith(fontSize: 16),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(
                _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              ),
            )
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: List.generate(_expanded ? widget.userProfile.interests.length : 4, (index) {
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
                  style: CupidTextStyles.body1,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          label,
          style: CupidTextStyles.label2
              .copyWith(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
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
                      onSend: (message) async {
                        log("DEBUG UI: Reply button pressed for IMAGES index $index");
                        log("DEBUG UI: Sending to ${widget.userProfile.email}");
                        try {
                          final success = await ref
                              .read(updatesRepoProvider)
                              .replyToUser(widget.userProfile.email, message, "IMAGES", index);
                          log("DEBUG UI: Result success=$success");
                          if (success) {
                            showSnackBar("Reply sent successfully!");
                          } else {
                            showSnackBar("Failed to send reply");
                          }
                        } catch (e) {
                          log("DEBUG UI: Error calling repo: $e");
                        }
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }
}
