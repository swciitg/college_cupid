import 'dart:math' as math;
import 'package:college_cupid/domain/models/user_profile.dart';
import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/heart_state.dart';

class SurpriseQuiz extends ConsumerStatefulWidget {
  const SurpriseQuiz({super.key});

  @override
  ConsumerState<SurpriseQuiz> createState() => _SurpriseQuizState();

  static Map<String, HeartState> heartStates(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return {
      "yellow": HeartState(
        size: 500,
        left: 0,
        bottom: -size.height * .15,
      ),
      "blue": HeartState(
        size: 200,
        right: size.width * 0.27,
        top: size.height * 0.07,
      ),
      "pink": HeartState(
        size: 125,
        right: 0,
        bottom: size.height * 0.07,
      ),
    };
  }
}

class _SurpriseQuizState extends ConsumerState<SurpriseQuiz> {
  var _currentIndex = 0;
  late PageController _pageController;
  List<TextEditingController> textEditingControllers = [];

  /// Length = 3
  List<int> randomQuestions = [0, 0, 0];

  @override
  void initState() {
    _pageController = PageController();
    textEditingControllers.addAll([
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ]);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _swapSwapQuestion(0);
      _swapSwapQuestion(1);
      _swapSwapQuestion(2);
      ref.read(onboardingControllerProvider.notifier).setSurpriseQuiz([
        quizQuestions[randomQuestions[0]],
        quizQuestions[randomQuestions[1]],
        quizQuestions[randomQuestions[2]],
      ]);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    textEditingControllers.first.dispose();
    textEditingControllers[1].dispose();
    textEditingControllers.last.dispose();
    super.dispose();
  }

  void _swapSwapQuestion(int index) {
    var rand = math.Random().nextInt(quizQuestions.length);
    while (randomQuestions.any((e) => e == rand)) {
      rand = math.Random().nextInt(quizQuestions.length);
    }
    setState(() {
      randomQuestions[index] = rand;
    });
  }

  void onChange(String val, OnboardingController onboardingController) {
    final list = [
      QuizQuestion(
          question: quizQuestions[randomQuestions[0]].question,
          answer: textEditingControllers[0].text),
      QuizQuestion(
          question: quizQuestions[randomQuestions[1]].question,
          answer: textEditingControllers[1].text),
      QuizQuestion(
          question: quizQuestions[randomQuestions[2]].question,
          answer: textEditingControllers[2].text),
    ];
    onboardingController.updateSurpriseQuizAnswer(
      list,
      _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingController = ref.read(onboardingControllerProvider.notifier);
    final size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('Surprise quiz', style: CupidStyles.headingStyle),
        const SizedBox(height: 8),
        const Text(
          'This will help your potential matches know you better ',
          style: CupidStyles.normalTextStyle,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: _currentIndex == 0 ? Colors.black : Colors.grey,
                height: 1,
              ),
            ),
            Expanded(
              child: Divider(
                color: _currentIndex == 1 ? Colors.black : Colors.grey,
                height: 1,
              ),
            ),
            Expanded(
              child: Divider(
                color: _currentIndex == 2 ? Colors.black : Colors.grey,
                height: 1,
              ),
            )
          ],
        ),
        const SizedBox(height: 24),
        _questionsPageView(size, onboardingController),
        Center(
          child: DotsIndicator(
            dotsCount: 3,
            position: _currentIndex,
            mainAxisAlignment: MainAxisAlignment.center,
            decorator: const DotsDecorator(
              color: Colors.black38,
              activeColor: Colors.black,
              size: Size(4, 4),
            ),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (states) {
                return Colors.transparent;
              },
            ),
          ),
          onPressed: () {
            _swapSwapQuestion(_currentIndex);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Suffle question",
                style: CupidStyles.normalTextStyle.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.refresh_rounded,
                color: Colors.black,
              ),
            ],
          ),
        )
      ],
    );
  }

  SizedBox _questionsPageView(Size size, OnboardingController onboardingController) {
    return SizedBox(
      width: size.width,
      height: size.width * 0.8,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        children: List.generate(
          3,
          (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quizQuestions[randomQuestions[index]].question,
                            style: CupidStyles.normalTextStyle,
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: textEditingControllers[index],
                            maxLength: 120,
                            maxLines: 4,
                            style: CupidStyles.normalTextStyle.copyWith(
                              color: CupidColors.lightTextColor,
                              decoration: TextDecoration.underline,
                            ),
                            onChanged: (val) {
                              onChange(val, onboardingController);
                            },
                            onSubmitted: (val) {
                              if (_currentIndex == 0) {
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              }
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
