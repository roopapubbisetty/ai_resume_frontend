import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../models/job_model.dart';
import '../../providers/admin_provider.dart';
import '../../providers/resume_provider.dart';
import '../../providers/screening_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/dashboard/side_menu.dart';
import '../../widgets/primary_button.dart';

class JobSelectionScreen extends StatefulWidget {
  const JobSelectionScreen({super.key});

  @override
  State<JobSelectionScreen> createState() => _JobSelectionScreenState();
}

class _JobSelectionScreenState extends State<JobSelectionScreen> {
  JobModel? _selectedJob;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchAdminData();
      Provider.of<ResumeProvider>(context, listen: false).fetchResumes();
    });
  }

  void _startScreening() {
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    final screeningProvider = Provider.of<ScreeningProvider>(context, listen: false);

    if (_selectedJob != null && resumeProvider.selectedResume != null) {
      screeningProvider.selectJob(_selectedJob!);
      Navigator.of(context).pushNamed(AppRoutes.screeningLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final adminProvider = Provider.of<AdminProvider>(context);
    final resumeProvider = Provider.of<ResumeProvider>(context);
    final selectedResume = resumeProvider.selectedResume;

    return Scaffold(
      appBar: const DashboardAppBar(title: 'Job Selection'),
      drawer: isDesktop ? null : const SideMenu(currentRoute: AppRoutes.jobSelection),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: SideMenu(currentRoute: AppRoutes.jobSelection),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Target Job Opening',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Choose an active job description to analyze your active resume against required skills.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  if (selectedResume != null)
                    Card(
                      color: AppColors.primaryLight.withOpacity(0.5),
                      child: ListTile(
                        leading: const Icon(Icons.description_rounded, color: AppColors.primary),
                        title: Text('Active Resume: ${selectedResume.fileName}'),
                        subtitle: Text('Skills: ${selectedResume.extractedSkills.join(", ")}'),
                        trailing: TextButton(
                          onPressed: () => Navigator.of(context).pushNamed(AppRoutes.resumeList),
                          child: const Text('Change'),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (adminProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (adminProvider.jobs.isEmpty)
                    const Text('No job postings available.')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: adminProvider.jobs.length,
                      itemBuilder: (context, index) {
                        final job = adminProvider.jobs[index];
                        final isSelected = _selectedJob?.id == job.id;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              setState(() {
                                _selectedJob = job;
                              });
                            },
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(job.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('${job.company} • ${job.location}'),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  children: job.requiredSkills.map((s) => Chip(label: Text(s, style: const TextStyle(fontSize: 10)))).toList(),
                                ),
                              ],
                            ),
                            trailing: Radio<String>(
                              value: job.id,
                              groupValue: _selectedJob?.id,
                              onChanged: (_) {
                                setState(() {
                                  _selectedJob = job;
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Run AI Candidate Screening',
                    icon: Icons.auto_awesome_rounded,
                    onPressed: _selectedJob != null && selectedResume != null ? _startScreening : null,
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
