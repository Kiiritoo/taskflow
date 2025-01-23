import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/team.dart';
import '../../../data/repositories/team_repository.dart';

class TeamController extends GetxController {
  final TeamRepository _repository;
  final currentTeam = Rxn<Team>();
  final isLoading = false.obs;
  final error = ''.obs;
  final teams = <Team>[].obs;
  final currentOrganizationId = RxnInt();

  TeamController(this._repository);

  @override
  void onInit() {
    super.onInit();
    _loadTeamFromRoute();

    // Add this to load organization teams
    final orgId = int.tryParse(Get.parameters['organizationId'] ?? '');
    if (orgId != null) {
      setCurrentOrganization(orgId);
    }
  }

  void _loadTeamFromRoute() {
    final teamId = int.tryParse(Get.parameters['id'] ?? '');
    if (teamId != null) {
      loadTeam(teamId);
    }
  }

  Future<void> loadTeam(int id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final team = await _repository.getTeamById(id);
      if (team != null) {
        currentTeam.value = team;
      } else {
        error.value = 'Team not found';
        Get.snackbar(
          'Error',
          'Team not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load team: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setCurrentOrganization(int orgId) {
    currentOrganizationId.value = orgId;
    loadTeams();
  }

  Future<void> loadTeams() async {
    try {
      isLoading.value = true;
      error.value = '';
      if (currentOrganizationId.value != null) {
        final loadedTeams = await _repository
            .getTeamsByOrganization(currentOrganizationId.value!);
        teams.value = loadedTeams;
      } else {
        teams.clear();
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load teams: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createTeam(
      String name, String? description, int organizationId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final team =
          await _repository.createTeam(name, description, organizationId);
      teams.add(team);

      // Refresh teams list for the current organization
      if (currentOrganizationId.value == organizationId) {
        await loadTeams();
      }

      Get.back();
      Get.snackbar(
        'Success',
        'Team created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create team: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }
}
