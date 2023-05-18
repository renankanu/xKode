import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:x_kode/app/model/project_model.dart';

import 'build_state.dart';

class BuildController extends Cubit<BuildState> {
  BuildController() : super(BuildStateStart());

  Future<void> buildProject({
    required String projectName,
    required String version,
    required String build,
  }) async {
    emit(BuildStateLoadingBuild());
    try {
      final cacheProject = await ProjectModel.getProject(projectName);
      if (cacheProject == null) {
        emit(BuildStateError('Project not found'));
        return;
      }

      await incrementIosVersion(
        path: cacheProject.path,
        version: version,
        build: build,
      );

      final path = cacheProject.path.replaceAll(' ', r'\ ');
      try {
        final result = await Process.run(
          'sh',
          ['-c', 'cd $path && flutter build ipa'],
        );
        log(result.stdout.toString());
        log(result.stderr.toString());
        _sendIpaToApple(cacheProject);
      } on Exception {
        emit(BuildStateError('Error'));
      }
    } catch (e) {
      emit(BuildStateError(e.toString()));
    }
  }

  Future<void> _sendIpaToApple(ProjectModel project) async {
    emit(BuildStateLoadingSend());
    final apiKey = dotenv.env['API_KEY'];
    final apiIssuer = dotenv.env['API_ISSUER'];
    final command =
        'xcrun altool --upload-app --type ios -f ${project.path}/build/ios/ipa/*.ipa --apiKey $apiKey --apiIssuer $apiIssuer';
    try {
      final result = await Process.run(
        'sh',
        ['-c', command],
      );
      log(result.stdout.toString());
      log(result.stderr.toString());
      emit(BuildStateSuccess());
    } on Exception {
      emit(BuildStateError('Error'));
    }
  }

  void backPressed() {
    emit(BuildStateStart());
  }

  Future<(String?, String?)> getVersion(String projectName) async {
    emit(BuildStateLoadingBuild());
    try {
      final cacheProject = await ProjectModel.getProject(projectName);
      if (cacheProject == null) {
        emit(BuildStateError('Project not found'));
        return (null, null);
      }
      final pubspec = File('${cacheProject.path}/pubspec.yaml');
      final lines = pubspec.readAsLinesSync();
      final version =
          lines.firstWhere((element) => element.contains('version'));
      final fullVersion = version.split(':').last.trim();
      final versionNumber = fullVersion.split('+').first.trim();
      final buildNumber = fullVersion.split('+').last.trim();
      emit(BuildStateStart());
      return (versionNumber, buildNumber);
    } catch (e) {
      emit(BuildStateError(e.toString()));
    }
    return (null, null);
  }

  Future<void> incrementIosVersion({
    required String path,
    required String version,
    required String build,
  }) async {
    await _incrementRunner(
      path,
      version,
      build,
    );
    await _incrementPubspec(
      path: path,
      version: version,
      build: build,
    );
  }

  Future<void> _incrementRunner(
    String path,
    String version,
    String build,
  ) async {
    try {
      final projectPbxproj = File(
        '$path/ios/Runner.xcodeproj/project.pbxproj',
      );
      final lines = projectPbxproj.readAsLinesSync();
      final newLines = <String>[];
      for (final line in lines) {
        if (line.contains('MARKETING_VERSION')) {
          newLines.add('\t\t\t\tMARKETING_VERSION = $version;');
        } else if (line.contains('CURRENT_PROJECT_VERSION')) {
          newLines.add('\t\t\t\tCURRENT_PROJECT_VERSION = $build;');
        } else {
          newLines.add(line);
        }
      }
      await projectPbxproj.writeAsString(newLines.join('\n'));
    } catch (e) {
      emit(BuildStateError(e.toString()));
    }
  }

  Future<void> _incrementPubspec({
    required String path,
    required String version,
    required String build,
  }) async {
    try {
      final pubspec = File('$path/pubspec.yaml');
      final lines = pubspec.readAsLinesSync();
      final newLines = <String>[];
      for (final line in lines) {
        if (line.contains('version')) {
          newLines.add('version: $version+$build');
        } else {
          newLines.add(line);
        }
      }
      await pubspec.writeAsString(newLines.join('\n'));
    } catch (e) {
      emit(BuildStateError(e.toString()));
    }
  }
}
