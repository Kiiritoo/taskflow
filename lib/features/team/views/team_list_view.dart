import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import '../../dashboard/views/dashboard_sidebar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TeamListView extends GetView<TeamController> {
  const TeamListView({Key? key}) : super(key: key);

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
                  child: _buildTeamList(),
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
            'Teams',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => _showCreateDialog(),
            icon: const Icon(FeatherIcons.plus),
            label: const Text('Create Team'),
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
                'No teams yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _showCreateDialog(),
                icon: const Icon(FeatherIcons.plus),
                label: const Text('Create Team'),
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

  void _showCreateDialog() {
    // TODO: Implement create team dialog
  }
} 