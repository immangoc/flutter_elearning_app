import 'package:e_learning/models/quiz.dart';
import 'package:flutter/material.dart';

import '../../../../models/quiz_attempt.dart';

class QuizSubmitDialog extends StatelessWidget {
  final QuizAttempt attempt;
  final Quiz quiz;
  const QuizSubmitDialog({
    super.key,
    required this.attempt,
    required this.quiz,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
