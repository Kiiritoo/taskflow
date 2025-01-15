import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/organization_repository.dart';
import '../../../data/models/organization.dart';

class OrganizationController extends GetxController {
  final OrganizationRepository _repository;
  final organizations = <Organization>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  OrganizationController(this._repository);

  @override
  void onInit() {
    super.onInit();
    loadOrganizations();
    // Listen to route changes
    ever(Get.routing.current.obs, (route) {
      if (route == '/organizations') {
        loadOrganizations();
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    // Listen to route changes
    ever(Get.routing.current.obs, (route) {
      if (route == '/organizations') {
        loadOrganizations();
      }
    });
  }

  Future<void> loadOrganizations() async {
    try {
      isLoading.value = true;
      error.value = '';
      organizations.value = await _repository.getOrganizations();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load organizations: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createOrganization(String name, String? description) async {
    try {
      isLoading.value = true;
      error.value = '';
      final organization = await _repository.createOrganization(
          name, description ?? 'No description');
      organizations.add(organization);
      Get.back();
      Get.snackbar('Success', 'Organization created successfully');
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to create organization');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteOrganization(int id) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Delete from repository
      await _repository.deleteOrganization(id);

      // Remove from local list
      organizations.removeWhere((org) => org.id == id);

      // Force refresh the list to ensure UI is updated
      organizations.refresh();

      Get.snackbar(
        'Success',
        'Organization deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back only if we're in detail view
      if (Get.currentRoute.contains('/organizations/')) {
        Get.back();
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to delete organization: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }
}
