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

  Future<List<Course>> getInstructorCourses(String instructorID) async {
    try {
      final snapshot = await _firestore
          .collection('courses')
          .where('instructorID', isEqualTo: instructorID)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Course data is null');
        }
        return Course.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch instructor courses: $e');
    }
  }

  Future<void> updateCourse(Course course) async {
    try {
      // convert course to JSON
      final courseData = course.toJson();

      // convert lesson to JSON
      final lessonsData = course.lessons.map((lesson) => lesson.toJson()).toList();

      // update course document
      await _firestore.collection('courses').doc(course.id).update({
        ...courseData,
        'lessons': lessonsData,
      });


    }catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  // delete course
  Future<void> deleteCourse(String courseId) async {
    try {
      // delete the course document
      await _firestore.collection('courses').doc(courseId).delete();

      // delete all enrollments for this course
      final enrollmentsSnapshot = await _firestore
          .collection('enrollments')
          .where('courseId', isEqualTo: courseId)
          .get();

      for (var doc in enrollmentsSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }

}
