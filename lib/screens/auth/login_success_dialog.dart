import 'package:flutter/material.dart';
import '../../config/app_routes.dart';
import '../../theme/app_colors.dart';

class LoginSuccessDialog extends StatelessWidget {
  final String userName;

  const LoginSuccessDialog({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome, $userName!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You have successfully logged into AI Resume Screener.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
              },
              child: const Text('Proceed to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
