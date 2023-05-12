import 'package:flutter/material.dart';
import 'package:x_kode/app/shared/app_colors.dart';

class AppTheme {
  AppTheme._();

  static final theme = ThemeData.dark().copyWith(
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.chestnut,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.chestnut,
      selectionColor: AppColors.chestnut,
      selectionHandleColor: AppColors.chestnut,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: AppColors.mineShaft,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
        gapPadding: 0,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
        gapPadding: 0,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
        ),
        gapPadding: 0,
      ),
    ),
  );
}
