import 'package:get/get.dart';
import '../controllers/organization_controller.dart';
import '../controllers/organization_detail_controller.dart';
import '../../../data/repositories/organization_repository.dart';

class OrganizationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrganizationRepository(Get.find()));
    Get.lazyPut(() => OrganizationController(Get.find()));
    Get.lazyPut(() => OrganizationDetailController(Get.find()));
  }
} 