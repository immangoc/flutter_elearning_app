import 'package:get/get.dart';
import 'package:e_learning/routes/app_routes.dart';           // ✅ import AppRoutes
import 'package:e_learning/view/splash/splash_screen.dart'; // ✅ import SplashScreen

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    // Có thể thêm các trang khác ở đây:
    // GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
  ];
}
