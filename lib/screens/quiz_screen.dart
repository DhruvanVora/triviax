import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/quiz_provider.dart';
import '../widgets/quiz_option.dart';
import 'result_screen.dart';

class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);

    // Listen for navigation to ResultScreen
    ref.listen<QuizStatus>(quizProvider.select((state) => state.status), (previous, next) {
      if (next == QuizStatus.completed) {
        Get.off(() => const ResultScreen());
      }
    });

    if (quizState.status == QuizStatus.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (quizState.status == QuizStatus.error) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: ${quizState.errorMessage}')),
      );
    }

    if (quizState.status == QuizStatus.completed) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (quizState.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: Text('No questions available.')),
      );
    }

    final currentQuestion = quizState.questions[quizState.currentQuestionIndex];
    
    final allOptions = currentQuestion.allAnswers;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${quizState.currentQuestionIndex + 1} / ${quizState.questions.length}'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 4),
                Text('${quizState.lives}'),
                const SizedBox(width: 16),
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${quizState.score}'),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentQuestion.question,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ...allOptions.map((option) {
                        final isSelected = quizState.selectedAnswer == option;
                        final isCorrect = option == currentQuestion.correctAnswer;
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: QuizOption(
                            text: option,
                            isSelected: isSelected,
                            isCorrect: isCorrect,
                            isAnswered: quizState.isAnswered,
                            onTap: () {
                              if (!quizState.isAnswered) {
                                ref.read(quizProvider.notifier).answerQuestion(option);
                              }
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            if (quizState.isAnswered)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (quizState.currentQuestionIndex >= quizState.questions.length - 1) {
                       ref.read(quizProvider.notifier).nextQuestion();
                    } else {
                       ref.read(quizProvider.notifier).nextQuestion();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    quizState.currentQuestionIndex < quizState.questions.length - 1 
                        ? 'Next Question' 
                        : 'Finish Quiz'
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
