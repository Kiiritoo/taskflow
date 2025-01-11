import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';
import 'core/themes/app_theme.dart';
import 'features/auth/bindings/auth_binding.dart';
import 'features/auth/views/login_view.dart';
import 'features/dashboard/views/dashboard_view.dart';
import 'data/repositories/auth_repository.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/views/register_view.dart';
import 'features/auth/views/forgot_password_view.dart';
import 'features/auth/views/reset_password_view.dart';
import 'features/dashboard/bindings/dashboard_binding.dart';
import 'features/dashboard/controllers/dashboard_controller.dart';
import 'package:taskflow/features/profile/views/profile_view.dart';
import 'package:taskflow/features/profile/controllers/profile_controller.dart';
import 'features/organization/views/organization_list_view.dart';
import 'features/organization/views/organization_detail_view.dart';
import 'features/organization/controllers/organization_controller.dart';
import 'features/team/views/team_list_view.dart';
import 'features/team/views/team_detail_view.dart';
import 'features/team/controllers/team_controller.dart';
import '../../../data/repositories/team_repository.dart';
import '../../../data/repositories/organization_repository.dart';
import '../../../data/services/api_service.dart';
import 'features/help/views/help_center_view.dart';
import 'features/support/views/support_view.dart';
import 'features/documentation/views/documentation_view.dart';
import 'features/notifications/views/notifications_view.dart';
import 'features/dashboard/controllers/dashboard_controller.dart';
import 'features/dashboard/controllers/board_controller.dart';
import 'core/middleware/auth_middleware.dart';
import '../../../data/services/database_service.dart';
import 'features/organization/bindings/organization_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Core services
  final prefs = await SharedPreferences.getInstance();
  
  // Initialize all dependencies
  await initializeDependencies(prefs);
  
  // Initialize window size for desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('TaskFlow');
    setWindowMinSize(const Size(1280, 720));
  }
  
  runApp(MyApp(prefs: prefs));
}

Future<void> initializeDependencies(SharedPreferences prefs) async {
  // Core services
  Get.put<SharedPreferences>(prefs, permanent: true);
  Get.put<DatabaseService>(DatabaseService(), permanent: true);
  Get.put<ApiService>(ApiService(), permanent: true);
  
  // Repositories
  Get.put<AuthRepository>(AuthRepository(prefs), permanent: true);
  Get.put<OrganizationRepository>(
    OrganizationRepository(Get.find<DatabaseService>()), 
    permanent: true
  );
  Get.put<TeamRepository>(
    TeamRepository(Get.find<DatabaseService>()), 
    permanent: true
  );
  
  // Controllers
  Get.put<AuthController>(AuthController(Get.find<AuthRepository>()), permanent: true);
  Get.put<ProfileController>(
    ProfileController(Get.find<AuthRepository>()), 
    permanent: true
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const MyApp({
    Key? key,
    required this.prefs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TaskFlow',
      theme: AppTheme.lightTheme,
      initialBinding: AuthBinding(),
      defaultTransition: Transition.fade,
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/forgot-password',
          page: () => const ForgotPasswordView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/reset-password',
          page: () => const ResetPasswordView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => DashboardView(),
          binding: DashboardBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/profile',
          page: () => const ProfileView(),
          binding: BindingsBuilder(() {
            if (!Get.isRegistered<ProfileController>()) {
              Get.put(ProfileController(Get.find<AuthRepository>()));
            }
          }),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/organizations',
          page: () => const OrganizationListView(),
          binding: DashboardBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/organizations/:id',
          page: () => const OrganizationDetailView(),
          binding: OrganizationBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/teams',
          page: () => const TeamListView(),
          binding: DashboardBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/help',
          page: () => const HelpCenterView(),
          binding: DashboardBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/support',
          page: () => const SupportView(),
          binding: DashboardBinding(),
          middlewares: [AuthMiddleware()],
        ),
      ],
    );
  }
}
