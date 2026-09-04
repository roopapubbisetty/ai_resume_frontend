import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/admin/admin_side_menu.dart';
import '../../widgets/admin/analytics_card.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
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
      appBar: const DashboardAppBar(title: 'System Analytics'),
      drawer: isDesktop ? null : const AdminSideMenu(currentRoute: AppRoutes.adminAnalytics),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: AdminSideMenu(currentRoute: AppRoutes.adminAnalytics),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Platform Analytics & Insights',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (adminProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    GridView.count(
                      crossAxisCount: isDesktop ? 3 : 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 2.0,
                      children: [
                        AnalyticsCard(
                          title: 'Registered Platform Users',
                          value: '${analytics?.totalUsers ?? 48}',
                          icon: Icons.people_rounded,
                          color: AppColors.primary,
                        ),
                        AnalyticsCard(
                          title: 'Total Screenings Run',
                          value: '${analytics?.totalScreenings ?? 34}',
                          icon: Icons.auto_awesome_rounded,
                          color: AppColors.secondary,
                        ),
                        AnalyticsCard(
                          title: 'Avg Candidate Fit Score',
                          value: '${analytics?.averageScore ?? 82.4}%',
                          icon: Icons.speed_rounded,
                          color: AppColors.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Monthly Screening Volume',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _BarChartCol(month: 'Jan', val: 12, heightRatio: 0.3),
                                _BarChartCol(month: 'Feb', val: 18, heightRatio: 0.5),
                                _BarChartCol(month: 'Mar', val: 25, heightRatio: 0.7),
                                _BarChartCol(month: 'Apr', val: 34, heightRatio: 1.0),
                              ],
                            ),
                          ],
                        ),
                      ),
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

class _BarChartCol extends StatelessWidget {
  final String month;
  final int val;
  final double heightRatio;

  const _BarChartCol({
    required this.month,
    required this.val,
    required this.heightRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$val', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: 30,
          height: 120 * heightRatio,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 8),
        Text(month, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
