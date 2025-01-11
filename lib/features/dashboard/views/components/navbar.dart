import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../controllers/dashboard_controller.dart';

class DashboardNavbar extends GetView<DashboardController> {
  const DashboardNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Obx(() => Text(
                  'Welcome, ${controller.userFullName}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildNotificationIcon(),
          const SizedBox(width: 16),
          _buildProfileMenu(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(FeatherIcons.search, size: 20, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(FeatherIcons.bell),
          onPressed: () => Get.toNamed('/notifications'),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenu() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Obx(() => Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              child: Text(
                controller.userInitials,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              controller.userFullName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(width: 8),
            Icon(FeatherIcons.chevronDown, size: 18, color: Colors.grey[600]),
          ],
        )),
      ),
      itemBuilder: (context) => [
        _buildMenuItem('My Profile', FeatherIcons.user, '/profile'),
        _buildMenuItem('Settings', FeatherIcons.settings, '/settings'),
        const PopupMenuDivider(),
        _buildMenuItem('Logout', FeatherIcons.logOut, '/logout'),
      ],
      onSelected: (value) {
        if (value == '/logout') {
          controller.logout();
        } else {
          Get.toNamed(value);
        }
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem(String label, IconData icon, String value) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
} 