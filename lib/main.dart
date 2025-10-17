import 'package:e_learning/bloc/auth/auth_state.dart';
import 'package:e_learning/bloc/course/course_bloc.dart';
import 'package:e_learning/bloc/profile/profile_bloc.dart';
import 'package:e_learning/config/firebase_config.dart';
import 'package:e_learning/repositories/course_repository.dart';
import 'package:e_learning/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:e_learning/bloc/font/font_bloc.dart';
import 'package:e_learning/bloc/font/font_state.dart';
import 'package:e_learning/bloc/auth/auth_bloc.dart';
import 'package:e_learning/core/theme/app_theme.dart';
import 'package:e_learning/routes/app_routes.dart';
import 'package:e_learning/routes/route_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.init();
  await GetStorage.init();

  await StorageService.init();
  //await GetStorage().erase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FontBloc>(create: (context) => FontBloc()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc(
          authBloc: context.read<AuthBloc>(),
        )),
        BlocProvider<CourseBloc>(create: (context) => CourseBloc(
          authBloc: context.read<AuthBloc>(),
          courseRepository: CourseRepository(),
        )),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if(state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
               content: Text(state.error!),
               backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<FontBloc, FontState>(
          builder: (context, fontState) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'E - Learning',
              theme: AppTheme.getLightTheme(fontState),
              themeMode: ThemeMode.light,
              initialRoute: AppRoutes.splash,
              onGenerateRoute: AppRoutes.onGenerateRoute,
              getPages: AppPages.pages,
            );
          },
        ),
      ),
    );
  }
}
