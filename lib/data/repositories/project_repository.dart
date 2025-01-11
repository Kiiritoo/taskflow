import '../services/api_service.dart';
import '../models/project.dart';
import '../../core/constants/api_constants.dart';

class ProjectRepository {
  final ApiService _apiService = ApiService();

  Future<List<Project>> getProjects({int? organizationId}) async {
    try {
      String endpoint = ApiConstants.projects;
      if (organizationId != null) {
        endpoint += '?organization_id=$organizationId';
      }
      
      final response = await _apiService.get(endpoint);
      return (response['data'] as List)
          .map((json) => Project.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load projects: $e');
    }
  }

  Future<Project> createProject(String name, String? description, int organizationId) async {
    try {
      final response = await _apiService.post(
        ApiConstants.projects,
        {
          'name': name,
          'description': description,
          'organization_id': organizationId,
        },
      );
      return Project.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  Future<Project> updateProject(
      int id, String name, String? description, String status) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.projects}/$id',
        {
          'name': name,
          'description': description,
          'status': status,
        },
      );
      return Project.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  Future<void> deleteProject(int id) async {
    try {
      await _apiService.delete('${ApiConstants.projects}/$id');
    } catch (e) {
      throw Exception('Failed to delete project: $e');
    }
  }
}
