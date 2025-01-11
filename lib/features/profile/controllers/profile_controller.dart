import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileController extends GetxController {
  final AuthRepository _authRepository;
  final formKey = GlobalKey<FormState>();
  
  final user = Rx<User?>(null);
  final isSaving = false.obs;
  
  late TextEditingController fullNameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  
  final ImagePicker _picker = ImagePicker();
  final isUploadingImage = false.obs;
  final profileImageUrl = Rx<String?>(null);
  
  ProfileController(this._authRepository);
  
  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    loadUserData();
  }
  
  Future<void> loadUserData() async {
    try {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser != null) {
        user.value = currentUser;
        fullNameController.text = currentUser.fullName;
        usernameController.text = currentUser.username;
        emailController.text = currentUser.email;
        // Only set profileImageUrl if it's a valid string
        if (currentUser.profileImageUrl is String) {
          profileImageUrl.value = currentUser.profileImageUrl;
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;
    
    try {
      isSaving.value = true;
      
      final updatedUser = await _authRepository.updateProfile(
        fullNameController.text.trim(),
        usernameController.text.trim(),
      );
      
      user.value = updatedUser;
      
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        isUploadingImage.value = true;
        
        final imageUrl = await _authRepository.uploadProfileImage(File(image.path));
        profileImageUrl.value = imageUrl;
        
        Get.snackbar(
          'Success',
          'Profile picture updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile picture',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    } finally {
      isUploadingImage.value = false;
    }
  }
}
