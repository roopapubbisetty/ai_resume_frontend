import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import '../services/resume_service.dart';
import '../services/screening_service.dart';

class DashboardProvider extends ChangeNotifier {
  final ResumeService _resumeService = ResumeService();
  final ScreeningService _screeningService = ScreeningService();

  DashboardModel? _dashboardData;
  bool _isLoading = false;
  String? _errorMessage;

  DashboardModel? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final resumes = await _resumeService.fetchResumes();
      final history = await _screeningService.fetchHistory();

      final selectedCount = history.items.where((i) => i.status == 'Selected').length;
      final rejectedCount = history.items.where((i) => i.status == 'Rejected').length;
      final avgScore = history.items.isEmpty
          ? 0.0
          : history.items.map((e) => e.score).reduce((a, b) => a + b) / history.items.length;

      _dashboardData = DashboardModel(
        totalResumes: resumes.length,
        totalScreenings: history.items.length,
        selectedCandidates: selectedCount,
        rejectedCandidates: rejectedCount,
        averageMatchScore: avgScore,
        recentScreenings: history.items,
        recentResumes: resumes,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
