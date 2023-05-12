import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:x_kode/app/model/project_model.dart';

import 'build_state.dart';

class BuildController extends Cubit<BuildState> {
  BuildController() : super(BuildStateStart());

  Future<void> buildProject(String projectName) async {
    emit(BuildStateLoadingBuild());
    try {
      final cacheProject = await ProjectModel.getProject(projectName);
      if (cacheProject == null) {
        emit(BuildStateError('Project not found'));
        return;
      }
      try {
        final result = await Process.run(
          'sh',
          ['-c', 'cd ${cacheProject.path} && flutter build ipa'],
        );
        log(result.stdout.toString());
        log(result.stderr.toString());
        // _sendIpaToApple(cacheProject);
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
}
