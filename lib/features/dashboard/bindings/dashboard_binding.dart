import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/board_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/organization_repository.dart';
import '../../../data/repositories/team_repository.dart';
import '../../organization/controllers/organization_controller.dart';
import '../../team/controllers/team_controller.dart';
import '../../../data/services/database_service.dart';
import '../../../data/services/api_service.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // Get AuthController instance
    final authController = Get.find<AuthController>();
    
    // Controllers
    Get.lazyPut(() => DashboardController(authController), fenix: true);
    Get.lazyPut(() => BoardController(), fenix: true);
    Get.lazyPut(() => OrganizationController(Get.find()), fenix: true);
    Get.lazyPut(() => TeamController(Get.find()), fenix: true);
  }
}