enum QuestionType {
  singleChoice,
  dynamicSingleChoice,
}

class Question {
  final int questionNumber;
  final String question;
  final QuestionType type;
  final List<String>? options;
  final int? dependsOnQuestionNumber;
  final Map<String, List<String>>? dynamicOptions;
  final String purpose;

  const Question({
    required this.questionNumber,
    required this.question,
    required this.type,
    this.options,
    this.dependsOnQuestionNumber,
    this.dynamicOptions,
    required this.purpose,
  });
}

class Choice {
  final String label;
  final Map<String, int> points;

  const Choice({required this.label, required this.points});
}

