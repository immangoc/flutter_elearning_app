import 'package:flutter/material.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Course List Screen',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
