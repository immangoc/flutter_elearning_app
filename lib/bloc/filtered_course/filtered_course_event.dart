abstract class FilteredCourseEvent {}

class FilterCoursesByCategory extends FilteredCourseEvent {
  final String categoryId;

  FilterCoursesByCategory(this.categoryId);
}

class FilterCourseByLevel extends FilteredCourseEvent {
  final String level;

  FilterCourseByLevel(this.level);
}

class ClearFilteredCourses extends FilteredCourseEvent {}
