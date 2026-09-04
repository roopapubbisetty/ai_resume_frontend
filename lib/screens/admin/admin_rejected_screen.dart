import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/admin_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/admin/admin_side_menu.dart';
import '../../widgets/screening/screening_status_badge.dart';

class AdminRejectedScreen extends StatelessWidget {
  const AdminRejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final adminProvider = Provider.of<AdminProvider>(context);
    final rejected = adminProvider.rejectedCandidates;

    return Scaffold(
      appBar: const DashboardAppBar(title: 'Rejected Candidates'),
      drawer: isDesktop ? null : const AdminSideMenu(currentRoute: AppRoutes.adminRejected),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: AdminSideMenu(currentRoute: AppRoutes.adminRejected),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rejected / Unmatched Candidates',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.error),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Candidates falling below required qualification threshold.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  if (rejected.isEmpty)
                    const Expanded(child: Center(child: Text('No rejected candidates recorded.')))
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: rejected.length,
                        itemBuilder: (context, index) {
                          final item = rejected[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: const Icon(Icons.cancel_rounded, color: AppColors.error, size: 32),
                              title: Text(item.job?.title ?? 'Candidate Evaluation'),
                              subtitle: Text('Score: ${item.score}% • Missing Skills: ${item.missingSkills.length}'),
                              trailing: const ScreeningStatusBadge(status: 'Rejected'),
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
