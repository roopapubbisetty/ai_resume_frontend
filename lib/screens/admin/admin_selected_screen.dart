import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/admin/admin_side_menu.dart';
import '../../widgets/screening/screening_status_badge.dart';

class AdminSelectedScreen extends StatelessWidget {
  const AdminSelectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final adminProvider = Provider.of<AdminProvider>(context);
    final selected = adminProvider.selectedCandidates;

    return Scaffold(
      appBar: const DashboardAppBar(title: 'Selected Candidates'),
      drawer: isDesktop ? null : const AdminSideMenu(currentRoute: AppRoutes.adminSelected),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: AdminSideMenu(currentRoute: AppRoutes.adminSelected),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shortlisted & Selected Candidates',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.success),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Candidates scoring above the threshold fit criteria.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  if (selected.isEmpty)
                    const Expanded(child: Center(child: Text('No shortlisted candidates yet.')))
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: selected.length,
                        itemBuilder: (context, index) {
                          final item = selected[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 32),
                              title: Text(item.job?.title ?? 'Selected Candidate'),
                              subtitle: Text('Score: ${item.score}% • Matched Skills: ${item.matchedSkills.length}'),
                              trailing: const ScreeningStatusBadge(status: 'Selected'),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
