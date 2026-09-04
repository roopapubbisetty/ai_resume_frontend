import 'package:flutter/material.dart';
import '../../config/app_routes.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/dashboard/side_menu.dart';
import 'dashboard_home.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Scaffold(
      appBar: const DashboardAppBar(title: 'Dashboard'),
      drawer: isDesktop ? null : const SideMenu(currentRoute: AppRoutes.dashboard),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: SideMenu(currentRoute: AppRoutes.dashboard),
            ),
          const Expanded(
            child: DashboardHome(),
          ),
        ],
      ),
    );
  }
}