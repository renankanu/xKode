import '../../model/project_model.dart';

sealed class HomeState {}

class HomeStateStart extends HomeState {}

class HomeStateLoading extends HomeState {}

class HomeStateSuccess extends HomeState {
  final List<ProjectModel> projects;

  HomeStateSuccess(this.projects);
}

class HomeStateError extends HomeState {
  final String message;

  HomeStateError(this.message);
}
