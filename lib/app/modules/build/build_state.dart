sealed class BuildState {}

class BuildStateStart extends BuildState {}

class BuildStateLoadingBuild extends BuildState {}

class BuildStateLoadingSend extends BuildState {}

class BuildStateSuccess extends BuildState {}

class BuildStateError extends BuildState {
  final String message;

  BuildStateError(this.message);
}
