import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/dashboard/side_menu.dart';
import '../../widgets/primary_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: const DashboardAppBar(title: 'User Profile'),
      drawer: isDesktop ? null : const SideMenu(currentRoute: AppRoutes.profile),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: SideMenu(currentRoute: AppRoutes.profile),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.primaryLight,
                            child: Text(
                              user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'U',
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user?.fullName ?? 'User Profile',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user?.email ?? 'email@domain.com',
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          Chip(
                            label: Text(
                              user?.role.toUpperCase() ?? 'USER',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
                            ),
                            backgroundColor: AppColors.primaryLight,
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.security_rounded),
                            title: const Text('Account Security'),
                            subtitle: const Text('Password and authentication settings'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: const Icon(Icons.notifications_rounded),
                            title: const Text('Notifications'),
                            subtitle: const Text('Email and screening alerts'),
                            onTap: () {},
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            label: 'Log Out',
                            onPressed: () async {
                              await authProvider.logout();
                              if (context.mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
