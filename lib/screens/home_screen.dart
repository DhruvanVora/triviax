import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/theme_controller.dart';
import '../providers/admin_provider.dart';
import '../providers/quiz_provider.dart';
import 'admin_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TriviaX'),
        actions: [
          IconButton(
            icon: Obx(() => Icon(themeController.isDarkMode.value ? Icons.light_mode : Icons.dark_mode)),
            onPressed: themeController.toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showDifficultyDialog(context, ref),
              child: const Text('Play API Quiz'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final customQuestions = ref.read(adminProvider);
                if (customQuestions.isEmpty) {
                  Get.snackbar('Info', 'No custom questions available. create some first!');
                  return;
                }
                ref.read(quizProvider.notifier).startCustomQuiz(customQuestions);
                Get.to(() => const QuizScreen());
              },
              child: const Text('Play Custom Quiz'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.to(() => const AdminScreen()),
              child: const Text('Admin Mode'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Difficulty'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Easy'),
              onTap: () {
                ref.read(quizProvider.notifier).startApiQuiz('easy');
                Get.back();
                Get.to(() => const QuizScreen());
              },
            ),
            ListTile(
              title: const Text('Medium'),
              onTap: () {
                ref.read(quizProvider.notifier).startApiQuiz('medium');
                Get.back();
                Get.to(() => const QuizScreen());
              },
            ),
            ListTile(
              title: const Text('Hard'),
              onTap: () {
                ref.read(quizProvider.notifier).startApiQuiz('hard');
                Get.back();
                Get.to(() => const QuizScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
