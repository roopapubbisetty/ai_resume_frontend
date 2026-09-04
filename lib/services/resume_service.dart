import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_endpoints.dart';
import '../models/resume_model.dart';
import 'api_service.dart';

class ResumeService {
  final ApiService _apiService = ApiService();
  static const String _storageKey = 'user_uploaded_resumes';

  Future<List<ResumeModel>> fetchResumes() async {
    try {
      final response = await _apiService.get(ApiEndpoints.resumes);
      final list = (response as List).map((e) => ResumeModel.fromJson(e)).toList();
      return list;
    } catch (_) {
      // Load saved resumes from local storage (starts empty with NO predefined resumes)
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List decoded = jsonDecode(jsonString);
        return decoded.map((e) => ResumeModel.fromJson(e)).toList();
      }
      return [];
    }
  }

  Future<ResumeModel> uploadResume({
    required String fileName,
    required List<int> bytes,
  }) async {
    final newResume = ResumeModel(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'u_1',
      fileName: fileName,
      fileUrl: 'https://example.com/resumes/$fileName',
      fileSize: bytes.length,
      parsedContent: 'Parsed text extracted from $fileName: Professional candidate details, technical skills, project history, and experience summary.',
      extractedSkills: ['Flutter', 'Dart', 'Python', 'REST APIs', 'SQL', 'Git'],
      experienceYears: '3+',
      uploadedAt: DateTime.now(),
    );

    try {
      final response = await _apiService.post(
        ApiEndpoints.resumeUpload,
        body: {'fileName': fileName, 'size': bytes.length},
      );
      final created = ResumeModel.fromJson(response);
      await _saveToLocalStorage(created);
      return created;
    } catch (_) {
      await _saveToLocalStorage(newResume);
      return newResume;
    }
  }

  Future<bool> deleteResume(String id) async {
    try {
      await _apiService.delete(ApiEndpoints.resumeDelete(id));
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      final List decoded = jsonDecode(jsonString);
      decoded.removeWhere((item) => item['id'] == id);
      await prefs.setString(_storageKey, jsonEncode(decoded));
    }
    return true;
  }

  Future<void> _saveToLocalStorage(ResumeModel resume) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    List items = [];
    if (jsonString != null && jsonString.isNotEmpty) {
      items = jsonDecode(jsonString);
    }
    items.insert(0, resume.toJson());
    await prefs.setString(_storageKey, jsonEncode(items));
  }
}