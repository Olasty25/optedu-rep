// main.dart or any other screen

import 'package:flutter/material.dart';
import 'package:mobile_app/quiz_model.dart';
import 'package:mobile_app/quiz_widget.dart';


class QuizScreen extends StatelessWidget {
  QuizScreen({super.key});

  // Sample Quiz Data
  final List<QuizQuestion> sampleQuestions = [
    QuizQuestion(
      questionText: 'What is the capital of France?',
      options: [
        QuizOption(text: 'Berlin', isCorrect: false),
        QuizOption(text: 'Madrid', isCorrect: false),
        QuizOption(text: 'Paris', isCorrect: true),
        QuizOption(text: 'Rome', isCorrect: false),
      ],
    ),
    QuizQuestion(
      questionText: 'Which planet is known as the Red Planet?',
      options: [
        QuizOption(text: 'Earth', isCorrect: false),
        QuizOption(text: 'Mars', isCorrect: true),
        QuizOption(text: 'Jupiter', isCorrect: false),
        QuizOption(text: 'Saturn', isCorrect: false),
      ],
    ),
    QuizQuestion(
      questionText: 'What is the largest ocean on Earth?',
      options: [
        QuizOption(text: 'Atlantic Ocean', isCorrect: false),
        QuizOption(text: 'Indian Ocean', isCorrect: false),
        QuizOption(text: 'Arctic Ocean', isCorrect: false),
        QuizOption(text: 'Pacific Ocean', isCorrect: true),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Important: Create a new list instance if you plan to modify selectedOptionIndex
    // This is because the sampleQuestions list is const.
    // A better approach for real apps is to fetch or manage this state with a state management solution.
    List<QuizQuestion> quizQuestions = sampleQuestions.map((q) => QuizQuestion(
      questionText: q.questionText,
      options: q.options.map((o) => QuizOption(text: o.text, isCorrect: o.isCorrect)).toList(),
    )).toList();


    return QuizWidget(questions: quizQuestions);
  }
}

