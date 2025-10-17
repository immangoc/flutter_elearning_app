import 'package:e_learning/bloc/course/course_bloc.dart';
import 'package:e_learning/bloc/course/course_event.dart';
import 'package:e_learning/bloc/course/course_state.dart';
import 'package:e_learning/core/theme/app_color.dart';
import 'package:e_learning/services/user_service.dart';
import 'package:e_learning/view/teacher/my_courses/widgets/empty_courses_state.dart';
import 'package:e_learning/view/teacher/my_courses/widgets/my_courses_app_bar.dart';
import 'package:e_learning/view/teacher/my_courses/widgets/shimmer_course_card.dart';
import 'package:e_learning/view/teacher/my_courses/widgets/teacher_course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {

  @override
  void initState() {
    super.initState();
    final userService = UserService();
    final instructorID = userService.getCurrentUserId();
    if (instructorID != null) {
      context.read<CourseBloc>().add(UpdateCourse(instructorID));
    }
  }


  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    final instructorID = userService.getCurrentUserId();

    if (instructorID == null) {
      return const Center(child: Text('User not logged in'));
    }

    return BlocConsumer<CourseBloc, CourseState>(
      listener: (context, state) {
        if(state is CourseDeleted) {
          Fluttertoast.showToast(
            msg: state.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      builder: (context, state) {
        if (state is CourseLoading) {
          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            appBar: AppBar(
              title: const Text('My Courses'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => const ShimmerCourseCard(),
            ),
          );
        } else if (state is CourseError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is CourseLoaded) {
          final teacherCourses = state.courses;
          if (teacherCourses.isEmpty) {
            return Scaffold(
              backgroundColor: AppColors.lightBackground,
              appBar: AppBar(
                title: const Text('My Courses'),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              body: const EmptyCoursesState(),
            );
          }
          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                const MyCoursesAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          TeacherCourseCard(course: teacherCourses[index]),
                      childCount: teacherCourses.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          //initial state or other states
          context.read<CourseBloc>().add(UpdateCourse(instructorID));
          return Scaffold(
            backgroundColor: AppColors.lightBackground,
            appBar: AppBar(
              title: const Text('My Course'),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) => const ShimmerCourseCard(),
            ),
          );
        }
      },
    );
  }
}
