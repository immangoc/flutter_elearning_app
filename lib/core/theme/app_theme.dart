import 'package:e_learning/bloc/font/font_state.dart';
import 'package:e_learning/core/theme/app_color.dart';
import 'package:e_learning/core/theme/app_typography.dart';
import 'package:e_learning/services/font_services.dart';
import 'package:flutter/material.dart';

class AppTheme{
  static ThemeData getLightTheme(FontState fontState){
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        background: AppColors.lightBackground,
        surface: AppColors.lightSurface
      ),

      textTheme: FontService.getCustomTextTheme(
        AppTypography.lightTextTheme,
        fontState.fontScale,
        fontState.fontFamily,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.lightDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.lightDivider),
        ),
      ),
    );
  }
}