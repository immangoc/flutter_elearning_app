import 'package:e_learning/models/course.dart';
import 'package:e_learning/routes/app_routes.dart';
import 'package:e_learning/view/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/dummy_data_service.dart';

class ActionButtons extends StatelessWidget {
  final Course course;
  const ActionButtons({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (course.isPremium &&
                  !DummyDataService.isCourseUnlocked(course.id)) {
                //navigate to payment
                Get.toNamed(
                  AppRoutes.payment,
                  arguments: {
                    'courseId': course.id,
                    'courseName': course.title,
                    'price': course.price,
                  },
                );
              } else {
                //navigate to first lesson
                Get.toNamed(
                  AppRoutes.lesson.replaceAll(':id', course.lessons.first.id),
                  parameters: {'courseId': course.id},
                );
              }
            },
            label: const Text('Start Learning'),
            icon: const Icon(Icons.play_circle),
          ),
        ),
        // only show chat button if course is not premium or if it's unlocked
        if (!course.isPremium || DummyDataService.isCourseUnlocked(course.id))
          const SizedBox(width: 16),
        IconButton(
          onPressed: () => Get.to(
            () => ChatScreen(
              courseId: course.id,
              instructorID: course.instructorID,
              isTeacherView: false,
            ),
          ),
          icon: const Icon(Icons.chat),
        ),
      ],
    );
  }
}
