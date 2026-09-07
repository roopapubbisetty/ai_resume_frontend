import 'package:flutter/material.dart';
import '../../config/app_routes.dart';
import '../../theme/app_colors.dart';
import '../app_logo.dart';

class AdminSideMenu extends StatelessWidget {
  final String currentRoute;

  const AdminSideMenu({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AppLogo(),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'ADMIN CONTROL PANEL',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _AdminMenuItem(
                  icon: Icons.dashboard_rounded,
                  title: 'Admin Overview',
                  route: AppRoutes.adminDashboard,
                  currentRoute: currentRoute,
                ),
                _AdminMenuItem(
                  icon: Icons.work_rounded,
                  title: 'Job Management',
                  route: AppRoutes.adminJobs,
                  currentRoute: currentRoute,
                ),
                _AdminMenuItem(
                  icon: Icons.article_rounded,
                  title: 'All Resumes',
                  route: AppRoutes.adminResumes,
                  currentRoute: currentRoute,
                ),
                _AdminMenuItem(
                  icon: Icons.rate_review_rounded,
                  title: 'Screenings',
                  route: AppRoutes.adminScreenings,
                  currentRoute: currentRoute,
                ),
                _AdminMenuItem(
                  icon: Icons.check_circle_rounded,
                  title: 'Selected Candidates',
                  route: AppRoutes.adminSelected,
                  currentRoute: currentRoute,
                ),
                _AdminMenuItem(
                  icon: Icons.cancel_rounded,
                  title: 'Rejected Candidates',
                  route: AppRoutes.adminRejected,
                  currentRoute: currentRoute,
                ),
                _AdminMenuItem(
                  icon: Icons.analytics_rounded,
                  title: 'Analytics & Insights',
                  route: AppRoutes.adminAnalytics,
                  currentRoute: currentRoute,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
            title: const Text('Back to User Dashboard'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _AdminMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final String currentRoute;

  const _AdminMenuItem({
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
        selectedTileColor: AppColors.secondary.withValues(alpha: 0.12),
        leading: Icon(
          icon,
          color: isSelected ? AppColors.secondary : AppColors.textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.secondary : AppColors.textPrimary,
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
