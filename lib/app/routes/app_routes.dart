import 'package:go_router/go_router.dart';
import 'package:x_kode/app/modules/home/home_view.dart';

import '../modules/build/build_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String _build = 'build';

  static String get build => '/$_build';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeView(),
        routes: [
          GoRoute(
            path: '$_build/:projectName',
            builder: (context, state) => BuildView(
              projectName: state.pathParameters['projectName']!,
            ),
          ),
        ],
      ),
    ],
  );
}
