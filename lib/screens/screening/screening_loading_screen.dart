import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/resume_provider.dart';
import '../../providers/screening_provider.dart';
import '../../theme/app_colors.dart';

class ScreeningLoadingScreen extends StatefulWidget {
  const ScreeningLoadingScreen({super.key});

  @override
  State<ScreeningLoadingScreen> createState() => _ScreeningLoadingScreenState();
}

class _ScreeningLoadingScreenState extends State<ScreeningLoadingScreen> {
  String _currentStep = 'Parsing resume text & structure...';

  @override
  void initState() {
    super.initState();
    _executeScreening();
  }

  void _executeScreening() async {
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    final screeningProvider = Provider.of<ScreeningProvider>(context, listen: false);

    final resume = resumeProvider.selectedResume;
    final job = screeningProvider.selectedJob;

    if (resume != null && job != null) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _currentStep = 'Extracting candidate skills and experience...');

      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _currentStep = 'Comparing against target job requirements...');

      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _currentStep = 'Calculating final match score and recommendation...');

      final success = await screeningProvider.runScreening(resume: resume, job: job);

      if (success && mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.screeningResult);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'AI Screening Engine Active',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                _currentStep,
                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const SizedBox(
                width: 200,
                child: LinearProgressIndicator(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
