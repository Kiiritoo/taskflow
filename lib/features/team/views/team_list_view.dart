import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../controllers/team_controller.dart';
import '../../dashboard/views/dashboard_sidebar.dart';
import '../../dashboard/views/components/navbar.dart';

class TeamListView extends GetView<TeamController> {
  const TeamListView({super.key});

  void _showCreateDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final organizationId = int.tryParse(Get.parameters['organizationId'] ?? '');

    if (organizationId == null) {
      Get.snackbar('Error', 'Organization ID is required');
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Create Team'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Team Name',
                  hintText: 'Enter team name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a team name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter team description',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await controller.createTeam(
                    nameController.text.trim(),
                    descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text.trim(),
                    organizationId,
                  );
                  Get.back();
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to create team: ${e.toString()}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red[100],
                    colorText: Colors.red[900],
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const DashboardSidebar(),
          Expanded(
            child: Column(
              children: [
                const DashboardNavbar(),
                Container(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Teams',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(FeatherIcons.plus),
                        onPressed: _showCreateDialog,
                        tooltip: 'Create Team',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildTeamList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamList() {
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
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => controller.loadTeams(),
                icon: const Icon(FeatherIcons.refreshCw),
                label: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.teams.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FeatherIcons.users,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'No teams found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.teams.length,
        itemBuilder: (context, index) {
          final team = controller.teams[index];
          return Card(
            child: ListTile(
              leading: const Icon(FeatherIcons.users),
              title: Text(team.name),
              subtitle: Text(team.description ?? ''),
              trailing: const Icon(FeatherIcons.chevronRight),
              onTap: () => Get.toNamed('/teams/${team.id}'),
            ),
          );
        },
      );
    });
  }
}
