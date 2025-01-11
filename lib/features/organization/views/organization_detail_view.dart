import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/organization_controller.dart';
import '../../dashboard/views/dashboard_sidebar.dart';
import '../../team/controllers/team_controller.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class OrganizationDetailView extends GetView<OrganizationController> {
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
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildOrganizationContent(),
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
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 16),
          Obx(() {
            final org = controller.organizations.firstWhere(
              (o) => o.id.toString() == Get.parameters['id'],
              orElse: () => throw Exception('Organization not found'),
            );
            return Text(
              org.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
          const Spacer(),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildOrganizationContent() {
    return Obx(() {
      final org = controller.organizations.firstWhere(
        (o) => o.id.toString() == Get.parameters['id'],
        orElse: () => throw Exception('Organization not found'),
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrgInfo(org),
          const SizedBox(height: 32),
          _buildTeamsSection(org),
          const SizedBox(height: 32),
          _buildMembersSection(org),
        ],
      );
    });
  }

  Widget _buildOrgInfo(org) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Organization Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Name'),
              subtitle: Text(org.name),
              leading: const Icon(FeatherIcons.briefcase),
            ),
            if (org.description != null)
              ListTile(
                title: const Text('Description'),
                subtitle: Text(org.description!),
                leading: const Icon(FeatherIcons.alignLeft),
              ),
            ListTile(
              title: const Text('Created At'),
              subtitle: Text(org.createdAt.toString()),
              leading: const Icon(FeatherIcons.calendar),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamsSection(org) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Teams',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCreateTeamDialog(),
                  icon: const Icon(FeatherIcons.plus),
                  label: const Text('Create Team'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: org.teams.length,
              itemBuilder: (context, index) {
                final team = org.teams[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(FeatherIcons.users),
                    title: Text(team.name),
                    subtitle: Text('${team.members.length} members'),
                    trailing: const Icon(FeatherIcons.chevronRight),
                    onTap: () => Get.toNamed('/teams/${team.id}'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersSection(org) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Members',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddMemberDialog(),
                  icon: const Icon(FeatherIcons.userPlus),
                  label: const Text('Add Member'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: org.members.length,
              itemBuilder: (context, index) {
                final member = org.members[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(member.userId.toString()[0]),
                  ),
                  title: Text('User ${member.userId}'),
                  subtitle: Text(member.role),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'change_role',
                        child: Text('Change Role'),
                      ),
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text('Remove'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'change_role') {
                        _showChangeRoleDialog(member);
                      } else if (value == 'remove') {
                        _showRemoveMemberDialog(member);
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return PopupMenuButton(
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
          _showEditDialog();
        } else if (value == 'delete') {
          _showDeleteDialog();
        }
      },
    );
  }

  void _showCreateTeamDialog() {
    // TODO: Implement create team dialog
  }

  void _showAddMemberDialog() {
    // TODO: Implement add member dialog
  }

  void _showChangeRoleDialog(member) {
    // TODO: Implement change role dialog
  }

  void _showRemoveMemberDialog(member) {
    // TODO: Implement remove member dialog
  }

  void _showEditDialog() {
    // TODO: Implement edit organization dialog
  }

  void _showDeleteDialog() {
    // TODO: Implement delete organization dialog
  }
}
