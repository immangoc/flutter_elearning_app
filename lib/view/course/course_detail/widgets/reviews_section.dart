import 'package:e_learning/core/theme/app_color.dart';
import 'package:e_learning/models/review.dart';
import 'package:e_learning/repositories/review_repository.dart';
import 'package:flutter/material.dart';

class ReviewsSection extends StatefulWidget {
  final String courseId;
  const ReviewsSection({super.key, required this.courseId});

  @override
  State<ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection> {
  final ReviewRepository _reviewRepository = ReviewRepository();
  List<Review> _reviews = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    try {
      final reviews = await _reviewRepository.getCourseReviews(widget.courseId);
      setState(() {
        _reviews = reviews;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reviews',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                //implement latter
              },
              label: const Text('Write a review'),
              icon: const Icon(Icons.rate_review),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_reviews.isEmpty)
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.reviews_outlined,
                  size: 48,
                  color: AppColors.secondary.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No reviews yet. ',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Be the first to write a review!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reviews.length,
            itemBuilder: (context, index) {
              final review = _reviews[index];
              return _buildReviewTile(
                context,
                name: review.userName,
                rating: review.rating,
                comment: review.comment,
                date: _formatDate(review.createdAt),
              );
            },
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Widget _buildReviewTile(
    BuildContext context, {
    required String name,
    required double rating,
    required String comment,
    required String date,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  name[0],
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: AppColors.primary,
                            size: 16,
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(comment, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
