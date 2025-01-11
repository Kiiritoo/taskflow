import '../services/api_service.dart';
import '../models/task.dart';
import '../../core/constants/api_constants.dart';

class TaskRepository {
  final ApiService _apiService = ApiService();

  Future<List<Task>> getTasks({int? projectId}) async {
    try {
      String endpoint = ApiConstants.tasks;
      if (projectId != null) {
        endpoint += '?project_id=$projectId';
      }
      
      final response = await _apiService.get(endpoint);
      return (response['data'] as List)
          .map((json) => Task.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<Task> createTask(String title, String? description, int projectId,
      int? assignedTo, DateTime? dueDate) async {
    try {
      final response = await _apiService.post(
        ApiConstants.tasks,
        {
          'title': title,
          'description': description,
          'project_id': projectId,
          'assigned_to': assignedTo,
          'due_date': dueDate?.toIso8601String(),
        },
      );
      return Task.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  Future<Task> updateTask(int id, String title, String? description,
      String status, int? assignedTo, DateTime? dueDate) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.tasks}/$id',
        {
          'title': title,
          'description': description,
          'status': status,
          'assigned_to': assignedTo,
          'due_date': dueDate?.toIso8601String(),
        },
      );
      return Task.fromJson(response['data']);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _apiService.delete('${ApiConstants.tasks}/$id');
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}
