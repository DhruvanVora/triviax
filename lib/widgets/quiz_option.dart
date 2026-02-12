import 'package:flutter/material.dart';

class QuizOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback onTap;

  const QuizOption({
    super.key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? textColor;

    if (isAnswered) {
      if (isCorrect) {
        backgroundColor = Colors.green;
        textColor = Colors.white;
      } else if (isSelected) {
        backgroundColor = Colors.red;
        textColor = Colors.white;
      }
    } else if (isSelected) {
      backgroundColor = Colors.blue;
      textColor = Colors.white;
    }

    return Card(
      color: backgroundColor,
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(color: textColor),
        ),
        onTap: onTap,
      ),
    );
  }
}
