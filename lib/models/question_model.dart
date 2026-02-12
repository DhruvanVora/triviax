class Question {
  final String id;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String difficulty;
  final List<String> allAnswers;

  Question({
    required this.id,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.difficulty,
    List<String>? allAnswers,
  }) : allAnswers = allAnswers ?? (List<String>.from(incorrectAnswers)..add(correctAnswer)..shuffle());

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      incorrectAnswers: List<String>.from(json['incorrectAnswers'] ?? []),
      difficulty: json['difficulty'] ?? 'easy',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'correctAnswer': correctAnswer,
      'incorrectAnswers': incorrectAnswers,
      'difficulty': difficulty,
    };
  }
  
  Question copyWith({
    String? id,
    String? question,
    String? correctAnswer,
    List<String>? incorrectAnswers,
    String? difficulty,
  }) {
    return Question(
      id: id ?? this.id,
      question: question ?? this.question,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
