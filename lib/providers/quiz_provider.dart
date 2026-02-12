import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';
import 'api_provider.dart';

enum QuizStatus { initial, loading, playing, completed, error }

class QuizState {
  final List<Question> questions;
  final int currentQuestionIndex;
  final int score;
  final int lives;
  final QuizStatus status;
  final String? errorMessage;
  final String? selectedAnswer;
  final bool isAnswered;

  QuizState({
    this.questions = const [],
    this.currentQuestionIndex = 0,
    this.score = 0,
    this.lives = 3,
    this.status = QuizStatus.initial,
    this.errorMessage,
    this.selectedAnswer,
    this.isAnswered = false,
  });

  QuizState copyWith({
    List<Question>? questions,
    int? currentQuestionIndex,
    int? score,
    int? lives,
    QuizStatus? status,
    String? errorMessage,
    String? selectedAnswer,
    bool? isAnswered,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      lives: lives ?? this.lives,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isAnswered: isAnswered ?? this.isAnswered,
    );
  }
}

class QuizNotifier extends Notifier<QuizState> {
  late final ApiService _apiService;

  @override
  QuizState build() {
    _apiService = ref.read(apiServiceProvider);
    return QuizState();
  }

  Future<void> startApiQuiz(String difficulty) async {
    state = state.copyWith(status: QuizStatus.loading, errorMessage: null);
    try {
      final questions = await _apiService.fetchQuestions(difficulty: difficulty);
      state = QuizState(
        questions: questions,
        status: QuizStatus.playing,
        lives: 3,
        score: 0,
      );
    } catch (e) {
      state = state.copyWith(status: QuizStatus.error, errorMessage: e.toString());
    }
  }

  void startCustomQuiz(List<Question> questions) {
    if (questions.isEmpty) {
      state = state.copyWith(status: QuizStatus.error, errorMessage: "No custom questions available.");
      return;
    }
    final shuffledQuestions = questions.map((q) => q.copyWith()).toList();
    
    state = QuizState(
      questions: shuffledQuestions,
      status: QuizStatus.playing,
      lives: 3,
      score: 0,
    );
  }

  void answerQuestion(String answer) {
    if (state.isAnswered || state.status != QuizStatus.playing) return;

    final currentQuestion = state.questions[state.currentQuestionIndex];
    final isCorrect = currentQuestion.correctAnswer == answer;

    int newScore = state.score;
    int newLives = state.lives;

    if (isCorrect) {
      newScore += 10;
    } else {
      newLives -= 1;
    }

    state = state.copyWith(
      score: newScore,
      lives: newLives,
      selectedAnswer: answer,
      isAnswered: true,
    );

    if (newLives <= 0) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        state = state.copyWith(status: QuizStatus.completed);
      });
    }
  }

  void nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        selectedAnswer: null,
        isAnswered: false,
      );
    } else {
      state = state.copyWith(status: QuizStatus.completed);
    }
  }

  void reset() {
    state = QuizState();
  }
}

final quizProvider = NotifierProvider<QuizNotifier, QuizState>(QuizNotifier.new);
