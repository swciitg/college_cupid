// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:math' as math;
import 'package:college_cupid/domain/models/user_profile.dart'; // Ensure QuizQuestion is here or in globals
import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/common_widgets.dart';
import 'package:college_cupid/presentation/screens/profile_setup/widgets/recorder.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/globals.dart'; // Assumes quizQuestions is here
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoreAboutYou extends ConsumerStatefulWidget {
  const MoreAboutYou({super.key});

  @override
  ConsumerState<MoreAboutYou> createState() => _MoreAboutYouState();
}

class _MoreAboutYouState extends ConsumerState<MoreAboutYou> {
  final List<TextEditingController> textEditingControllers = [];

  List<int> randomQuestions = [0, 1, 2];

  // Map to track audio paths
  final Map<int, String?> _audioPaths = {0: null, 1: null, 2: null};

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    textEditingControllers.addAll([
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Randomize questions
      _swapSwapQuestion(0);
      _swapSwapQuestion(1);
      _swapSwapQuestion(2);

      // Update Riverpod state
      ref.read(onboardingControllerProvider.notifier).setSurpriseQuiz([
        quizQuestions[randomQuestions[0]],
        quizQuestions[randomQuestions[1]],
        quizQuestions[randomQuestions[2]],
      ]);
    });
  }

  @override
  void dispose() {
    for (var controller in textEditingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _swapSwapQuestion(int index) {
    if (quizQuestions.isEmpty) return;

    var rand = math.Random().nextInt(quizQuestions.length);
    int attempts = 0;

    // Ensure unique questions compared to OTHER slots
    // We shouldn't care if it clashes with the *old* value at this index,
    // but we must check against the *other* indices.
    bool appearsElsewhere(int r) {
      for (int i = 0; i < randomQuestions.length; i++) {
        if (i == index) continue; // Skip self
        if (randomQuestions[i] == r) return true;
      }
      return false;
    }

    while (appearsElsewhere(rand) && attempts < 10) {
      rand = math.Random().nextInt(quizQuestions.length);
      attempts++;
    }

    setState(() {
      randomQuestions[index] = rand;
      // Reset answers for this question index when swapped
      textEditingControllers[index].clear();
      _audioPaths[index] = null;
    });
  }

  void _updateController(OnboardingController onboardingController) {
    final list = [
      QuizQuestion(
        question: quizQuestions[randomQuestions[0]].question,
        answer: textEditingControllers[0].text,
        audioPath: _audioPaths[0],
      ),
      QuizQuestion(
        question: quizQuestions[randomQuestions[1]].question,
        answer: textEditingControllers[1].text,
        audioPath: _audioPaths[1],
      ),
      QuizQuestion(
        question: quizQuestions[randomQuestions[2]].question,
        answer: textEditingControllers[2].text,
        audioPath: _audioPaths[2],
      ),
    ];
    onboardingController.setSurpriseQuiz(list);
  }

  @override
  Widget build(BuildContext context) {
    final onboardingController =
        ref.read(onboardingControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEBE9FF), // Light purple background
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  color: Color(0xFF6C5DD3), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Recording at least 1 voice note increases your chances of matchmaking.",
                  style: CupidTextStyles.normalTextStyle.copyWith(
                      color: CupidColors.brandPurple600,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(3, (index) {

          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    quizQuestions[randomQuestions[index]].question,
                    style: CupidStyles.subHeadingTextStyle.copyWith(
                        color: CupidColors.grey700,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
                const SizedBox(height: 4),
                AudioRecorder(
                  existingFilePath: _audioPaths[index],
                  textController: textEditingControllers[index],
                  onRecordingComplete: (path) {
                    setState(() {
                      _audioPaths[index] = path;
                    });
                    _updateController(onboardingController);
                    log(  "Recording completed for question $index: $path");
                  },
                  onDelete: () {
                    setState(() {
                      _audioPaths[index] = null;
                    });
                    _updateController(onboardingController);
                    log("Recording deleted for question $index");
                  }, 
                  onChanged: (String answer) {  
                    _updateController(onboardingController);
                    log("Answer updated for question $index: $answer");
                  },
                )
              ],
            ),
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }
}
