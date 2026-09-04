import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/admin/admin_side_menu.dart';
import '../../widgets/admin/analytics_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchAdminData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final adminProvider = Provider.of<AdminProvider>(context);
    final analytics = adminProvider.analytics;

    return Scaffold(
      appBar: const DashboardAppBar(title: 'Admin Control Center'),
      drawer: isDesktop ? null : const AdminSideMenu(currentRoute: AppRoutes.adminDashboard),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: AdminSideMenu(currentRoute: AppRoutes.adminDashboard),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Administrator Overview',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Manage active job descriptions, monitor resume parsing metrics, and review candidate pipeline statistics.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  if (adminProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    GridView.count(
                      crossAxisCount: isDesktop ? 4 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.5,
                      children: [
                        AnalyticsCard(
                          title: 'Active Job Posts',
                          value: '${analytics?.totalJobs ?? 0}',
                          icon: Icons.work_rounded,
                          color: AppColors.primary,
                        ),
                        AnalyticsCard(
                          title: 'Total Resumes',
                          value: '${analytics?.totalResumes ?? 0}',
                          icon: Icons.description_rounded,
                          color: AppColors.secondary,
                        ),
                        AnalyticsCard(
                          title: 'Selected Candidates',
                          value: '${analytics?.selectedCount ?? 0}',
                          icon: Icons.check_circle_rounded,
                          color: AppColors.success,
                        ),
                        AnalyticsCard(
                          title: 'Rejected Candidates',
                          value: '${analytics?.rejectedCount ?? 0}',
                          icon: Icons.cancel_rounded,
                          color: AppColors.error,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Admin Actions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.adminCreateJob);
                          },
                          icon: const Icon(Icons.post_add_rounded),
                          label: const Text('Create New Job Post'),
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.adminJobs);
                          },
                          icon: const Icon(Icons.list_alt_rounded),
                          label: const Text('Manage Jobs'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
