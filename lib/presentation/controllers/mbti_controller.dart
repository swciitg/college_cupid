import 'dart:developer';

import 'package:college_cupid/domain/models/mbti_model.dart';
import 'package:college_cupid/shared/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mbtiControllerProvider =
    StateNotifierProvider<MbtiController, MBTIModel>((ref) => MbtiController());

class MbtiController extends StateNotifier<MBTIModel> {
  MbtiController()
      : super(MBTIModel(
          currentQuestion: 1,
          questions: mbtiQuestions,
        ));

  void answerQuestion(int index, int answer) {
    state = state.copyWith(
      currentQuestion: index + 1,
      questions: [
        for (final question in state.questions)
          if (question.id == index)
            question.copyWith(answer: answer)
          else
            question
      ],
    );
  }

  void reset() {
    state = MBTIModel(
      currentQuestion: 1,
      questions: mbtiQuestions,
    );
  }

  PersonalityType? getPersonalityType() {
    final answeredQuestions =
        state.questions.where((question) => question.answer != null).toList();
    if (answeredQuestions.length < mbtiQuestions.length) return null;
    int energy = 0;
    int mind = 0;
    int nature = 0;
    int tactics = 0;

    for (final question in state.questions) {
      switch (question.type) {
        case QuestionCategory.energy:
          energy += question.score;
          break;
        case QuestionCategory.mind:
          mind += question.score;
          break;
        case QuestionCategory.nature:
          nature += question.score;
          break;
        case QuestionCategory.tactics:
          tactics += question.score;
          break;
      }
    }

    var personalityString = '';
    personalityString += energy / 5 >= 3 ? 'e' : 'i';
    personalityString += mind / 5 >= 3 ? 's' : 'n';
    personalityString += nature / 5 >= 3 ? 't' : 'f';
    personalityString += tactics / 5 >= 3 ? 'j' : 'p';
    log("Personality String: $personalityString");
    return PersonalityType.fromString(personalityString);
  }
}
