import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/admin_provider.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/admin/admin_side_menu.dart';
import '../../widgets/admin/job_card.dart';

class AdminJobsScreen extends StatefulWidget {
  const AdminJobsScreen({super.key});

  @override
  State<AdminJobsScreen> createState() => _AdminJobsScreenState();
}

class _AdminJobsScreenState extends State<AdminJobsScreen> {
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

    return Scaffold(
      appBar: const DashboardAppBar(title: 'Admin Job Management'),
      drawer: isDesktop ? null : const AdminSideMenu(currentRoute: AppRoutes.adminJobs),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: AdminSideMenu(currentRoute: AppRoutes.adminJobs),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Manage Job Descriptions',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.adminCreateJob),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add Job Post'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (adminProvider.isLoading)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else if (adminProvider.jobs.isEmpty)
                    const Expanded(child: Center(child: Text('No job descriptions created yet.')))
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: adminProvider.jobs.length,
                        itemBuilder: (context, index) {
                          final job = adminProvider.jobs[index];
                          return JobCard(
                            job: job,
                            onEdit: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.adminEditJob,
                                arguments: job,
                              );
                            },
                            onDelete: () async {
                              final confirm = await DialogUtils.showConfirmDialog(
                                context,
                                title: 'Delete Job',
                                content: 'Are you sure you want to delete ${job.title}?',
                                isDangerous: true,
                              );
                              if (confirm && mounted) {
                                adminProvider.deleteJob(job.id);
                              }
                            },
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
