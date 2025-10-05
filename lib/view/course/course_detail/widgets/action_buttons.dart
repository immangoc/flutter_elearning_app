import 'package:e_learning/models/course.dart';
import 'package:flutter/material.dart';

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
              } else {
                //navigate to first lesson
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
            onPressed: () {
              //navigate to chat screen
            },
            icon: const Icon(Icons.chat),
        ),
      ],
    );
  }
}
