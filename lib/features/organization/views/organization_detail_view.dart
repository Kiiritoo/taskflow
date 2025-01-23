import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/organization_detail_controller.dart';
import '../../dashboard/views/dashboard_sidebar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../../data/models/organization.dart';
import '../../../features/team/controllers/team_controller.dart';
import '../../dashboard/views/components/navbar.dart';

class OrganizationDetailView extends GetView<OrganizationDetailController> {
  const OrganizationDetailView({Key? key}) : super(key: key);

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
                _buildAppBar(context),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.error.value.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              FeatherIcons.alertTriangle,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Something went wrong',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.error.value,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.red[700],
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              icon: const Icon(FeatherIcons.refreshCw),
                              label: const Text('Try Again'),
                              onPressed: () {
                                final orgId =
                                    int.tryParse(Get.parameters['id'] ?? '');
                                if (orgId != null) {
                                  controller.loadOrganization(orgId);
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    final org = controller.organization.value;
                    if (org == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              FeatherIcons.alertCircle,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Organization Not Found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'The requested organization could not be found.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              icon: const Icon(FeatherIcons.arrowLeft),
                              label: const Text('Go Back'),
                              onPressed: () {
                                Get.offNamed('/organizations');
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      child: _buildContent(context),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
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
          IconButton(
            icon: const Icon(FeatherIcons.arrowLeft),
            onPressed: () {
              Get.offNamed('/organizations');
            },
            tooltip: 'Back to Organizations',
          ),
          const SizedBox(width: 16),
          Obx(() {
            final org = controller.organization.value;
            return Text(
              org?.name ?? 'Organization Details',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final org = controller.organization.value;
    if (org == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                org.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              PopupMenuButton(
                icon: const Icon(FeatherIcons.moreVertical),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Organization'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete Organization'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditDialog(org);
                  } else if (value == 'delete') {
                    _showDeleteDialog(org);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(org.description ?? 'No description'),
          const SizedBox(height: 32),
          _buildTeamsSection(org),
          const SizedBox(height: 32),
          _buildMembersSection(org),
        ],
      ),
    );
  }

  Widget _buildTeamsSection(Organization org) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Teams',
              style: Get.textTheme.titleLarge,
            ),
            ElevatedButton.icon(
              icon: const Icon(FeatherIcons.plus),
              label: const Text('Create Team'),
              onPressed: () => _showCreateTeamDialog(org.id),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (org.teams.isEmpty)
          const Center(child: Text('No teams yet'))
        else
          ListView.builder(
            shrinkWrap: true,
            itemCount: org.teams.length,
            itemBuilder: (context, index) {
              final team = org.teams[index];
              return ListTile(
                leading: const Icon(FeatherIcons.users),
                title: Text(team.name),
                subtitle: Text(team.description ?? ''),
                trailing: const Icon(FeatherIcons.chevronRight),
                onTap: () => Get.toNamed('/teams/${team.id}'),
              );
            },
          ),
      ],
    );
  }

  void _showCreateTeamDialog(int organizationId) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final teamController = Get.find<TeamController>();

    teamController.setCurrentOrganization(organizationId);

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
                await teamController.createTeam(
                  nameController.text.trim(),
                  descriptionController.text.isEmpty
                      ? null
                      : descriptionController.text.trim(),
                  organizationId,
                );

                // Refresh organization details to show new team
                controller.loadOrganization(organizationId);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Organization org) {
    final nameController = TextEditingController(text: org.name);
    final descriptionController =
        TextEditingController(text: org.description ?? '');
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Organization'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Organization Name',
                  hintText: 'Enter organization name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter organization name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Enter organization description',
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
                  await controller.updateOrganization(
                    org.id,
                    nameController.text.trim(),
                    descriptionController.text.isEmpty
                        ? null
                        : descriptionController.text.trim(),
                  );
                  Get.back();
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to update organization: ${e.toString()}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red[100],
                    colorText: Colors.red[900],
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Organization org) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Organization'),
        content: Text(
            'Are you sure you want to delete "${org.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () async {
              try {
                Get.back(); // Close dialog first
                await controller.deleteOrganization(org.id);
                Get.offAllNamed('/organizations'); // Navigate using offAll

                // Show snackbar after navigation
                Get.snackbar(
                  'Success',
                  'Organization deleted successfully',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'Failed to delete organization: ${e.toString()}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red[100],
                  colorText: Colors.red[900],
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSection(Organization org) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Members',
              style: Get.textTheme.titleLarge,
            ),
            ElevatedButton.icon(
              icon: const Icon(FeatherIcons.userPlus),
              label: const Text('Add Member'),
              onPressed: () {
                // TODO: Implement add member
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (org.members.isEmpty)
          const Center(child: Text('No members yet'))
        else
          ListView.builder(
            shrinkWrap: true,
            itemCount: org.members.length,
            itemBuilder: (context, index) {
              final member = org.members[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: member.user?.profileImageUrl != null
                      ? NetworkImage(member.user!.profileImageUrl!)
                      : null,
                  child: member.user?.profileImageUrl == null
                      ? Text(member.user?.fullName[0] ?? '')
                      : null,
                ),
                title: Text(member.user?.fullName ?? 'Unknown User'),
                subtitle: Text(member.role),
              );
            },
          ),
      ],
    );
  }
}

class OrganizationDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrganizationDetailController(Get.find()));
    // Initialize TeamController with organization context
    final orgId = int.tryParse(Get.parameters['id'] ?? '');
    if (orgId != null) {
      final teamController = Get.find<TeamController>();
      teamController.setCurrentOrganization(orgId);
    }
  }
}
