import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/models/course.dart';

class CourseRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createCourse(Course course) async {
    try {
      // convert course to JSON
      final courseData = course.toJson();

      // convert lesson to JSON
      final lessonsData = course.lessons.map((lesson) => lesson.toJson());

      // create course document
      await _firestore.collection('courses').doc(course.id).set({
        ...courseData,
        'lessons': lessonsData,
      });
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }
}
