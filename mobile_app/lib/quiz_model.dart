// models/quiz_models.dart (or wherever you define your models)

class QuizOption {
  final String text;
  final bool isCorrect; // Assuming your API provides this

  QuizOption({required this.text, required this.isCorrect});

  // Factory constructor to parse from JSON
  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool,
    );
  }

  // Optional: toJson method if you ever need to send this data
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isCorrect': isCorrect,
    };
  }
}

class QuizQuestion {
  final String id; // Assuming your API provides an ID
  final String questionText;
  final List<QuizOption> options;
  int? selectedOptionIndex; // To store the user's selection
  bool? isAnsweredCorrectly; // To store if the answered option was correct

  QuizQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    this.selectedOptionIndex,
    this.isAnsweredCorrectly,
  });

  // Factory constructor to parse from JSON
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    var optionsFromJson = json['options'] as List;
    List<QuizOption> optionList = optionsFromJson.map((i) => QuizOption.fromJson(i)).toList();

    return QuizQuestion(
      id: json['id'] as String,
      questionText: json['questionText'] as String,
      options: optionList,
    );
  }

  // Optional: toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }
}
