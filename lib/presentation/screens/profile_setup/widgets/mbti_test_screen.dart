import 'dart:io';

import 'package:college_cupid/domain/models/mbti_model.dart';
import 'package:college_cupid/presentation/controllers/mbti_controller.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/heart_state.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/mbti_option_button.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/styles.dart';
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
    if (_navigationDisabled) return;
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
    if (_navigationDisabled) return;
    _navigationDisabled = true;
    _scrollController.animateTo(
      _scrollController.offset - _itemExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    await Future.delayed(const Duration(milliseconds: 300));
    _navigationDisabled = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height * 0.8,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(
              height: Platform.isIOS ? kToolbarHeight : kToolbarHeight / 2,
            ),
            Consumer(
              builder: (context, ref, child) {
                final mbtiModel = ref.watch(mbtiControllerProvider);
                final answered = mbtiModel.questions.where((e) => e.answer != null).length;
                final progress = (answered / 20 * 100).toInt();
                return Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: mbtiModel.currentQuestion / 20,
                        backgroundColor: CupidColors.secondaryColor.withValues(alpha: 0.1),
                        valueColor: const AlwaysStoppedAnimation(
                          CupidColors.secondaryColor,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '$progress%',
                      style: CupidStyles.lightTextStyle.copyWith(
                        color: CupidColors.secondaryColor,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            const Text('MBTI Test', style: CupidStyles.headingStyle),
            const Text(
              'Answer the following questions to determine your MBTI personality type',
              style: CupidStyles.lightTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Expanded(
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
                        final answered = e.answer != null;
                        final hightlighted = answered || mbtiModel.currentQuestion == e.id;
                        return _buildQuestion(e, ref, hightlighted);
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CupidColors.secondaryColor.withValues(alpha: 0.16),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _previousQuestion();
                    },
                    icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 32),
                    color: CupidColors.secondaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CupidColors.secondaryColor.withValues(alpha: 0.16),
                  ),
                  child: IconButton(
                    onPressed: () {
                      _nextQuestion();
                    },
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
                    color: CupidColors.secondaryColor,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion(QuestionModel e, WidgetRef ref, bool highlighted) {
    final controller = ref.read(mbtiControllerProvider.notifier);
    return Opacity(
      opacity: highlighted ? 1 : 0.2,
      child: ClipRRect(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pinkAccent.withValues(alpha: 0.02),
                Colors.pinkAccent.withValues(alpha: 0.1),
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 1.5,
              color: Colors.pinkAccent.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                e.question,
                style: CupidStyles.lightTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
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
