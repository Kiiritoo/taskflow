import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import '../../dashboard/views/dashboard_sidebar.dart';
import '../../dashboard/views/components/navbar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../../data/models/team.dart';

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
                const DashboardNavbar(),
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildTeamContent(context),
                  ),
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
            onPressed: () => Get.back(),
            tooltip: 'Back to Teams',
          ),
          const SizedBox(width: 16),
          Obx(() {
            final team = controller.currentTeam.value;
            return Text(
              team?.name ?? 'Team Details',
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

  Widget _buildTeamContent(BuildContext context) {
    return Obx(() {
      final team = controller.currentTeam.value;
      if (team == null) return const Center(child: Text('Team not found'));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTeamHeader(team, context),
          const SizedBox(height: 32),
          _buildMembersSection(team),
          const SizedBox(height: 32),
          _buildProjectsSection(team),
          const SizedBox(height: 32),
          _buildRecentActivities(team),
        ],
      );
    });
  }

  Widget _buildTeamHeader(Team team, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                team.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (team.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  team.description!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ],
          ),
        ),
        PopupMenuButton(
          icon: const Icon(FeatherIcons.moreVertical),
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
              _showEditDialog(team);
            } else if (value == 'delete') {
              _showDeleteDialog(team);
            }
          },
        ),
      ],
    );
  }

  void _showEditDialog(Team team) {
    // TODO: Implement edit team dialog
  }

  void _showDeleteDialog(Team team) {
    // TODO: Implement delete team dialog
  }

  Widget _buildMembersSection(Team team) {
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
        if (team.members.isEmpty)
          const Center(child: Text('No members yet'))
        else
          ListView.builder(
            shrinkWrap: true,
            itemCount: team.members.length,
            itemBuilder: (context, index) {
              final member = team.members[index];
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

  Widget _buildProjectsSection(Team team) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Projects',
          style: Get.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        const Center(
            child: Text('No projects yet')), // TODO: Implement projects list
      ],
    );
  }

  Widget _buildRecentActivities(Team team) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activities',
          style: Get.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        const Center(
            child: Text('No recent activities')), // TODO: Implement activities
      ],
    );
  }
}
