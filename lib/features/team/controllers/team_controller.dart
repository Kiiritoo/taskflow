import 'package:get/get.dart';
import '../../../data/repositories/team_repository.dart';
import '../../../data/models/team.dart';

class TeamController extends GetxController {
  final TeamRepository _repository;
  final teams = <Team>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  TeamController(this._repository);

  Future<void> loadTeams(int organizationId) async {
    try {
      isLoading.value = true;
      error.value = '';
      teams.value = await _repository.getTeamsByOrganization(organizationId);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTeam(String name, String? description, int organizationId) async {
    try {
      isLoading.value = true;
      error.value = '';
      final team = await _repository.createTeam(name, description, organizationId);
      teams.add(team);
      Get.back();
      Get.snackbar('Success', 'Team created successfully');
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to create team');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTeamMember(int teamId, int userId, String role) async {
    try {
      await _repository.addTeamMember(teamId, userId, role);
      await loadTeams(teams.firstWhere((team) => team.id == teamId).organizationId);
      Get.snackbar('Success', 'Member added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add member');
    }
  }

  void handleError(dynamic error) {
    isLoading.value = false;
    error.value = error.toString();
    Get.snackbar(
      'Error',
      'Failed to load teams: ${error.toString()}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
} 