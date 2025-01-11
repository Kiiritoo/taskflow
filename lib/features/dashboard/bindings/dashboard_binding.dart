import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/repositories/auth_repository.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthController is available
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(Get.find<AuthRepository>()), permanent: true);
    }
    
    // Dashboard controller depends on AuthController
    Get.lazyPut(() => DashboardController(Get.find<AuthController>()));
  }
}