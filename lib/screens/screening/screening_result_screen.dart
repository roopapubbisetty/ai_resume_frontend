import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/screening_provider.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/dashboard/side_menu.dart';
import '../../widgets/screening/score_card.dart';
import '../../widgets/screening/matched_skills_card.dart';
import '../../widgets/screening/missing_skills_card.dart';
import '../../widgets/screening/recommendation_card.dart';
import '../../widgets/screening/screening_status_badge.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';

class ScreeningResultScreen extends StatelessWidget {
  const ScreeningResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final screeningProvider = Provider.of<ScreeningProvider>(context);
    final result = screeningProvider.currentResult;

    if (result == null) {
      return const Scaffold(
        appBar: DashboardAppBar(title: 'Screening Result'),
        body: Center(child: Text('No screening result available.')),
      );
    }

    return Scaffold(
      appBar: const DashboardAppBar(title: 'Screening Evaluation'),
      drawer: isDesktop ? null : const SideMenu(currentRoute: AppRoutes.screeningResult),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: SideMenu(currentRoute: AppRoutes.screeningResult),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AI Analysis Complete',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Target Role: ${result.job?.title ?? "Position"}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      ScreeningStatusBadge(status: result.status),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ScoreCard(score: result.score),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: RecommendationCard(
                          recommendation: result.recommendation,
                          summary: result.summary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: MatchedSkillsCard(skills: result.matchedSkills),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MissingSkillsCard(skills: result.missingSkills),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Generate & View PDF Report',
                          icon: Icons.picture_as_pdf_rounded,
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.reportPreview);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SecondaryButton(
                          label: 'Back to Job Selection',
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(AppRoutes.jobSelection);
                          },
                        ),
                      ),
                    ],
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
