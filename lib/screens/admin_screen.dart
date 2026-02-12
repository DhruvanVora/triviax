import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../providers/admin_provider.dart';
import 'add_question_screen.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(adminProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: questions.isEmpty
          ? const Center(child: Text('No custom questions yet. Add one!'))
          : ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return ListTile(
                  title: Text(question.question),
                  subtitle: Text('Correct: ${question.correctAnswer}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => Get.to(() => AddQuestionScreen(question: question)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => ref.read(adminProvider.notifier).deleteQuestion(question.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddQuestionScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
