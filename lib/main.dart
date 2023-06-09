import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:x_kode/app/modules/build/build_controller.dart';
import 'package:x_kode/app/routes/app_routes.dart';
import 'package:x_kode/app/shared/helpers/hive_config.dart';

import 'app/modules/home/home_controller.dart';
import 'app/shared/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.init();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeController(),
        ),
        BlocProvider(
          create: (context) => BuildController(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: AppTheme.theme,
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
