class AppRoutes {
  AppRoutes._();

  static const String home = '/';

  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Dashboard
  static const String dashboard = '/dashboard';

  // Resume
  static const String uploadResume = '/upload-resume';
  static const String resumeList = '/resumes';
  static const String resumeDetails = '/resume-details';

  // Screening
  static const String jobSelection = '/job-selection';
  static const String screeningLoading = '/screening-loading';
  static const String screeningResult = '/screening-result';
  static const String screeningHistory = '/screening-history';

  // Report
  static const String report = '/report';
  static const String reportPreview = '/report-preview';

  // Agent
  static const String agent = '/agent';

  // Profile
  static const String profile = '/profile';

  // Admin
  static const String adminDashboard = '/admin';
  static const String adminJobs = '/admin/jobs';
  static const String adminCreateJob = '/admin/jobs/create';
  static const String adminEditJob = '/admin/jobs/edit';
  static const String adminResumes = '/admin/resumes';
  static const String adminScreenings = '/admin/screenings';
  static const String adminSelected = '/admin/selected';
  static const String adminRejected = '/admin/rejected';
  static const String adminAnalytics = '/admin/analytics';
}