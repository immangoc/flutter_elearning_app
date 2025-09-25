import 'package:e_learning/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:e_learning/bloc/font/font_bloc.dart';
import 'package:e_learning/bloc/font/font_state.dart';
import 'package:e_learning/bloc/auth/auth_bloc.dart';   // 👈 THÊM: đường dẫn tới AuthBloc của bạn
import 'package:e_learning/core/theme/app_theme.dart';
import 'package:e_learning/routes/app_routes.dart';
import 'package:e_learning/routes/route_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();



  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FontBloc>(
          create: (context) => FontBloc(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
      ],
      child: BlocBuilder<FontBloc, FontState>(
        builder: (context, fontState) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E - Learning App',
            theme: AppTheme.getLightTheme(fontState),
            themeMode: ThemeMode.light,
            initialRoute: AppRoutes.splash,
            getPages: AppPages.pages,
          );
        },
      ),
    );
  }
}
