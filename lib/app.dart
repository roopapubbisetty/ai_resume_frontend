import 'package:flutter/material.dart';
import 'config/app_routes.dart';
import 'models/job_model.dart';
import 'theme/app_theme.dart';

// Auth
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

// Dashboard
import 'screens/dashboard/dashboard_screen.dart';

// Resume
import 'screens/resume/resume_upload_screen.dart';
import 'screens/resume/resume_list_screen.dart';
import 'screens/resume/resume_details_screen.dart';

// Screening
import 'screens/screening/job_selection_screen.dart';
import 'screens/screening/screening_loading_screen.dart';
import 'screens/screening/screening_result_screen.dart';
import 'screens/screening/screening_history_screen.dart';

// Report
import 'screens/report/report_screen.dart';
import 'screens/report/report_preview_screen.dart';

// Agent
import 'screens/agent/agent_chat_screen.dart';

// Profile
import 'screens/profile/profile_screen.dart';

// Admin
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_jobs_screen.dart';
import 'screens/admin/admin_create_job_screen.dart';
import 'screens/admin/admin_edit_job_screen.dart';
import 'screens/admin/admin_resumes_screen.dart';
import 'screens/admin/admin_screenings_screen.dart';
import 'screens/admin/admin_selected_screen.dart';
import 'screens/admin/admin_rejected_screen.dart';
import 'screens/admin/admin_analytics_screen.dart';

class AIResumeApp extends StatelessWidget {
  const AIResumeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Resume Screener',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case AppRoutes.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      case AppRoutes.uploadResume:
        return MaterialPageRoute(builder: (_) => const ResumeUploadScreen());

      case AppRoutes.resumeList:
        return MaterialPageRoute(builder: (_) => const ResumeListScreen());

      case AppRoutes.resumeDetails:
        return MaterialPageRoute(builder: (_) => const ResumeDetailsScreen());

      case AppRoutes.jobSelection:
        return MaterialPageRoute(builder: (_) => const JobSelectionScreen());

      case AppRoutes.screeningLoading:
        return MaterialPageRoute(builder: (_) => const ScreeningLoadingScreen());

      case AppRoutes.screeningResult:
        return MaterialPageRoute(builder: (_) => const ScreeningResultScreen());

      case AppRoutes.screeningHistory:
        return MaterialPageRoute(builder: (_) => const ScreeningHistoryScreen());

      case AppRoutes.report:
        return MaterialPageRoute(builder: (_) => const ReportScreen());

      case AppRoutes.reportPreview:
        return MaterialPageRoute(builder: (_) => const ReportPreviewScreen());

      case AppRoutes.agent:
        return MaterialPageRoute(builder: (_) => const AgentChatScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      // Admin Routes
      case AppRoutes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());

      case AppRoutes.adminJobs:
        return MaterialPageRoute(builder: (_) => const AdminJobsScreen());

      case AppRoutes.adminCreateJob:
        return MaterialPageRoute(builder: (_) => const AdminCreateJobScreen());

      case AppRoutes.adminEditJob:
        final job = settings.arguments as JobModel?;
        return MaterialPageRoute(builder: (_) => AdminEditJobScreen(job: job));

      case AppRoutes.adminResumes:
        return MaterialPageRoute(builder: (_) => const AdminResumesScreen());

      case AppRoutes.adminScreenings:
        return MaterialPageRoute(builder: (_) => const AdminScreeningsScreen());

      case AppRoutes.adminSelected:
        return MaterialPageRoute(builder: (_) => const AdminSelectedScreen());

      case AppRoutes.adminRejected:
        return MaterialPageRoute(builder: (_) => const AdminRejectedScreen());

      case AppRoutes.adminAnalytics:
        return MaterialPageRoute(builder: (_) => const AdminAnalyticsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
    }
  }
}