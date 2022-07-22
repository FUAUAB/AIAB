import 'package:equatable/equatable.dart';
import 'package:mavis_api_client/api.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectsLoaded extends ProjectState {
  final List<Project> projects;

  ProjectsLoaded(this.projects);

  @override
  List<Object> get props => [this.projects];
}

class ProjectsByCustomerLoaded extends ProjectState {
  final List<Project> projects;

  ProjectsByCustomerLoaded(this.projects);

  @override
  List<Object> get props => [this.projects];
}

class ProjectError extends ProjectState {
  final String errorMessage;

  ProjectError(this.errorMessage);

  @override
  List<Object> get props => [this.errorMessage];
}
