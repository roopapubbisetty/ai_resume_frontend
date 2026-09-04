import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../models/resume_model.dart';
import '../../providers/resume_provider.dart';
import '../../utils/responsive_utils.dart';
import '../../utils/dialog_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/dashboard/side_menu.dart';
import '../../widgets/resume/resume_card.dart';

class ResumeListScreen extends StatefulWidget {
  const ResumeListScreen({super.key});

  @override
  State<ResumeListScreen> createState() => _ResumeListScreenState();
}

class _ResumeListScreenState extends State<ResumeListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ResumeProvider>(context, listen: false).fetchResumes();
    });
  }

  void _onDelete(ResumeModel resume) async {
    final confirm = await DialogUtils.showConfirmDialog(
      context,
      title: 'Delete Resume',
      content: 'Are you sure you want to delete ${resume.fileName}?',
      isDangerous: true,
    );

    if (confirm && mounted) {
      Provider.of<ResumeProvider>(context, listen: false).deleteResume(resume.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final resumeProvider = Provider.of<ResumeProvider>(context);

    return Scaffold(
      appBar: const DashboardAppBar(title: 'My Resumes'),
      drawer: isDesktop ? null : const SideMenu(currentRoute: AppRoutes.resumeList),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: SideMenu(currentRoute: AppRoutes.resumeList),
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
                        'Uploaded Resumes',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.uploadResume),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Upload New'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (resumeProvider.isLoading)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else if (resumeProvider.resumes.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'No resumes uploaded yet. Click Upload New to get started.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: resumeProvider.resumes.length,
                        itemBuilder: (context, index) {
                          final resume = resumeProvider.resumes[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ResumeCard(
                              resume: resume,
                              onTap: () {
                                resumeProvider.selectResume(resume);
                                Navigator.of(context).pushNamed(AppRoutes.resumeDetails);
                              },
                              onDelete: () => _onDelete(resume),
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
