import 'package:bloc/bloc.dart';
import 'package:e_learning/bloc/filtered_course/filtered_course_event.dart';
import 'package:e_learning/bloc/filtered_course/filtered_course_state.dart';
import 'package:e_learning/repositories/course_repository.dart';

import '../../models/course.dart';

class FilteredCourseBloc
    extends Bloc<FilteredCourseEvent, FilteredCourseState> {
  final CourseRepository _courseRepository;
  String? _currentCategoryId;
  String? _currentLevel;

  FilteredCourseBloc({required CourseRepository courseRepository})
    : _courseRepository = courseRepository,
      super(FilteredCourseInitial()) {
    on<FilterCoursesByCategory>(_onFilterCoursesByCategory);
    on<FilterCourseByLevel>(_onFilterCoursesByLevel);
    on<ClearFilteredCourses>(_onClearFilteredCourses);
  }

  Future<void> _onFilterCoursesByCategory(
    FilterCoursesByCategory event,
    Emitter<FilteredCourseState> emit,
  ) async {
    emit(FilteredCourseLoading());
    try {
      _currentCategoryId = event.categoryId;
      final courses = await _filterCourses();
      emit(
        FilteredCoursesLoaded(
          courses,
          categoryId: _currentCategoryId,
          level: _currentLevel,
        ),
      );
    } catch (e) {
      emit(FilteredCourseError(e.toString()));
    }
  }

Future<void> _onFilterCoursesByLevel(
    FilterCourseByLevel event,
    Emitter<FilteredCourseState> emit,
  ) async {
    emit(FilteredCourseLoading());
    try {
      _currentLevel = event.level;
      final courses = await _filterCourses();
      emit(
        FilteredCoursesLoaded(
          courses,
          categoryId: _currentCategoryId,
          level: _currentLevel,
        ),
      );
    } catch (e) {
      emit(FilteredCourseError(e.toString()));
    }
  }


  void _onClearFilteredCourses(
    ClearFilteredCourses event,
    Emitter<FilteredCourseState> emit,
  ) async {
    emit(FilteredCourseLoading());
    try{
      //only clear level filter, maintain category filter
      _currentLevel = null;
      final courses = await _filterCourses();
      if(_currentCategoryId != null){
        emit(FilteredCoursesLoaded(
          courses,
          categoryId: _currentCategoryId,
        ));
      } else {
        emit(FilteredCourseInitial());
      }
    }catch (e) {
      emit(FilteredCourseError(e.toString()));
    }
  }

  Future<List<Course>> _filterCourses() async {
    // Get courses with category filter
    final courses = await _courseRepository.getCourse(
      categoryID: _currentCategoryId,
    );

    // apply level filter if set
    if (_currentLevel != null && _currentLevel != 'All Levels') {
      return courses.where((course) => course.level == _currentLevel).toList();
    }

    return courses;
  }
}
