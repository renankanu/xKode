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
  );
}
