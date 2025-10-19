import 'dart:async';
import 'package:e_learning/bloc/filtered_course/filtered_course_state.dart';
import 'package:e_learning/view/course/course_list/widgets/course_card.dart';
import 'package:e_learning/view/course/course_list/widgets/empty_state_widget.dart';
import 'package:e_learning/view/teacher/my_courses/widgets/shimmer_course_card.dart';
import 'package:get/get.dart';
import 'package:e_learning/bloc/filtered_course/filtered_course_bloc.dart';
import 'package:e_learning/bloc/filtered_course/filtered_course_event.dart';
import 'package:e_learning/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseSearchScreen extends StatefulWidget {
  const CourseSearchScreen({super.key});

  @override
  State<CourseSearchScreen> createState() => _CourseSearchScreenState();
}

class _CourseSearchScreenState extends State<CourseSearchScreen> {
  final _searchController = TextEditingController();
  final _debounce = Debouncer(milliseconds: 300);
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _focusNode.dispose();
    _debounce.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
    _debounce.run(() {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        context.read<FilteredCourseBloc>().add(SearchCourses(query));
      } else {
        context.read<FilteredCourseBloc>().add(ClearFilteredCourses());
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<FilteredCourseBloc>().add(ClearFilteredCourses());
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
      ),
      title: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        style: const TextStyle(color: AppColors.primary, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Search for courses...',
          hintStyle: TextStyle(color: AppColors.primary.withValues(alpha: 0.5)),
          filled: true,
          fillColor: AppColors.primary.withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.primary.withValues(alpha: 0.5),
            size: 22,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.primary,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Find Your Next Course',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Start typing to see the magic happen!',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: _buildAppBar(),
      body: BlocBuilder<FilteredCourseBloc, FilteredCourseState>(
        builder: (context, state) {
          if (state is FilteredCourseInitial) {
            return _buildInitialState();
          }
          if (state is FilteredCourseLoading) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (context, index) => const ShimmerCourseCard(),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
            );
          }
          if (state is FilteredCourseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong.',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is FilteredCoursesLoaded) {
            if (state.courses.isEmpty) {
              return EmptyStateWidget(
                message: 'No courses found for "${_searchController.text}"',
                onActionPressed: _clearSearch,
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.courses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return CourseCard(
                  courseId: course.id,
                  title: course.title,
                  subtitle: course.description,
                  imageUrl: course.imageUrl,
                  rating: course.rating,
                  duration: '${course.lessons.length * 30} mins',
                  isPremium: course.isPremium,
                );
              },
            );
          }
          return _buildInitialState();
        },
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
