import 'package:get/get.dart';
import '../../../data/repositories/organization_repository.dart';
import '../../../data/models/organization.dart';

class OrganizationDetailController extends GetxController {
  final OrganizationRepository _repository;
  final organization = Rxn<Organization>();
  final isLoading = false.obs;
  final error = ''.obs;

  OrganizationDetailController(this._repository);

  @override
  void onInit() {
    super.onInit();
    final orgId = int.tryParse(Get.parameters['id'] ?? '');
    if (orgId != null) {
      loadOrganization(orgId);
    }
  }

  Future<void> loadOrganization(int id) async {
    try {
      isLoading.value = true;
      error.value = '';
      organization.value = await _repository.getOrganizationById(id);
    } catch (e) {
      error.value = e.toString();
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

  Future<void> updateOrganization(
      int id, String name, String? description) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _repository.updateOrganization(id, name, description);
      await loadOrganization(id);
    } catch (e) {
      error.value = e.toString();
      throw e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteOrganization(int id) async {
    try {
      isLoading.value = true;
      error.value = '';
      await _repository.deleteOrganization(id);
    } catch (e) {
      error.value = e.toString();
      throw e;
    } finally {
      isLoading.value = false;
    }
  }
}
