import 'package:hive_flutter/hive_flutter.dart';
import 'package:x_kode/app/shared/helpers/hive_config.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class ProjectModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String path;

  ProjectModel({
    required this.name,
    required this.path,
  });

  ProjectModel copyWith({
    String? name,
    String? path,
  }) {
    return ProjectModel(
      name: name ?? this.name,
      path: path ?? this.path,
    );
  }

  static Box<ProjectModel> get cacheBox => HiveConfig.box<ProjectModel>();

  static Future<void> saveProject(ProjectModel project) async {
    await cacheBox.put(project.name, project);
  }

  static Future<void> deleteProject(ProjectModel project) async {
    await cacheBox.delete(project.name);
  }

  static Future<ProjectModel?> getProject(String name) async {
    return cacheBox.get(name);
  }

  static Future<List<ProjectModel>> getProjects() async {
    return cacheBox.values.toList();
  }

  static Future<void> clearProjects() async {
    await cacheBox.clear();
  }
}
