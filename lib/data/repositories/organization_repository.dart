import '../services/api_service.dart';
import '../models/organization.dart';
import '../../core/constants/api_constants.dart';
import 'dart:convert';

class OrganizationRepository {
  final ApiService _apiService;

  OrganizationRepository(this._apiService);

  Future<List<Organization>> getOrganizations() async {
    try {
      final response = await _apiService.get('/organizations');
      final data = jsonDecode(response.body);
      return (data as List).map((json) => Organization.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load organizations: $e');
    }
  }

  Future<Organization> createOrganization(String name, String? description) async {
    try {
      final response = await _apiService.post(
        '/organizations',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description ?? 'No description',
        }),
      );
      
      if (response.statusCode != 201) {
        throw Exception('Failed to create organization: ${response.body}');
      }

      final data = jsonDecode(response.body);
      return Organization.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create organization: $e');
    }
  }

  Future<Organization> updateOrganization(int id, {
    required String name,
    String? description,
  }) async {
    try {
      final response = await _apiService.put(
        '/organizations/$id',
        body: jsonEncode({
          'name': name,
          'description': description ?? '',
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to update organization: ${response.body}');
      }

      final data = jsonDecode(response.body);
      return Organization.fromJson(data);
    } catch (e) {
      throw Exception('Failed to update organization: $e');
    }
  }

  Future<void> deleteOrganization(int id) async {
    try {
      await _apiService.delete('${ApiConstants.organizations}/$id');
    } catch (e) {
      throw Exception('Failed to delete organization: $e');
    }
  }
}
