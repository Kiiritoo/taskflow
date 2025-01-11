import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/views/dashboard_sidebar.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({Key? key}) : super(key: key);

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
                  child: _buildContent(),
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
      child: const Row(
        children: [
          Text(
            'Help Center',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Text(
        'Help Center - Coming Soon',
        style: TextStyle(
          fontSize: 18,
          color: Colors.grey[600],
        ),
      ),
    );
  }
} 