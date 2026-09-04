import 'screening_model.dart';
import 'resume_model.dart';

class DashboardModel {
  final int totalResumes;
  final int totalScreenings;
  final int selectedCandidates;
  final int rejectedCandidates;
  final double averageMatchScore;
  final List<ScreeningModel> recentScreenings;
  final List<ResumeModel> recentResumes;

  DashboardModel({
    required this.totalResumes,
    required this.totalScreenings,
    required this.selectedCandidates,
    required this.rejectedCandidates,
    required this.averageMatchScore,
    required this.recentScreenings,
    required this.recentResumes,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    var rawScreenings = json['recentScreenings'] as List? ?? [];
    var rawResumes = json['recentResumes'] as List? ?? [];

    return DashboardModel(
      totalResumes: json['totalResumes'] ?? 0,
      totalScreenings: json['totalScreenings'] ?? 0,
      selectedCandidates: json['selectedCandidates'] ?? 0,
      rejectedCandidates: json['rejectedCandidates'] ?? 0,
      averageMatchScore: (json['averageMatchScore'] as num?)?.toDouble() ?? 0.0,
      recentScreenings: rawScreenings.map((e) => ScreeningModel.fromJson(e)).toList(),
      recentResumes: rawResumes.map((e) => ResumeModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalResumes': totalResumes,
      'totalScreenings': totalScreenings,
      'selectedCandidates': selectedCandidates,
      'rejectedCandidates': rejectedCandidates,
      'averageMatchScore': averageMatchScore,
      'recentScreenings': recentScreenings.map((e) => e.toJson()).toList(),
      'recentResumes': recentResumes.map((e) => e.toJson()).toList(),
    };
  }
}
