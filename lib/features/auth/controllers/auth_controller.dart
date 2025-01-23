import 'package:get/get.dart';
import '../../../data/models/user.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthController extends GetxController {
  final AuthRepository authRepository;
  final user = Rx<User?>(null);
  final isLoading = false.obs;
  final error = ''.obs;
  final rememberMe = false.obs;
  final resetEmailSent = false.obs;

  // Form controllers
  final registerFormKey = GlobalKey<FormState>();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();
  final registerFullNameController = TextEditingController();

  AuthController(this.authRepository);

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';
      final loggedInUser = await authRepository.login(email, password);
      user.value = loggedInUser;

      // Store user data in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(loggedInUser.toJson()));

      Get.offAllNamed('/dashboard');
    } catch (e) {
      error.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password, String fullName) async {
    try {
      isLoading.value = true;
      error.value = '';
      await authRepository.register(fullName, email, password);
      Get.offAllNamed('/login');
      Get.snackbar('Success', 'Registration successful! Please login.');
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.clearUserData();
      user.value = null;
      Get.offAllNamed('/login');
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<bool> verifyResetToken(String token) async {
    try {
      return await authRepository.verifyResetToken(token);
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;
      error.value = '';
      await authRepository.sendPasswordResetEmail(email);
      resetEmailSent.value = true;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      isLoading.value = true;
      error.value = '';
      await authRepository.resetPassword(token, newPassword);
      Get.offAllNamed('/login');
      Get.snackbar('Success', 'Password has been reset successfully');
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
