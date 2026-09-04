import 'package:flutter/material.dart';
import '../models/resume_model.dart';
import '../services/resume_service.dart';

class ResumeProvider extends ChangeNotifier {
  final ResumeService _resumeService = ResumeService();

  List<ResumeModel> _resumes = [];
  ResumeModel? _selectedResume;
  bool _isLoading = false;
  String? _errorMessage;

  List<ResumeModel> get resumes => _resumes;
  ResumeModel? get selectedResume => _selectedResume;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchResumes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _resumes = await _resumeService.fetchResumes();
      if (_resumes.isNotEmpty && _selectedResume == null) {
        _selectedResume = _resumes.first;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectResume(ResumeModel resume) {
    _selectedResume = resume;
    notifyListeners();
  }

  Future<bool> uploadResume({
    required String fileName,
    required List<int> bytes,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newResume = await _resumeService.uploadResume(
        fileName: fileName,
        bytes: bytes,
      );
      _resumes.insert(0, newResume);
      _selectedResume = newResume;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteResume(String id) async {
    try {
      await _resumeService.deleteResume(id);
      _resumes.removeWhere((r) => r.id == id);
      if (_selectedResume?.id == id) {
        _selectedResume = _resumes.isNotEmpty ? _resumes.first : null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
