import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class DashboardController extends GetxController {
  final currentRoute = ''.obs;
  final AuthController authController;
  
  DashboardController(this.authController);

  @override
  void onInit() {
    super.onInit();
    currentRoute.value = Get.currentRoute;
    ever(currentRoute, (_) => update());
    Get.rootDelegate.addListener(() {
      currentRoute.value = Get.currentRoute;
    });
  }

  bool isActiveRoute(String route) {
    return currentRoute.value == route;
  }

  void logout() {
    authController.logout();
  }

  String get userFullName => authController.user.value?.fullName ?? 'User';
  String get userInitials => (authController.user.value?.fullName.isNotEmpty ?? false) 
      ? authController.user.value!.fullName[0].toUpperCase() 
      : 'U';
}
