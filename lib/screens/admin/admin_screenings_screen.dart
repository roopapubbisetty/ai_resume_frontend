import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/admin_provider.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/admin/admin_side_menu.dart';
import '../../widgets/screening/screening_status_badge.dart';

class AdminScreeningsScreen extends StatefulWidget {
  const AdminScreeningsScreen({super.key});

  @override
  State<AdminScreeningsScreen> createState() => _AdminScreeningsScreenState();
}

class _AdminScreeningsScreenState extends State<AdminScreeningsScreen> {
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
      appBar: const DashboardAppBar(title: 'Admin Screenings Log'),
      drawer: isDesktop ? null : const AdminSideMenu(currentRoute: AppRoutes.adminScreenings),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: AdminSideMenu(currentRoute: AppRoutes.adminScreenings),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Screenings Record',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (adminProvider.isLoading)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else if (adminProvider.screenings.isEmpty)
                    const Expanded(child: Center(child: Text('No screenings registered yet.')))
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: adminProvider.screenings.length,
                        itemBuilder: (context, index) {
                          final item = adminProvider.screenings[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${item.score.toInt()}%'),
                              ),
                              title: Text('Evaluation ID: ${item.id}'),
                              subtitle: Text('Score: ${item.score}% • Status: ${item.status}'),
                              trailing: ScreeningStatusBadge(status: item.status),
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
