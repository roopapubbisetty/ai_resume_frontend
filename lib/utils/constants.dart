class AppConstants {
  AppConstants._();

  static const String appName = 'AI Resume Screener';
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;

  static const List<String> allowedFileExtensions = ['pdf', 'docx', 'doc', 'txt'];
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10MB

  static const String logoPath = 'assets/images/logo.png';
  static const String heroPath = 'assets/images/hero.png';
  static const String emptyResumePath = 'assets/images/empty_resume.png';
}
