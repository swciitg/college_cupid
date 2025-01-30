class MBTIModel {
  final int currentQuestion;
  final List<QuestionModel> questions;

  MBTIModel({
    required this.currentQuestion,
    required this.questions,
  });

  MBTIModel copyWith({
    int? currentQuestion,
    List<QuestionModel>? questions,
  }) {
    return MBTIModel(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      questions: questions ?? this.questions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentQuestion': currentQuestion,
      'questions': questions.map((x) => x.toMap()).toList(),
    };
  }

  factory MBTIModel.fromMap(Map<String, dynamic> map) {
    return MBTIModel(
      currentQuestion: map['currentQuestion'],
      questions: List<QuestionModel>.from(
        map['questions']?.map(
          (x) => QuestionModel.fromMap(x),
        ),
      ),
    );
  }

  int get totalScore {
    return questions.fold(0, (previousValue, element) => previousValue + element.score);
  }
}

class QuestionModel {
  final int id;
  final String question;
  final String type;
  final int? answer;
  final bool reverseScore;

  int get score {
    if (answer == null) return 0;
    return reverseScore ? 6 - answer! : answer!;
  }

  QuestionModel({
    required this.id,
    required this.question,
    required this.type,
    this.answer,
    required this.reverseScore,
  });

  QuestionModel copyWith({
    String? question,
    String? type,
    int? answer,
    bool? reverseScore,
  }) {
    return QuestionModel(
      id: id,
      question: question ?? this.question,
      type: type ?? this.type,
      answer: answer ?? this.answer,
      reverseScore: reverseScore ?? this.reverseScore,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'type': type,
      'answer': answer,
      'reverseScore': reverseScore,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'],
      question: map['question'],
      type: map['type'],
      answer: map['answer'],
      reverseScore: map['reverseScore'],
    );
  }
}

final mbtiQuestions = [
  // Energy questions
  QuestionModel(
    id: 1,
    question: "I feel energized after spending time in large social gatherings.",
    type: "Energy",
    reverseScore: false,
  ),
  QuestionModel(
    id: 2,
    question: "I prefer deep conversations with one person over small talk in groups.",
    type: "Energy",
    reverseScore: true,
  ),
  QuestionModel(
    id: 3,
    question: "Being alone for too long makes me restless.",
    type: "Energy",
    reverseScore: true,
  ),
  QuestionModel(
    id: 4,
    question: "I often need quiet time to recharge after a busy day.",
    type: "Energy",
    reverseScore: false,
  ),
  QuestionModel(
    id: 5,
    question: "I enjoy attending parties with many new people.",
    type: "Energy",
    reverseScore: false,
  ),

  // Mind questions
  QuestionModel(
    id: 6,
    question: "I rely more on past experiences than abstract theories when solving problems.",
    type: "Mind",
    reverseScore: false,
  ),
  QuestionModel(
    id: 7,
    question: "I often imagine futuristic scenarios or inventions.",
    type: "Mind",
    reverseScore: true,
  ),
  QuestionModel(
    id: 8,
    question: "I prefer clear, step-by-step instructions over open-ended tasks.",
    type: "Mind",
    reverseScore: false,
  ),
  QuestionModel(
    id: 9,
    question: "Hidden meanings in art or poetry fascinate me.",
    type: "Mind",
    reverseScore: true,
  ),
  QuestionModel(
    id: 10,
    question: "I focus on practical details rather than abstract ideas.",
    type: "Mind",
    reverseScore: false,
  ),

  // Nature questions
  QuestionModel(
    id: 11,
    question: "Logical consistency matters more than others’ feelings in debates.",
    type: "Nature",
    reverseScore: false,
  ),
  QuestionModel(
    id: 12,
    question: "I prioritize group harmony over strict fairness.",
    type: "Nature",
    reverseScore: true,
  ),
  QuestionModel(
    id: 13,
    question: "I struggle to comfort emotionally distressed people.",
    type: "Nature",
    reverseScore: false,
  ),
  QuestionModel(
    id: 14,
    question: "I often adjust my plans to accommodate others’ needs.",
    type: "Nature",
    reverseScore: true,
  ),
  QuestionModel(
    id: 15,
    question: "I make decisions based on facts rather than emotions.",
    type: "Nature",
    reverseScore: false,
  ),

  // Tactics questions
  QuestionModel(
    id: 16,
    question: "I work best with strict deadlines and detailed plans.",
    type: "Tactics",
    reverseScore: false,
  ),
  QuestionModel(
    id: 17,
    question: "I enjoy improvising rather than sticking to a schedule.",
    type: "Tactics",
    reverseScore: true,
  ),
  QuestionModel(
    id: 18,
    question: "A messy workspace stresses me out.",
    type: "Tactics",
    reverseScore: false,
  ),
  QuestionModel(
    id: 19,
    question: "I prefer keeping my options open rather than committing early.",
    type: "Tactics",
    reverseScore: true,
  ),
  QuestionModel(
    id: 20,
    question: "I like to have a clear plan for the day.",
    type: "Tactics",
    reverseScore: false,
  ),
];
