import 'package:e_learning/view/home/widgets/category_section.dart';
import 'package:e_learning/view/home/widgets/home_app_bar.dart';
import 'package:e_learning/view/home/widgets/search_bar_widget.dart';
import 'package:e_learning/models/category.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Category> categories = [
    Category(id: '1', name: 'Programming', icon: Icons.code, courseCount: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const HomeAppBar(),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SearchBarWidget(),
              const SizedBox(height: 32),
              CategorySection(categories: categories), // runtime => không const
            ]),
          ),
        ),
      ],
    );
  }
}
