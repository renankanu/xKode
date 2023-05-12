import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x_kode/app/modules/home/home_state.dart';

import '../../model/project_model.dart';

class HomeController extends Cubit<HomeState> {
  HomeController() : super(HomeStateStart());

  Future<void> getProjects() async {
    emit(HomeStateLoading());
    try {
      final projects = await ProjectModel.getProjects();
      emit(HomeStateSuccess(projects));
    } catch (e) {
      emit(HomeStateError(e.toString()));
    }
  }
}
