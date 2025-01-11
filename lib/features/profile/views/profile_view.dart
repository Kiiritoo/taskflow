import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../controllers/profile_controller.dart';
import '../../dashboard/views/dashboard_sidebar.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

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
                    child: _buildProfileContent(),
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
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Profile Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Stack(
                children: [
                  Obx(() => CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue[100],
                    backgroundImage: controller.profileImageUrl.value != null
                        ? NetworkImage(controller.profileImageUrl.value!)
                        : null,
                    child: controller.profileImageUrl.value == null
                        ? Text(
                            controller.user.value?.fullName[0].toUpperCase() ?? 'U',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          )
                        : null,
                  )),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: InkWell(
                        onTap: controller.isUploadingImage.value
                            ? null
                            : controller.pickAndUploadImage,
                        child: Obx(() => Icon(
                          controller.isUploadingImage.value
                              ? FeatherIcons.loader
                              : FeatherIcons.camera,
                          size: 16,
                          color: Colors.white,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement profile picture upload
                },
                icon: const Icon(FeatherIcons.camera),
                label: const Text('Change Profile Picture'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                label: 'Full Name',
                controller: controller.fullNameController,
                icon: FeatherIcons.user,
                validator: controller.validateFullName,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'Username',
                controller: controller.usernameController,
                icon: FeatherIcons.atSign,
                validator: controller.validateUsername,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'Email',
                controller: controller.emailController,
                icon: FeatherIcons.mail,
                enabled: false,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isSaving.value 
                      ? null 
                      : controller.updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isSaving.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Save Changes'),
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
