import 'package:e_learning/models/category.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';

class CategorySection extends StatelessWidget {
  final List<Category> categories;
  const CategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
