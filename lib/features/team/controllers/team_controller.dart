import 'package:get/get.dart';
import '../../../data/repositories/team_repository.dart';
import '../../../data/models/team.dart';

class TeamController extends GetxController {
  final TeamRepository _repository;
  final teams = <Team>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  TeamController(this._repository);

  @override
  void onInit() {
    super.onInit();
    loadTeams();
  }

  Future<void> loadTeams() async {
    try {
      isLoading.value = true;
      error.value = '';
      teams.value = await _repository.getTeams();
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

  Future<void> deleteTeam(int id) async {
    try {
      await _repository.deleteTeam(id);
      teams.removeWhere((team) => team.id == id);
      Get.snackbar('Success', 'Team deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete team');
    }
  }
} 