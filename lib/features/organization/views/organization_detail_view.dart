import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/organization_detail_controller.dart';
import '../../dashboard/views/dashboard_sidebar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../../data/models/organization.dart';

class OrganizationDetailView extends GetView<OrganizationDetailController> {
  const OrganizationDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orgId = int.parse(Get.parameters['id'] ?? '0');
    
    // Load organization details when view is created
    controller.loadOrganization(orgId);

    return Scaffold(
      body: Row(
        children: [
          const DashboardSidebar(),
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
                      Text(
                        'Error: ${controller.error.value}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(FeatherIcons.refreshCw),
                        label: const Text('Retry'),
                        onPressed: () => controller.loadOrganization(orgId),
                      ),
                    ],
                  ),
                );
              }

              final org = controller.organization.value;
              if (org == null) {
                return const Center(child: Text('Organization not found'));
              }

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
                              // TODO: Implement edit
                            } else if (value == 'delete') {
                              // TODO: Implement delete
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
            }),
          ),
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
              onPressed: () {
                // TODO: Implement create team
              },
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
