import 'package:flutter/material.dart';
import '../../config/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const AppLogo(),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
            child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
              child: const Text('Get Started'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '🚀 Next-Gen AI Resume Screener',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'AI-Powered Candidate Screening &\nResume Analytics',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Automatically match candidate resumes with target job requirements using artificial intelligence. Generate instant scores, skill gap analyses, and detailed reports.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    child: PrimaryButton(
                      label: 'Start Screening',
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 160,
                    child: SecondaryButton(
                      label: 'View Features',
                      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.register),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              const Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  _FeatureCard(
                    icon: Icons.psychology_rounded,
                    title: 'Smart Matching',
                    description: 'Extract skills and calculate candidate fit percentage instantly.',
                  ),
                  _FeatureCard(
                    icon: Icons.analytics_rounded,
                    title: 'Detailed Reports',
                    description: 'Generate PDF reports summarizing strengths, gaps, and recommendations.',
                  ),
                  _FeatureCard(
                    icon: Icons.smart_toy_rounded,
                    title: 'AI Career Agent',
                    description: 'Interactive AI assistant to guide screening and resume optimizations.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}