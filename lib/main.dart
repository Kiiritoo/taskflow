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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Core services
  final prefs = await SharedPreferences.getInstance();
  
  // Initialize repositories
  final authRepository = AuthRepository(prefs);
  
  // Put all dependencies
  Get.put<SharedPreferences>(prefs, permanent: true);
  Get.put<AuthRepository>(authRepository, permanent: true);
  
  runApp(MyApp(
    prefs: prefs,
    initialRoute: '/login',
    resetToken: prefs.getString('reset_token'),
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final String initialRoute;
  final String? resetToken;
  
  const MyApp({
    super.key, 
    required this.prefs, 
    required this.initialRoute,
    this.resetToken,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      defaultTransition: Transition.noTransition,
      initialBinding: BindingsBuilder(() {
        // Empty as we've initialized dependencies in main()
      }),
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/forgot-password',
          page: () => const ForgotPasswordView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => const DashboardView(),
          binding: DashboardBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/reset-password',
          page: () => const ResetPasswordView(),
          binding: AuthBinding(),
          parameters: resetToken != null ? {'token': resetToken!} : null,
        ),
        GetPage(
          name: '/profile',
          page: () => const ProfileView(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => ProfileController(Get.find<AuthRepository>()));
          }),
        ),
        GetPage(
          name: '/organizations',
          page: () => const OrganizationListView(),
          binding: BindingsBuilder(() {
            Get.put(OrganizationController(Get.find<OrganizationRepository>()));
          }),
        ),
        GetPage(
          name: '/organizations/:id',
          page: () => const OrganizationDetailView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<OrganizationController>(
              () => OrganizationController(Get.find<OrganizationRepository>()),
              fenix: true
            );
          }),
        ),
        GetPage(
          name: '/teams',
          page: () => const TeamListView(),
          binding: BindingsBuilder(() {
            Get.put(TeamController(Get.find<TeamRepository>()));
          }),
        ),
        GetPage(
          name: '/teams/:id',
          page: () => const TeamDetailView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<TeamController>(() => TeamController(Get.find()));
          }),
        ),
        GetPage(
          name: '/help',
          page: () => const HelpCenterView(),
        ),
        GetPage(
          name: '/support',
          page: () => const SupportView(),
        ),
        GetPage(
          name: '/docs',
          page: () => const DocumentationView(),
        ),
        GetPage(
          name: '/notifications',
          page: () => const NotificationsView(),
        ),
      ],
      initialRoute: initialRoute,
    );
  }
}
