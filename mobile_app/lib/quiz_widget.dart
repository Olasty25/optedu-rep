// widgets/quiz_widget.dart

import 'package:flutter/material.dart';
import 'package:mobile_app/quiz_model.dart';

class QuizWidget extends StatefulWidget {
  final List<QuizQuestion> questions;

  const QuizWidget({Key? key, required this.questions}) : super(key: key);

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _score = 0;
  bool _quizCompleted = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onOptionSelected(int questionIndex, int optionIndex) {
    if (widget.questions[questionIndex].selectedOptionIndex != null) {
      return; // Already answered
    }

    setState(() {
      widget.questions[questionIndex].selectedOptionIndex = optionIndex;
      bool correct = widget.questions[questionIndex].options[optionIndex].isCorrect;
      widget.questions[questionIndex].isAnsweredCorrectly = correct;

      if (correct) {
        _score++;
      }

      // Check if it's the last question
      if (_currentPage == widget.questions.length - 1) {
        _quizCompleted = true;
      }
    });
  }

  void _nextPage() {
    if (_currentPage < widget.questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _resetQuiz() {
    setState(() {
      for (var question in widget.questions) {
        question.selectedOptionIndex = null;
        question.isAnsweredCorrectly = null;
      }
      _score = 0;
      _currentPage = 0;
      _quizCompleted = false;
      _pageController.jumpToPage(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questions.isEmpty) {
      return const Center(child: Text("No questions available."));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Time! (${_currentPage + 1}/${widget.questions.length})'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.questions.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return _buildQuestionPage(widget.questions[index], index);
              },
            ),
          ),
          if (_quizCompleted) _buildQuizSummary(),
          _buildNavigationControls(),
        ],
      ),
    );
  }

  Widget _buildQuestionPage(QuizQuestion question, int questionIndex) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q${questionIndex + 1}: ${question.questionText}',
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          ...List.generate(question.options.length, (optionIndex) {
            final option = question.options[optionIndex];
            bool isSelected = question.selectedOptionIndex == optionIndex;
            bool? isCorrect = question.isAnsweredCorrectly;
            Color? tileColor;

            if (isSelected) {
              tileColor = isCorrect == true ? Colors.green.shade100 : Colors.red.shade100;
            }

            return Card(
              color: tileColor,
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6.0),
              child: ListTile(
                title: Text(option.text),
                leading: Icon(
                  isSelected
                      ? (option.isCorrect ? Icons.check_circle : Icons.cancel)
                      : Icons.radio_button_unchecked,
                  color: isSelected
                      ? (option.isCorrect ? Colors.green : Colors.red)
                      : Colors.grey,
                ),
                onTap: () => _onOptionSelected(questionIndex, optionIndex),
              ),
            );
          }),
          const Spacer(), // Pushes content to the top
          if (question.selectedOptionIndex != null)
            Center(
              child: Text(
                question.isAnsweredCorrectly == true
                    ? "Correct!"
                    : "Incorrect. The right answer was: ${question.options.firstWhere((opt) => opt.isCorrect).text}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: question.isAnsweredCorrectly == true ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0 && !_quizCompleted)
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
              onPressed: _previousPage,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            )
          else
            const SizedBox(), // Keep spacing consistent

          if (!_quizCompleted &&
              _currentPage < widget.questions.length - 1 &&
              widget.questions[_currentPage].selectedOptionIndex != null)
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            )
          else if (_quizCompleted ||
              (_currentPage == widget.questions.length - 1 &&
                  widget.questions[_currentPage].selectedOptionIndex != null))
            ElevatedButton.icon(
              icon: const Icon(Icons.celebration),
              label: const Text('Show Results'),
              onPressed: () {
                setState(() {
                  _quizCompleted = true; // Ensure summary is shown
                });
                // Optionally, you could navigate to a dedicated results screen here
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            )
          else
            const SizedBox(), // Placeholder for when next is not available yet
        ],
      ),
    );
  }

  Widget _buildQuizSummary() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Quiz Completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 10),
              Text(
                'Your Score: $_score / ${widget.questions.length}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Retake Quiz'),
                onPressed: _resetQuiz,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
