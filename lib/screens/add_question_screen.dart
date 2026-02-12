import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../models/question_model.dart';
import '../providers/admin_provider.dart';

class AddQuestionScreen extends ConsumerStatefulWidget {
  final Question? question;

  const AddQuestionScreen({super.key, this.question});

  @override
  ConsumerState<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends ConsumerState<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _questionController;
  late TextEditingController _correctAnswerController;
  late List<TextEditingController> _incorrectAnswerControllers;
  String _difficulty = 'easy';

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: widget.question?.question ?? '');
    _correctAnswerController = TextEditingController(text: widget.question?.correctAnswer ?? '');
    _incorrectAnswerControllers = List.generate(
      3,
      (index) => TextEditingController(
        text: widget.question != null && widget.question!.incorrectAnswers.length > index
            ? widget.question!.incorrectAnswers[index]
            : '',
      ),
    );
    _difficulty = widget.question?.difficulty ?? 'easy';
  }

  @override
  void dispose() {
    _questionController.dispose();
    _correctAnswerController.dispose();
    for (var controller in _incorrectAnswerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveQuestion() {
    if (_formKey.currentState!.validate()) {
      final questionText = _questionController.text.trim();
      final correctAnswer = _correctAnswerController.text.trim();
      final incorrectAnswers = _incorrectAnswerControllers.map((c) => c.text.trim()).toList();

      if (widget.question == null) {
        ref.read(adminProvider.notifier).addQuestion(
              questionText,
              correctAnswer,
              incorrectAnswers,
              _difficulty,
            );
      } else {
        final updatedQuestion = widget.question!.copyWith(
          question: questionText,
          correctAnswer: correctAnswer,
          incorrectAnswers: incorrectAnswers,
          difficulty: _difficulty,
        );
        ref.read(adminProvider.notifier).updateQuestion(updatedQuestion);
      }

      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.question == null ? 'Add Question' : 'Edit Question')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Question'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a question' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _correctAnswerController,
                decoration: const InputDecoration(labelText: 'Correct Answer'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the correct answer' : null,
              ),
              const SizedBox(height: 16),
              const Text('Incorrect Answers:'),
              ...List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    controller: _incorrectAnswerControllers[index],
                    decoration: InputDecoration(labelText: 'Incorrect Answer ${index + 1}'),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter an incorrect answer' : null,
                  ),
                );
              }),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _difficulty,
                items: ['easy', 'medium', 'hard']
                    .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label.capitalizeFirst!),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _difficulty = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Difficulty'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveQuestion,
                child: Text(widget.question == null ? 'Add Question' : 'Update Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
