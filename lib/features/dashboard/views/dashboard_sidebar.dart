import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../controllers/dashboard_controller.dart';

class DashboardSidebar extends GetView<DashboardController> {
  const DashboardSidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          _buildSidebarHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 5),
              children: [
                _buildSidebarSection('WORKSPACE'),
                _buildNavItem(FeatherIcons.home, 'Dashboard', '/dashboard'),
                _buildNavItem(FeatherIcons.clipboard, 'My Tasks', '/tasks'),
                _buildNavItem(FeatherIcons.user, 'My Profile', '/profile'),
                
                _buildSidebarSection('ORGANIZATION'),
                _buildNavItem(FeatherIcons.briefcase, 'Organizations', '/organizations'),
                _buildNavItem(FeatherIcons.users, 'Teams', '/teams'),
                
                _buildSidebarSection('SUPPORT'),
                _buildNavItem(FeatherIcons.helpCircle, 'Help Center', '/help'),
                _buildNavItem(FeatherIcons.messageCircle, 'Contact Support', '/support'),
                _buildNavItem(FeatherIcons.bookOpen, 'Documentation', '/docs'),
                
                _buildSidebarSection('SETTINGS'),
                _buildNavItem(FeatherIcons.settings, 'Settings', '/settings'),
                _buildNavItem(FeatherIcons.bell, 'Notifications', '/notifications'),
                
                const Divider(height: 32),
                _buildNavItem(
                  FeatherIcons.logOut,
                  'Logout',
                  '/logout',
                  onTap: () => controller.logout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Icon(
            FeatherIcons.clipboard,
            size: 24,
            color: Colors.blue,
          ),
          const SizedBox(width: 12),
          const Text(
            'TaskFlow',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, String route, {VoidCallback? onTap}) {
    final isActive = Get.currentRoute == route;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? Colors.blue : Colors.grey[600],
        size: 18,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.blue : Colors.grey[800],
          fontSize: 13,
          fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      selected: isActive,
      onTap: onTap ?? () => Get.toNamed(route),
      selectedTileColor: Colors.blue.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      dense: true,
    );
  }
} 