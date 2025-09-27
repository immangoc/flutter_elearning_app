import 'package:e_learning/view/auth/forgot_password_screen.dart';
import 'package:e_learning/view/auth/login_screen.dart';
import 'package:e_learning/view/home/home_screen.dart';
import 'package:e_learning/view/onboarding/onboarding_screen.dart';
import 'package:e_learning/view/teacher/teacher_home_screen.dart';
import 'package:get/get.dart';
import 'package:e_learning/routes/app_routes.dart';
import 'package:e_learning/view/splash/splash_screen.dart';

import '../view/auth/register_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),

    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),

    GetPage(
      name: AppRoutes.teacherHome,
      page: () => const TeacherHomeScreen(),
    ),
  ];
}
