import 'package:e_learning/main_screen.dart';
import 'package:e_learning/models/quiz_attempt.dart';
import 'package:e_learning/view/auth/forgot_password_screen.dart';
import 'package:e_learning/view/auth/login_screen.dart';
import 'package:e_learning/view/chat/chat_list_screen.dart';
import 'package:e_learning/view/course/analytics_dashboard/analytics_dashboard_screen.dart';
import 'package:e_learning/view/course/course_list/course_list_screen.dart';
import 'package:e_learning/view/course/lesson_screen/lesson_screen.dart';
import 'package:e_learning/view/course/payment/payment_screen.dart';
import 'package:e_learning/view/home/home_screen.dart';
import 'package:e_learning/view/onboarding/onboarding_screen.dart';
import 'package:e_learning/view/privacy_&_terms_conditions/privacy_policy_screen.dart';
import 'package:e_learning/view/privacy_&_terms_conditions/terms_conditions_screen.dart';
import 'package:e_learning/view/profile/edit_profile_screen.dart';
import 'package:e_learning/view/profile/profile_screen.dart';
import 'package:e_learning/view/quiz/quiz_attempt/quiz_attempt_screen.dart';
import 'package:e_learning/view/quiz/quiz_list/quiz_list_screen.dart';
import 'package:e_learning/view/quiz/quiz_result/quiz_result_screen.dart';
import 'package:e_learning/view/teacher/create_course/create_course_screen.dart';
import 'package:e_learning/view/teacher/my_courses/my_courses_screen.dart';
import 'package:e_learning/view/teacher/student_progress/student_progress_screen.dart';
import 'package:e_learning/view/teacher/teacher_analytics/teacher_analytics_screen.dart';
import 'package:e_learning/view/teacher/teacher_home_screen.dart';
import 'package:get/get.dart';
import 'package:e_learning/routes/app_routes.dart';
import 'package:e_learning/view/splash/splash_screen.dart';

import '../models/quiz.dart';
import '../view/auth/register_screen.dart';
import '../view/course/course_detail/course_detail_screen.dart';
import '../view/notifications/notifications_screen.dart';
import '../view/settings/settings_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),

    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),

    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),

    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),

    GetPage(name: AppRoutes.main, page: () => const MainScreen()),

    GetPage(
      name: AppRoutes.courseList,
      page: () => CourseListScreen(
        categoryId: Get.arguments['category'] as String?,
        categoryName: Get.arguments['categoryName'] as String?,
      ),
    ),

    GetPage(name: AppRoutes.quizList, page: () => const QuizListScreen()),

    GetPage(
      name: '/quiz/:id',
      page: () => QuizAttemptScreen(quizId: Get.parameters['id'] ?? ''),
    ),

    GetPage(
      name: '/quiz/result',
      page: () => QuizResultScreen(
        attempt: Get.arguments['attempt'] as QuizAttempt,
        quiz: Get.arguments['quiz'] as Quiz,
      ),
    ),

    GetPage(
      name: AppRoutes.lesson,
      page: () => LessonScreen(lessonId: Get.parameters['id'] ?? ''),
    ),

    GetPage(
      name: AppRoutes.payment,
      page: () => PaymentScreen(
        courseId: Get.arguments['courseId'] as String,
        courseName: Get.arguments['courseName'] as String,
        price: Get.arguments['price'] as double,
      ),
    ),

    GetPage(
      name: '/course/:id',
      page: () => CourseDetailScreen(courseId: Get.parameters['id'] ?? ''),
    ),

    GetPage(name: AppRoutes.profile, page: () => const ProfileScreen()),

    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileScreen()),

    GetPage(name: AppRoutes.analytics, page: () => AnalyticsDashboardScreen()),

    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
    ),

    GetPage(name: AppRoutes.setting, page: () => const SettingsScreen()),

    GetPage(name: AppRoutes.privacyPolicy, page: () => const PrivacyPolicyScreen()),

    GetPage(name: AppRoutes.termsConditions, page: () => const TermsConditionsScreen()),

    GetPage(name: AppRoutes.home, page: () => HomeScreen()),

    GetPage(name: AppRoutes.teacherHome, page: () => const TeacherHomeScreen()),

    GetPage(name: AppRoutes.myCourses, page: () => const MyCoursesScreen()),

    GetPage(
      name: AppRoutes.studentProgress,
      page: () => const StudentProgressScreen(),
    ),

    GetPage(
      name: AppRoutes.createCourse,
      page: () => const CreateCourseScreen(),
    ),

    GetPage(
      name: AppRoutes.teacherAnalytics,
      page: () => const TeacherAnalyticsScreen(),
    ),

    GetPage(name: AppRoutes.teacherChats, page: () => const ChatListScreen()),
  ];
}
