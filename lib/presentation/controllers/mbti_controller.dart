import 'package:college_cupid/domain/models/mbti_model.dart';
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
          if (question.id == index) question.copyWith(answer: answer) else question
      ],
    );
  }

  void reset() {
    state = MBTIModel(
      currentQuestion: 1,
      questions: mbtiQuestions,
    );
  }
}
