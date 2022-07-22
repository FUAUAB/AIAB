import 'package:bloc/bloc.dart';
import 'package:work_order_app/cubit/project/project_state.dart';
import 'package:work_order_app/locator.dart';

import '../../data/services/project_service.dart';

class ProjectCubit extends Cubit<ProjectState> {
  var _projectService = locator<ProjectService>();

  ProjectCubit() : super(ProjectInitial());

  /// Get a list of all projects.

  Future<void> getProjects() async {
    try {
      emit(ProjectLoading());
      final projects = await _projectService.getProjects();
      emit(ProjectsLoaded(projects!));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }

  Future<void> getProjectByCustomerId(int customerId) async {
    try {
      emit(ProjectLoading());
      final projects = await _projectService.getProjectByCustomerId(customerId);
      emit(ProjectsByCustomerLoaded(projects!));
    } catch (e) {
      emit(ProjectError(e.toString()));
    }
  }
}
