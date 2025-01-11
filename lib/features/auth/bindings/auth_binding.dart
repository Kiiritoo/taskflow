import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/services/api_service.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository(
      Get.find<SharedPreferences>(),
    ));
    Get.lazyPut<AuthController>(() => AuthController(Get.find<AuthRepository>()));
  }
} 