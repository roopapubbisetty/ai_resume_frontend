class ApiEndpoints {
  ApiEndpoints._();

  // Authentication
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String currentUser = '/auth/me';

  // Resumes
  static const String resumes = '/resumes';
  static const String resumeUpload = '/resumes/upload';
  static String resumeDetail(String id) => '/resumes/$id';
  static String resumeDelete(String id) => '/resumes/$id';

  // Jobs
  static const String jobs = '/jobs';
  static String jobDetail(String id) => '/jobs/$id';

  // Screening
  static const String screening = '/screening';
  static const String screeningAnalyze = '/screening/analyze';
  static const String screeningHistory = '/screening/history';
  static String screeningDetail(String id) => '/screening/$id';

  // Reports
  static String reportGenerate(String screeningId) => '/reports/generate/$screeningId';
  static String reportDownload(String screeningId) => '/reports/download/$screeningId';

  // AI Agent
  static const String agentChat = '/agent/chat';
  static const String agentHistory = '/agent/history';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminJobs = '/admin/jobs';
  static String adminJobDetail(String id) => '/admin/jobs/$id';
  static const String adminResumes = '/admin/resumes';
  static const String adminScreenings = '/admin/screenings';
  static const String adminSelected = '/admin/selected-candidates';
  static const String adminRejected = '/admin/rejected-candidates';
  static const String adminAnalytics = '/admin/analytics';
}