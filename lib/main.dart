import 'package:flutter/material.dart';
import 'package:x_kode/app/modules/home/home_view.dart';

import 'app/shared/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: const HomeView(),
    );
  }
}
