import 'package:bloc/bloc.dart';
import 'package:e_learning/bloc/auth/auth_bloc.dart';
import 'package:e_learning/bloc/course/course_event.dart';
import 'package:e_learning/bloc/course/course_state.dart';
import '../../repositories/course_repository.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;
  final AuthBloc _authBloc;

  CourseBloc({
    required CourseRepository courseRepository,
    required AuthBloc authBloc,
  }) : _courseRepository = courseRepository,
       _authBloc = authBloc,
       super(CourseInitial()) {
    on<LoadCourses>(_onLoadCourses);
    on<LoadCourseDetail>(_onLoadCourseDetail);
    on<RefreshCoursesDetail>(_onRefreshCoursesDetail);
    on<EnrollCourse>(_onEnrollCourse);
    on<LoadEnrolledCourses>(_onLoadEnrolledCourses);
    on<LoadOfflineCourses>(_onLoadOfflineCourses);
    on<UpdateCourse>(_onUpdateCourse);
    on<DeleteCourse>(_onDeleteCourse);
  }

  Future<void> _onLoadCourses(
    LoadCourses event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final courses = await _courseRepository.getCourse();
      emit(CourseLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onLoadCourseDetail(
    LoadCourseDetail event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final course = await _courseRepository.getCourseDetail(event.courseId);
      emit(CourseDetailLoaded(course));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onRefreshCoursesDetail(
    RefreshCoursesDetail event,
    Emitter<CourseState> emit,
  ) async {
    try {
      if (state is CourseDetailLoaded) {
        final course = await _courseRepository.getCourseDetail(event.courseId);
        emit(CourseDetailLoaded(course));
      }
    }catch (e) {
      //emit error state if needed
    }
  }


  Future<void> _onEnrollCourse(
    EnrollCourse event,
    Emitter<CourseState> emit,
  ) async {
    //implement latter
  }

  Future<void> _onLoadEnrolledCourses(
    LoadEnrolledCourses event,
    Emitter<CourseState> emit,
  ) async {
    //implement latter
  }

  Future<void> _onLoadOfflineCourses(
    LoadOfflineCourses event,
    Emitter<CourseState> emit,
  ) async {
    //implement latter
  }

  Future<void> _onUpdateCourse(
    UpdateCourse event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final courses = await _courseRepository.getInstructorCourses(
        event.instructorID,
      );
      emit(CourseLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onDeleteCourse(
    DeleteCourse event,
    Emitter<CourseState> emit,
  ) async {
    try {
      await _courseRepository.deleteCourse(event.courseId);
      final userId = _authBloc.state.userModel?.uid;
      if (userId != null) {
        final courses = await _courseRepository.getInstructorCourses(userId);
        //first emit the success message
        emit(CourseDeleted('Course deleted successfully'));
        //then emit the updated course list
        emit(CourseLoaded(courses));
      }
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }
}
