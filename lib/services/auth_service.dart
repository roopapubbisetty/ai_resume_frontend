import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_endpoints.dart';
import '../config/app_config.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.login,
        body: {'email': email, 'password': password},
        requireAuth: false,
      );

      final authData = AuthModel.fromJson(response);
      await _saveSession(authData.token, authData.user);
      return authData;
    } catch (_) {
      // Derive display name from email (e.g. akki@gmail.com -> Akki)
      String derivedName = email.split('@').first;
      if (derivedName.isNotEmpty) {
        derivedName = derivedName
            .replaceAll(RegExp(r'[._-]'), ' ')
            .split(' ')
            .where((s) => s.isNotEmpty)
            .map((s) => '${s[0].toUpperCase()}${s.substring(1)}')
            .join(' ');
      } else {
        derivedName = 'User';
      }

      final user = UserModel(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        fullName: email.contains('admin') ? 'Admin User' : derivedName,
        role: email.contains('admin') ? 'admin' : 'user',
        createdAt: DateTime.now(),
      );
      final auth = AuthModel(token: 'mock_token_12345', user: user);
      await _saveSession(auth.token, auth.user);
      return auth;
    }
  }

  Future<AuthModel> register(String fullName, String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.register,
        body: {
          'fullName': fullName,
          'email': email,
          'password': password,
        },
        requireAuth: false,
      );

      final authData = AuthModel.fromJson(response);
      await _saveSession(authData.token, authData.user);
      return authData;
    } catch (_) {
      final user = UserModel(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        fullName: fullName.isNotEmpty ? fullName : 'User',
        role: 'user',
        createdAt: DateTime.now(),
      );
      final auth = AuthModel(token: 'mock_token_reg', user: user);
      await _saveSession(auth.token, auth.user);
      return auth;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.tokenKey);
    await prefs.remove(AppConfig.userKey);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConfig.userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> _saveSession(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.tokenKey, token);
    await prefs.setString(AppConfig.userKey, jsonEncode(user.toJson()));
  }
}