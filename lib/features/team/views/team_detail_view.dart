import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import '../../dashboard/views/dashboard_sidebar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

// Sisanya tetap sama 
class TeamDetailView extends GetView<TeamController> {
  const TeamDetailView({Key? key}) : super(key: key);

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
                    child: _buildTeamContent(),
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
            final team = controller.teams.firstWhere(
              (t) => t.id.toString() == Get.parameters['id'],
              orElse: () => throw Exception('Team not found'),
            );
            return Text(
              team.name,
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

  Widget _buildTeamContent() {
    return Obx(() {
      final team = controller.teams.firstWhere(
        (t) => t.id.toString() == Get.parameters['id'],
        orElse: () => throw Exception('Team not found'),
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTeamInfo(team),
          const SizedBox(height: 32),
          _buildMembersList(team),
        ],
      );
    });
  }

  Widget _buildTeamInfo(team) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Team Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Name'),
              subtitle: Text(team.name),
              leading: const Icon(Icons.group),
            ),
            if (team.description != null)
              ListTile(
                title: const Text('Description'),
                subtitle: Text(team.description!),
                leading: const Icon(Icons.description),
              ),
            ListTile(
              title: const Text('Created At'),
              subtitle: Text(team.createdAt.toString()),
              leading: const Icon(Icons.calendar_today),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersList(team) {
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
                  'Team Members',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddMemberDialog(),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Member'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: team.members.length,
              itemBuilder: (context, index) {
                final member = team.members[index];
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
          child: Text('Edit Team'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete Team'),
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
    // TODO: Implement edit team dialog
  }

  void _showDeleteDialog() {
    // TODO: Implement delete team dialog
  }
}
