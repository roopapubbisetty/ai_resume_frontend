class AppConfig {
  AppConfig._();

  static const String appName = 'AI Resume Screener';
  static const String appVersion = '1.0.0';
  static const String baseUrl = 'http://localhost:8000/api/v1';

  static const int connectTimeout = 30000; // ms
  static const int receiveTimeout = 30000; // ms

  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}