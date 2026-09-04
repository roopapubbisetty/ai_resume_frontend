import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../app_logo.dart';

class SideMenu extends StatelessWidget {
  final String currentRoute;

  const SideMenu({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isAdmin = authProvider.isAdmin;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AppLogo(),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _MenuItem(
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  route: AppRoutes.dashboard,
                  currentRoute: currentRoute,
                ),
                _MenuItem(
                  icon: Icons.description_rounded,
                  title: 'My Resumes',
                  route: AppRoutes.resumeList,
                  currentRoute: currentRoute,
                ),
                _MenuItem(
                  icon: Icons.work_history_rounded,
                  title: 'Job Selection',
                  route: AppRoutes.jobSelection,
                  currentRoute: currentRoute,
                ),
                _MenuItem(
                  icon: Icons.history_rounded,
                  title: 'Screening History',
                  route: AppRoutes.screeningHistory,
                  currentRoute: currentRoute,
                ),
                _MenuItem(
                  icon: Icons.smart_toy_rounded,
                  title: 'AI Career Assistant',
                  route: AppRoutes.agent,
                  currentRoute: currentRoute,
                ),
                _MenuItem(
                  icon: Icons.person_rounded,
                  title: 'Profile',
                  route: AppRoutes.profile,
                  currentRoute: currentRoute,
                ),
                if (isAdmin) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text(
                      'ADMINISTRATION',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.admin_panel_settings_rounded,
                    title: 'Admin Portal',
                    route: AppRoutes.adminDashboard,
                    currentRoute: currentRoute,
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: const Text(
              'Logout',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
            onTap: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final String currentRoute;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.route,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selected: isSelected,
        selectedTileColor: AppColors.primaryLight,
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        onTap: () {
          if (!isSelected) {
            Navigator.of(context).pushReplacementNamed(route);
          }
        },
      ),
    );
  }
}
