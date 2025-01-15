import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/organization_controller.dart';
import '../../dashboard/views/dashboard_sidebar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class OrganizationListView extends GetView<OrganizationController> {
  const OrganizationListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const DashboardSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => controller.loadOrganizations(),
                    child: _buildOrganizationList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Organizations',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(FeatherIcons.refreshCw),
            onPressed: () => controller.loadOrganizations(),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            icon: const Icon(FeatherIcons.plus),
            label: const Text('Create Organization'),
            onPressed: () => _showCreateDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizationList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${controller.error.value}',
                style: const TextStyle(color: Colors.red),
              ),
              ElevatedButton.icon(
                icon: const Icon(FeatherIcons.refreshCw),
                label: const Text('Retry'),
                onPressed: controller.loadOrganizations,
              ),
            ],
          ),
        );
      }

      if (controller.organizations.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No organizations yet'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(FeatherIcons.plus),
                label: const Text('Create Organization'),
                onPressed: () => _showCreateDialog(),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.organizations.length,
        itemBuilder: (context, index) {
          final org = controller.organizations[index];
          return Card(
            child: ListTile(
              leading: const Icon(FeatherIcons.briefcase),
              title: Text(org.name),
              subtitle: Text(org.description ?? ''),
              trailing: const Icon(FeatherIcons.chevronRight),
              onTap: () => Get.toNamed('/organizations/${org.id}'),
            ),
          );
        },
      );
    });
  }

  void _showCreateDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Create Organization'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Organization Name',
                hintText: 'Enter organization name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Enter organization description',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                controller.createOrganization(
                  nameController.text.trim(),
                  descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text.trim(),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
