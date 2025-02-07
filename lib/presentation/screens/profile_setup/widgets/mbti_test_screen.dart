import 'dart:developer';

import 'package:college_cupid/domain/models/mbti_model.dart';
import 'package:college_cupid/functions/snackbar.dart';
import 'package:college_cupid/presentation/controllers/mbti_controller.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_state.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/mbti_option_button.dart';
import 'package:college_cupid/repositories/user_profile_repository.dart';
import 'package:college_cupid/routing/app_router.dart';
import 'package:college_cupid/services/shared_prefs.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:college_cupid/stores/page_view_controller.dart';
import 'package:college_cupid/stores/user_controller.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MbtiTestScreen extends ConsumerStatefulWidget {
  const MbtiTestScreen({super.key});

  @override
  ConsumerState<MbtiTestScreen> createState() => _MbtiTestScreenState();

  static Map<String, HeartState> heartStates(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return {
      "yellow": HeartState(
        size: 200,
        left: -60,
        bottom: size.height * 0.25,
      ),
      "blue": HeartState(
        size: 200,
        right: 75,
        bottom: size.height * 0.09,
      ),
      "pink": HeartState(
        size: 180,
        right: -50,
        top: size.height * 0.25,
      ),
    };
  }
}

class _MbtiTestScreenState extends ConsumerState<MbtiTestScreen> {
  final _scrollController = FixedExtentScrollController();
  final _itemExtent = 160.0;
  var _navigationDisabled = false;
  var _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mbtiControllerProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _nextQuestion() async {
    if (_navigationDisabled || _loading) return;
    _navigationDisabled = true;
    _scrollController.animateTo(
      _scrollController.offset + _itemExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    await Future.delayed(const Duration(milliseconds: 300));
    _navigationDisabled = false;
  }

  void _previousQuestion() async {
    if (_navigationDisabled || _loading) return;
    _navigationDisabled = true;
    _scrollController.animateTo(
      _scrollController.offset - _itemExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    await Future.delayed(const Duration(milliseconds: 300));
    _navigationDisabled = false;
  }

  void _postMBTI() async {
    try {
      setState(() {
        _loading = true;
      });
      final personality =
          ref.read(mbtiControllerProvider.notifier).getPersonalityType();
      if (personality == null) {
        setState(() {
          _loading = false;
          _errorMessage = "Please answer all questions!";
        });
        return;
      }
      final profile = ref.read(userProvider).myProfile!;
      final userProfile = profile.copyWith(personalityType: personality);
      ref.read(userProvider.notifier).updateMyProfile(userProfile);
      await SharedPrefService.saveMyProfile(userProfile.toJson());
      ref.read(userProvider.notifier).updateMyProfile(userProfile);
      await ref.read(userProfileRepoProvider).updateUserProfile(userProfile);
      setState(() {
        _loading = false;
      });
      ref.read(pageViewProvider.notifier).getInitialProfiles();
      navigatorKey.currentState!.pop();
      showSnackBar("Updated personality type successfully");
    } catch (e) {
      log("Error updating personality type: $e");
      setState(() {
        _loading = false;
        _errorMessage = "Something went wrong. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: CupidColors.backgroundColor,
        floatingActionButton: _submitButton(),
        body: SizedBox(
          height: size.height * 0.8,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _progressIndicator(),
                const SizedBox(height: 8),
                const Text('MBTI Test', style: CupidStyles.headingStyle),
                const Text(
                  'Answer the following questions to determine your MBTI personality type',
                  style: CupidStyles.lightTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                _questionsScroll(),
                _navigationButtons(),
                _note(),
                _errorMessageWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _note() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: CupidColors.cupidPeach.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            const WidgetSpan(
              child: Icon(
                Icons.info_outline,
                size: 16,
                color: CupidColors.lightTextColor,
              ),
            ),
            const TextSpan(text: " "),
            TextSpan(
              text:
                  "Note :  This will only be used to display the best matching profiles for you. This information cannot be changed later and is not displayed on profiles.",
              style: CupidStyles.lightTextStyle.copyWith(fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorMessageWidget() {
    if (_errorMessage == null) return const SizedBox();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: CupidColors.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            const WidgetSpan(
              child: Icon(
                FluentIcons.error_circle_16_regular,
                size: 18,
                color: Colors.red,
              ),
            ),
            const TextSpan(text: " "),
            TextSpan(
              text: "Error : $_errorMessage",
              style: CupidStyles.lightTextStyle.copyWith(
                fontSize: 14,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Builder(
      builder: (context) {
        // final unanswered = ref
        //     .watch(mbtiControllerProvider)
        //     .questions
        //     .any((e) => e.answer != null);
        // if (unanswered) return const SizedBox();
        return FloatingActionButton(
          backgroundColor: CupidColors.cupidPeach,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          onPressed: () {
            _postMBTI();
          },
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(
                  Icons.check_rounded,
                  size: 30,
                  color: Colors.white,
                ),
        );
      },
    );
  }

  Row _navigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: CupidColors.cupidGreen.withValues(alpha: 0.25),
          ),
          child: IconButton(
            onPressed: () {
              _previousQuestion();
            },
            icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 32),
            color: CupidColors.cupidGreen,
          ),
        ),
        const SizedBox(width: 16),
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: CupidColors.cupidGreen.withValues(alpha: 0.25),
          ),
          child: IconButton(
            onPressed: () {
              _nextQuestion();
            },
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
            color: CupidColors.cupidGreen,
          ),
        )
      ],
    );
  }

  Expanded _questionsScroll() {
    return Expanded(
      child: Consumer(
        builder: (context, ref, child) {
          final mbtiModel = ref.watch(mbtiControllerProvider);
          return ListWheelScrollView(
            controller: _scrollController,
            physics: const NeverScrollableScrollPhysics(),
            itemExtent: _itemExtent,
            diameterRatio: 1.5,
            squeeze: 0.6,
            children: List.generate(
              mbtiModel.questions.length,
              (index) {
                final e = mbtiModel.questions[index];
                return _buildQuestion(e, ref, mbtiModel);
              },
            ),
          );
        },
      ),
    );
  }

  Consumer _progressIndicator() {
    return Consumer(
      builder: (context, ref, child) {
        final mbtiModel = ref.watch(mbtiControllerProvider);
        final answered =
            mbtiModel.questions.where((e) => e.answer != null).length;
        final progress = (answered / 20 * 100).toInt();
        return Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: answered / mbtiQuestions.length,
                backgroundColor: CupidColors.cupidPeach.withValues(alpha: 0.1),
                valueColor: const AlwaysStoppedAnimation(
                  CupidColors.cupidPeach,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '$progress%',
              style: CupidStyles.lightTextStyle.copyWith(
                color: CupidColors.cupidPeach,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestion(QuestionModel e, WidgetRef ref, MBTIModel mbtiModel) {
    final controller = ref.read(mbtiControllerProvider.notifier);
    final answered = e.answer != null;
    final highlighted = answered || mbtiModel.currentQuestion == e.id;
    return Opacity(
      opacity: highlighted ? 1 : 0.2,
      child: ClipRRect(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CupidColors.cupidGreen.withValues(alpha: 0.4),
                CupidColors.cupidGreen.withValues(alpha: 0.2),
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 1.5,
              color: CupidColors.cupidGreen.withValues(alpha: 0.8),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                e.question,
                style: CupidStyles.lightTextStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) {
                    return MBTIOptionButton(
                      index: index,
                      selected: e.answer == index,
                      onTap: () async {
                        if (_loading) return;
                        final lastAnswered = mbtiModel.questions
                                .where((e) => e.answer != null)
                                .lastOrNull
                                ?.id ??
                            0;
                        if (e.id > lastAnswered + 1) {
                          setState(() {
                            _errorMessage =
                                "Please answer the previous questions first!";
                          });
                          return;
                        }
                        if (_errorMessage != null) {
                          setState(() {
                            _errorMessage = null;
                          });
                        }
                        controller.answerQuestion(e.id, index);
                        await Future.delayed(
                          const Duration(milliseconds: 300),
                        );
                        _nextQuestion();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
