import 'package:flutter/material.dart';
import 'package:e_learning/view/splash/splash_screen.dart'; // <-- Thêm import SplashScreen

class AppRoutes {
  static const String splash = '/splash';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}
