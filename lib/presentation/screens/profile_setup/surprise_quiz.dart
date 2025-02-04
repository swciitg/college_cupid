import 'package:college_cupid/presentation/controllers/onboarding_controller.dart';
import 'package:college_cupid/shared/colors.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:college_cupid/shared/styles.dart';
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
  List<TextEditingController> _textEditingControllers = [];

  @override
  void initState() {
    _pageController = PageController();
    _textEditingControllers.addAll([
      TextEditingController(),
      TextEditingController(),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textEditingControllers.first.dispose();
    _textEditingControllers.last.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final onboardingController =
        ref.read(onboardingControllerProvider.notifier);
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width,
      height: size.width,
      child: Column(
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
              )
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
              children: List.generate(
                2,
                (index) {
                  return DecoratedBox(
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
                            "I've always wanted to learn how to",
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _textEditingControllers[index],
                            maxLength: 120,
                            maxLines: 5,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildchoiceChips(SexualOrientation? selectedChoice,
      {required Function(SexualOrientation) onSelected}) {
    return Wrap(
      spacing: 8,
      children: SexualOrientation.values.map((tag) {
        return ChoiceChip(
          label: Text(
            tag.displayString,
            style: CupidStyles.normalTextStyle.copyWith(
              color: selectedChoice == tag
                  ? Colors.white
                  : CupidColors.textColorBlack,
            ),
          ),
          color: WidgetStateColor.resolveWith(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return CupidColors.secondaryColor;
              }
              return Colors.transparent;
            },
          ),
          checkmarkColor: Colors.white,
          selected: selectedChoice == tag,
          onSelected: (_) {
            onSelected(tag);
          },
        );
      }).toList(),
    );
  }
}
