import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/question_model.dart';

class AdminNotifier extends Notifier<List<Question>> {
  @override
  List<Question> build() {
    return [];
  }

  final _uuid = const Uuid();

  void addQuestion(String question, String correctAnswer, List<String> incorrectAnswers, String difficulty) {
    final newQuestion = Question(
      id: _uuid.v4(),
      question: question,
      correctAnswer: correctAnswer,
      incorrectAnswers: incorrectAnswers,
      difficulty: difficulty,
    );
    state = [...state, newQuestion];
  }

  void updateQuestion(Question updatedQuestion) {
    state = [
      for (final q in state)
        if (q.id == updatedQuestion.id) updatedQuestion else q,
    ];
  }

  void deleteQuestion(String id) {
    state = state.where((q) => q.id != id).toList();
  }

  void clearQuestions() {
    state = [];
  }
}

final adminProvider = NotifierProvider<AdminNotifier, List<Question>>(() {
  return AdminNotifier();
});
