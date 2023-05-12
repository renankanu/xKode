import 'package:hive_flutter/hive_flutter.dart';

import '../../model/project_model.dart';

class HiveConfig {
  HiveConfig._();

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ProjectModelAdapter());

    await openBox<ProjectModel>();
  }

  static Future<void> openBox<T>() async {
    await Hive.openBox<T>(T.toString());
  }

  static Box<T> box<T>() {
    return Hive.box<T>(T.toString());
  }
}
