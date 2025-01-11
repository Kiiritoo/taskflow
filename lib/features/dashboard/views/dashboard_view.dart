import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/board_controller.dart';
import './dashboard_sidebar.dart';
import './components/navbar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class DashboardView extends GetView<BoardController> {
  const DashboardView({Key? key}) : super(key: key);

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
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildContent(),
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
            'Dashboard',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => Get.find<BoardController>().createNewTask(),
            icon: const Icon(FeatherIcons.plus),
            label: const Text('Create Task'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildWelcomeSection(),
        const SizedBox(height: 32),
        _buildTasksOverview(),
        const SizedBox(height: 32),
        _buildRecentActivities(),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Here\'s what\'s happening with your tasks today.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksOverview() {
    return Obx(() => Row(
      children: [
        _buildTaskCard(
          'To Do',
          controller.todoTasks.length.toString(),
          FeatherIcons.clipboard,
          Colors.blue,
        ),
        const SizedBox(width: 16),
        _buildTaskCard(
          'In Progress',
          controller.inProgressTasks.length.toString(),
          FeatherIcons.clock,
          Colors.orange,
        ),
        const SizedBox(width: 16),
        _buildTaskCard(
          'Review',
          controller.reviewTasks.length.toString(),
          FeatherIcons.eye,
          Colors.purple,
        ),
        const SizedBox(width: 16),
        _buildTaskCard(
          'Done',
          controller.doneTasks.length.toString(),
          FeatherIcons.checkCircle,
          Colors.green,
        ),
      ],
    ));
  }

  Widget _buildTaskCard(String title, String count, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: const Icon(FeatherIcons.activity, color: Colors.blue),
          ),
          title: Text('Task ${index + 1} was updated'),
          subtitle: Text('${index + 1} hours ago'),
        );
      },
    );
  }
} 