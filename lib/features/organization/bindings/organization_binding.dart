import 'package:get/get.dart';
import '../controllers/organization_controller.dart';
import '../controllers/organization_detail_controller.dart';
import '../../../data/repositories/organization_repository.dart';

class OrganizationBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure repository is available
    if (!Get.isRegistered<OrganizationRepository>()) {
      Get.put(OrganizationRepository(Get.find()));
    }

    // Ensure main organization controller is available
    if (!Get.isRegistered<OrganizationController>()) {
      Get.put(OrganizationController(Get.find()));
    }

    // Create new instance of detail controller
    Get.lazyPut(() => OrganizationDetailController(Get.find()));
  }
}
