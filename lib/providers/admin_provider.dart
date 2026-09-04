import 'package:flutter/material.dart';
import '../models/job_model.dart';
import '../models/resume_model.dart';
import '../models/screening_model.dart';
import '../models/admin_model.dart';
import '../services/job_service.dart';
import '../services/resume_service.dart';
import '../services/screening_service.dart';

class AdminProvider extends ChangeNotifier {
  final JobService _jobService = JobService();
  final ResumeService _resumeService = ResumeService();
  final ScreeningService _screeningService = ScreeningService();

  List<JobModel> _jobs = [];
  List<ResumeModel> _resumes = [];
  List<ScreeningModel> _screenings = [];
  AdminAnalyticsModel? _analytics;
  bool _isLoading = false;
  String? _errorMessage;

  List<JobModel> get jobs => _jobs;
  List<ResumeModel> get resumes => _resumes;
  List<ScreeningModel> get screenings => _screenings;
  List<ScreeningModel> get selectedCandidates => _screenings.where((s) => s.status == 'Selected').toList();
  List<ScreeningModel> get rejectedCandidates => _screenings.where((s) => s.status == 'Rejected').toList();
  AdminAnalyticsModel? get analytics => _analytics;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAdminData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _jobs = await _jobService.fetchJobs();
      _resumes = await _resumeService.fetchResumes();
      final history = await _screeningService.fetchHistory();
      _screenings = history.items;

      final avg = _screenings.isEmpty
          ? 0.0
          : _screenings.map((e) => e.score).reduce((a, b) => a + b) / _screenings.length;

      _analytics = AdminAnalyticsModel(
        totalUsers: 1,
        totalJobs: _jobs.length,
        totalResumes: _resumes.length,
        totalScreenings: _screenings.length,
        selectedCount: selectedCandidates.length,
        rejectedCount: rejectedCandidates.length,
        averageScore: avg,
        monthlyScreenings: {'Jan': 0, 'Feb': 0, 'Mar': 0, 'Apr': _screenings.length},
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createJob(JobModel job) async {
    try {
      final created = await _jobService.createJob(job);
      _jobs.insert(0, created);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateJob(JobModel job) async {
    try {
      final updated = await _jobService.updateJob(job);
      final index = _jobs.indexWhere((j) => j.id == job.id);
      if (index != -1) {
        _jobs[index] = updated;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteJob(String id) async {
    try {
      await _jobService.deleteJob(id);
      _jobs.removeWhere((j) => j.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
