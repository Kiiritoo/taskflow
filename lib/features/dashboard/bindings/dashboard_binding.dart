import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/board_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/organization_repository.dart';
import '../../../data/repositories/team_repository.dart';
import '../../organization/controllers/organization_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Core dependencies
    if (!Get.isRegistered<AuthController>()) {
      Get.put(AuthController(Get.find<AuthRepository>()), permanent: true);
    }

    // Repositories
    Get.lazyPut(() => OrganizationRepository(), fenix: true);
    Get.lazyPut(() => TeamRepository(Get.find()), fenix: true);

    // Controllers
    Get.lazyPut(() => DashboardController(Get.find<AuthController>()));
    Get.lazyPut(() => BoardController());
    Get.lazyPut(() => OrganizationController(Get.find()));
  }
}