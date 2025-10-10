import 'package:e_learning/core/theme/app_color.dart';
import 'package:e_learning/services/dummy_data_service.dart';
import 'package:e_learning/view/teacher/my_courses/widgets/empty_courses_state.dart';
import 'package:e_learning/view/teacher/my_courses/widgets/my_courses_app_bar.dart';
import 'package:e_learning/view/teacher/my_courses/widgets/teacher_course_card.dart';
import 'package:flutter/material.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teacherCourses = DummyDataService.getInstructorCourses('inst_1');

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          const MyCoursesAppBar(),
          if (teacherCourses.isEmpty)
            const SliverFillRemaining(child: EmptyCoursesState())
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => TeacherCourseCard(
                    course: teacherCourses[index],
                  ),
                  childCount: teacherCourses.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
