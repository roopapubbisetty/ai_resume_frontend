import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/screening_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/file_download_utils.dart';
import '../../utils/responsive_utils.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/dashboard/side_menu.dart';
import '../../widgets/primary_button.dart';

class ReportPreviewScreen extends StatelessWidget {
  const ReportPreviewScreen({super.key});

  void _handleDownload(BuildContext context, dynamic result) async {
    final candidateName = result?.resume?.fileName ?? "Resume_Document.pdf";
    final jobTitle = result?.job?.title ?? "Target Position";
    final score = result?.score.toInt() ?? 88;
    final matched = (result?.matchedSkills as List<String>?)?.join(', ') ?? 'Flutter, Dart, REST APIs';
    final missing = (result?.missingSkills as List<String>?)?.join(', ') ?? 'GraphQL';
    final recommendation = result?.recommendation ?? 'Recommended for interview.';
    final summary = result?.summary ?? 'AI candidate screening report.';

    final reportContent = '''
================================================================
               AI RESUME CANDIDATE EVALUATION REPORT
================================================================
Date Generated  : ${DateTime.now()}
Candidate File  : $candidateName
Target Position : $jobTitle
Overall Match   : $score%

----------------------------------------------------------------
MATCHED SKILLS:
$matched

SKILL GAPS / MISSING:
$missing

----------------------------------------------------------------
AI RECOMMENDATION:
$recommendation

SUMMARY EVALUATION:
$summary
================================================================
''';

    try {
      await FileDownloadUtils.downloadReport(
        fileName: 'Evaluation_Report_${DateTime.now().millisecondsSinceEpoch}.txt',
        content: reportContent,
      );
      if (context.mounted) {
        SnackbarUtils.showSuccess(context, 'Report downloaded to your local computer!');
      }
    } catch (e) {
      if (context.mounted) {
        SnackbarUtils.showError(context, 'Failed to download report: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final screeningProvider = Provider.of<ScreeningProvider>(context);
    final result = screeningProvider.currentResult;

    return Scaffold(
      appBar: const DashboardAppBar(title: 'Report PDF Preview'),
      drawer: isDesktop ? null : const SideMenu(currentRoute: AppRoutes.report),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: SideMenu(currentRoute: AppRoutes.report),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 700),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'AI Candidate Evaluation Report',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                            Text(
                              DateTime.now().toString().split(' ')[0],
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        Text(
                          'Candidate Resume: ${result?.resume?.fileName ?? "Resume_Document.pdf"}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Target Position: ${result?.job?.title ?? "Senior Software Engineer"}'),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Overall Qualification Score:'),
                              Text(
                                '${result?.score.toInt() ?? 88}%',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Matched Core Skills:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text((result?.matchedSkills ?? ['Flutter', 'Dart', 'REST APIs', 'Python']).join(', ')),
                        const SizedBox(height: 16),
                        const Text('Skill Gaps Identified:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text((result?.missingSkills ?? ['GraphQL']).join(', ')),
                        const SizedBox(height: 20),
                        const Text('AI Recommendation:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(result?.recommendation ?? 'Highly recommended candidate for interview process.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 300,
                    child: PrimaryButton(
                      label: 'Download Report File',
                      icon: Icons.download_rounded,
                      onPressed: () => _handleDownload(context, result),
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
