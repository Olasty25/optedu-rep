// models/quiz_models.dart

class QuizOption {
  final String text;
  final bool isCorrect;

  QuizOption({required this.text, required this.isCorrect});
}

class QuizQuestion {
  final String questionText;
  final List<QuizOption> options;
  int? selectedOptionIndex; // To store the user's selection
  bool? isAnsweredCorrectly; // To store if the answered option was correct

  QuizQuestion({
    required this.questionText,
    required this.options,
    this.selectedOptionIndex,
    this.isAnsweredCorrectly,
  });
}
