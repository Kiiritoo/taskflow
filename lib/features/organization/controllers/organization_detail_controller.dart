import 'package:get/get.dart';
import '../../../data/repositories/organization_repository.dart';
import '../../../data/models/organization.dart';

class OrganizationDetailController extends GetxController {
  final OrganizationRepository _repository;
  final organization = Rxn<Organization>();
  final isLoading = false.obs;
  final error = ''.obs;

  OrganizationDetailController(this._repository);

  Future<void> loadOrganization(int id) async {
    try {
      isLoading.value = true;
      error.value = '';
      organization.value = await _repository.getOrganizationById(id);
      if (organization.value == null) {
        error.value = 'Organization not found';
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to load organization details');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addMember(int userId, String role) async {
    // TODO: Implement add member functionality
  }

  Future<void> removeMember(int userId) async {
    // TODO: Implement remove member functionality
  }

  Future<void> updateMemberRole(int userId, String newRole) async {
    // TODO: Implement update member role functionality
  }
} 