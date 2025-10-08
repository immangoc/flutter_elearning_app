import 'package:e_learning/models/quiz.dart';
import 'package:e_learning/models/quiz_attempt.dart';
import 'package:e_learning/routes/app_routes.dart';
import 'package:e_learning/view/quiz/quiz_result/widgets/quiz_question_analysis.dart';
import 'package:e_learning/view/quiz/quiz_result/widgets/quiz_score_card.dart';
import 'package:e_learning/view/quiz/quiz_result/widgets/quiz_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_color.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizAttempt attempt;
  final Quiz quiz;
  const QuizResultScreen({
    super.key,
    required this.attempt,
    required this.quiz,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalPoints = quiz.questions.fold(0, (sum, q) => sum + q.points);
    final percentage = ((attempt.score / totalPoints) * 100).round();
    final isPassed = percentage >= 70;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              onPressed: () => Get.offAllNamed(
                AppRoutes.main,
                arguments: {'initialIndex': 2},
              ), //2 is the index for the quiz tab
              icon: Icon(Icons.close, color: AppColors.accent),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(16),
              title: Text(
                'Quiz Result',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  QuizScoreCard(percentage: percentage, isPassed: isPassed),
                  const SizedBox(height: 24),
                  QuizStatsCard(quiz: quiz, attempt: attempt),
                  const SizedBox(height: 24),
                  QuizQuestionAnalysis(quiz: quiz, attempt: attempt),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
