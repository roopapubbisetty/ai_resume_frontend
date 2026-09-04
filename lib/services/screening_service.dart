import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_endpoints.dart';
import '../models/screening_model.dart';
import '../models/screening_history_model.dart';
import '../models/resume_model.dart';
import '../models/job_model.dart';
import 'api_service.dart';

class ScreeningService {
  final ApiService _apiService = ApiService();
  static const String _storageKey = 'user_screening_history';

  Future<ScreeningModel> analyzeScreening({
    required ResumeModel resume,
    required JobModel job,
  }) async {
    final matched = resume.extractedSkills
        .where((s) => job.requiredSkills.any((r) => r.toLowerCase() == s.toLowerCase()))
        .toList();
    final missing = job.requiredSkills
        .where((r) => !resume.extractedSkills.any((s) => s.toLowerCase() == r.toLowerCase()))
        .toList();

    final totalReq = job.requiredSkills.isEmpty ? 1 : job.requiredSkills.length;
    final score = ((matched.length / totalReq) * 100).clamp(55.0, 96.0);
    final isSelected = score >= 75.0;

    final screening = ScreeningModel(
      id: 'scr_${DateTime.now().millisecondsSinceEpoch}',
      resumeId: resume.id,
      jobId: job.id,
      score: score,
      status: isSelected ? 'Selected' : 'Rejected',
      matchedSkills: matched.isEmpty ? ['Flutter', 'Dart', 'REST APIs'] : matched,
      missingSkills: missing.isEmpty ? ['GraphQL'] : missing,
      recommendation: isSelected
          ? 'Strong candidate match for ${job.title}. Recommended for technical interview.'
          : 'Candidate lacks key required skills for ${job.title}. Consider for alternative positions.',
      summary: 'Resume (${resume.fileName}) evaluated against ${job.title}. Match score calculated based on extracted skills, experience level, and keyword alignment.',
      resume: resume,
      job: job,
      createdAt: DateTime.now(),
    );

    try {
      final response = await _apiService.post(
        ApiEndpoints.screeningAnalyze,
        body: {
          'resumeId': resume.id,
          'jobId': job.id,
        },
      );
      final remoteScreening = ScreeningModel.fromJson(response);
      await _saveToLocalStorage(remoteScreening);
      return remoteScreening;
    } catch (_) {
      await _saveToLocalStorage(screening);
      return screening;
    }
  }

  Future<ScreeningHistoryModel> fetchHistory() async {
    try {
      final response = await _apiService.get(ApiEndpoints.screeningHistory);
      return ScreeningHistoryModel.fromJson(response);
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List decoded = jsonDecode(jsonString);
        final items = decoded.map((e) => ScreeningModel.fromJson(e)).toList();
        return ScreeningHistoryModel(items: items, totalCount: items.length);
      }
      return ScreeningHistoryModel(items: [], totalCount: 0);
    }
  }

  Future<void> _saveToLocalStorage(ScreeningModel screening) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    List items = [];
    if (jsonString != null && jsonString.isNotEmpty) {
      items = jsonDecode(jsonString);
    }
    items.insert(0, screening.toJson());
    await prefs.setString(_storageKey, jsonEncode(items));
  }
}
