import '../services/api_service.dart';
import '../models/team.dart';
import '../../core/constants/api_constants.dart';
import 'dart:convert';

class TeamRepository {
  final ApiService _apiService;

  TeamRepository(this._apiService);

  Future<List<Team>> getTeams() async {
    try {
      final response = await _apiService.get('/teams');
      if (response.statusCode != 200) {
        throw Exception('Failed to load teams: ${response.body}');
      }
      
      final data = jsonDecode(response.body);
      return (data as List).map((json) => Team.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load teams: $e');
    }
  }

  Future<Team> createTeam(String name, String? description, int organizationId) async {
    try {
      final response = await _apiService.post(
        '/teams',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description ?? '',
          'organization_id': organizationId,
        }),
      );
      
      if (response.statusCode != 201) {
        throw Exception('Failed to create team: ${response.body}');
      }

      final data = jsonDecode(response.body);
      return Team.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create team: $e');
    }
  }

  Future<void> deleteTeam(int id) async {
    try {
      await _apiService.delete('${ApiConstants.teams}/$id');
    } catch (e) {
      throw Exception('Failed to delete team: $e');
    }
  }
}
