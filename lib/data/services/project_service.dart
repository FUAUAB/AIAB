import 'package:mavis_api_client/api.dart';

import '../../core/api/client.dart';

class ProjectService {
  final Client client;

  ProjectService({required this.client});

  /// Get a list of all projects.
  Future<List<Project>?> getProjects() async {
    try {
      List<Project> list = await client.projectApi.getAllProjects();
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Project>?> getProjectByCustomerId(int customerId) async {
    try {
      List<Project> list =
          await client.projectApi.getProjectsForCustomer(customerId);
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
