import 'package:get/get.dart';
import '../../../data/repositories/organization_repository.dart';
import '../../../data/models/organization.dart';
import 'package:flutter/material.dart';
import '../controllers/organization_controller.dart';

class OrganizationDetailController extends GetxController {
  final OrganizationRepository _repository;
  final organization = Rxn<Organization>();
  final isLoading = false.obs;
  final error = ''.obs;

  OrganizationDetailController(this._repository);

  @override
  void onInit() {
    super.onInit();
    // Load organization data when controller initializes
    _loadOrganizationFromRoute();
  }

  void _loadOrganizationFromRoute() {
    final orgId = int.tryParse(Get.parameters['id'] ?? '');
    if (orgId != null) {
      loadOrganization(orgId);
    } else {
      error.value = 'Invalid organization ID';
    }
  }

  Future<void> loadOrganization(int id) async {
    try {
      isLoading.value = true;
      error.value = '';

      final org = await _repository.getOrganizationById(id);
      if (org != null) {
        organization.value = org;
      } else {
        error.value = 'Organization not found';
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load organization: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
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

      // Make sure OrganizationController is registered before finding it
      if (Get.isRegistered<OrganizationController>()) {
        final organizationController = Get.find<OrganizationController>();
        await organizationController.loadOrganizations();
      }

      Get.offAllNamed('/organizations');
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to delete organization: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }
}
