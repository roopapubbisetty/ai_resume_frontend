import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/dashboard/welcome_card.dart';
import '../../widgets/dashboard/stat_card.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false).fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dashProvider = Provider.of<DashboardProvider>(context);
    final user = authProvider.user;
    final data = dashProvider.dashboardData;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeCard(userName: user?.fullName ?? 'User'),
          const SizedBox(height: 24),
          if (dashProvider.isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;
                return GridView.count(
                  crossAxisCount: isWide ? 4 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: isWide ? 1.5 : 1.3,
                  children: [
                    StatCard(
                      title: 'Total Resumes',
                      value: '${data?.totalResumes ?? 0}',
                      icon: Icons.description_rounded,
                      color: AppColors.primary,
                    ),
                    StatCard(
                      title: 'Evaluations',
                      value: '${data?.totalScreenings ?? 0}',
                      icon: Icons.rate_review_rounded,
                      color: AppColors.secondary,
                    ),
                    StatCard(
                      title: 'Selected',
                      value: '${data?.selectedCandidates ?? 0}',
                      icon: Icons.check_circle_rounded,
                      color: AppColors.success,
                    ),
                    StatCard(
                      title: 'Avg Match Score',
                      value: '${(data?.averageMatchScore ?? 0).toStringAsFixed(1)}%',
                      icon: Icons.speed_rounded,
                      color: AppColors.warning,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _QuickActionTile(
                    title: 'Upload Resume',
                    subtitle: 'Add new CVs to system',
                    icon: Icons.cloud_upload_rounded,
                    color: AppColors.primary,
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.uploadResume),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _QuickActionTile(
                    title: 'Select Job & Screen',
                    subtitle: 'Run instant AI evaluation',
                    icon: Icons.work_outline_rounded,
                    color: AppColors.secondary,
                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.jobSelection),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}
