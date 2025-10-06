import 'package:e_learning/main_screen.dart';
import 'package:e_learning/view/auth/forgot_password_screen.dart';
import 'package:e_learning/view/auth/login_screen.dart';
import 'package:e_learning/view/course/course_list/course_list_screen.dart';
import 'package:e_learning/view/course/lesson_screen/lesson_screen.dart';
import 'package:e_learning/view/course/payment/payment_screen.dart';
import 'package:e_learning/view/home/home_screen.dart';
import 'package:e_learning/view/onboarding/onboarding_screen.dart';
import 'package:e_learning/view/profile/profile_screen.dart';
import 'package:e_learning/view/quiz/quiz_list/quiz_list_screen.dart';
import 'package:e_learning/view/teacher/teacher_home_screen.dart';
import 'package:get/get.dart';
import 'package:e_learning/routes/app_routes.dart';
import 'package:e_learning/view/splash/splash_screen.dart';

import '../view/auth/register_screen.dart';
import '../view/course/course_detail/course_detail_screen.dart';

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

    GetPage(name: AppRoutes.home, page: () => HomeScreen()),

    GetPage(name: AppRoutes.teacherHome, page: () => const TeacherHomeScreen()),
  ];
}
