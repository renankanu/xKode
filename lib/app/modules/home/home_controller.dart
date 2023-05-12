import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_kode/app/modules/home/home_state.dart';

import '../../model/project_model.dart';

class HomeController extends Cubit<HomeState> {
  HomeController() : super(HomeStateStart());

  Future<void> getProjects() async {
    emit(HomeStateLoading());
    try {
      final projects = await ProjectModel.getProjects();
      if (projects.isEmpty) {
        emit(HomeStateEmpty());
        return;
      }
      emit(HomeStateSuccess(projects));
    } catch (e) {
      emit(HomeStateError(e.toString()));
    }
  }

  Future<void> saveProject(ProjectModel project) async {
    emit(HomeStateLoading());
    final cacheProject = await ProjectModel.getProject(project.name);
    if (cacheProject != null) {
      emit(HomeStateError('Project already exists'));
      return;
    }
    try {
      await ProjectModel.saveProject(project);
      emit(HomeStateSuccess(await ProjectModel.getProjects()));
    } catch (e) {
      emit(HomeStateError(e.toString()));
    }
  }
}
