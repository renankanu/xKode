import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_kode/app/modules/home/home_view.dart';
import 'package:x_kode/app/shared/helpers/hive_config.dart';

import 'app/modules/home/home_controller.dart';
import 'app/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeController(),
          ),
        ],
        child: const HomeView(),
      ),
    );
  }
}
