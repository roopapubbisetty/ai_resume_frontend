import 'package:flutter/material.dart';
import '../models/screening_model.dart';
import '../models/screening_history_model.dart';
import '../models/resume_model.dart';
import '../models/job_model.dart';
import '../services/screening_service.dart';

class ScreeningProvider extends ChangeNotifier {
  final ScreeningService _screeningService = ScreeningService();

  ScreeningModel? _currentResult;
  ScreeningHistoryModel? _history;
  JobModel? _selectedJob;
  bool _isAnalyzing = false;
  String? _errorMessage;

  ScreeningModel? get currentResult => _currentResult;
  ScreeningHistoryModel? get history => _history;
  JobModel? get selectedJob => _selectedJob;
  bool get isAnalyzing => _isAnalyzing;
  String? get errorMessage => _errorMessage;

  void selectJob(JobModel job) {
    _selectedJob = job;
    notifyListeners();
  }

  Future<bool> runScreening({
    required ResumeModel resume,
    required JobModel job,
  }) async {
    _isAnalyzing = true;
    _errorMessage = null;
    _currentResult = null;
    notifyListeners();

    try {
      _currentResult = await _screeningService.analyzeScreening(
        resume: resume,
        job: job,
      );
      _isAnalyzing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isAnalyzing = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchHistory() async {
    try {
      _history = await _screeningService.fetchHistory();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
