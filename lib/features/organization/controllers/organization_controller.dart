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

      // Check for duplicate name
      final existingOrgs = await _repository.getOrganizations();
      if (existingOrgs
          .any((org) => org.name.toLowerCase() == name.toLowerCase())) {
        throw Exception('An organization with this name already exists');
      }

      // Create the organization
      await _repository.createOrganization(
          name, description ?? 'No description');

      // Close dialog and refresh list
      Get.back();
      await loadOrganizations();

      Get.snackbar(
        'Success',
        'Organization created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteOrganization(int id) async {
    try {
      isLoading.value = true;
      error.value = '';

      await _repository.deleteOrganization(id);
      await loadOrganizations(); // Refresh immediately after deletion

      // Navigate back if we're in detail view
      if (Get.currentRoute.contains('/organizations/')) {
        Get.offAllNamed('/organizations'); // Use offAllNamed to clear the stack
      }

      Get.snackbar(
        'Success',
        'Organization deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
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
