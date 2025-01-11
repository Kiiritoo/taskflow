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

  Future<void> loadOrganizations() async {
    try {
      isLoading.value = true;
      error.value = '';
      final orgs = await _repository.getOrganizations();
      organizations.assignAll(orgs);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to load organizations');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createOrganization(String name, String? description) async {
    try {
      isLoading.value = true;
      error.value = '';
      final organization = await _repository.createOrganization(
        name, 
        description ?? 'No description'
      );
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
      await _repository.deleteOrganization(id);
      organizations.removeWhere((org) => org.id == id);
      Get.snackbar('Success', 'Organization deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete organization');
    }
  }
}
