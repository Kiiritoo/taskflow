import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/auth/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if auth controller exists and user is logged in
    final authController = Get.find<AuthController>();
    return authController.user.value == null 
        ? const RouteSettings(name: '/login')
        : null;
  }
} 