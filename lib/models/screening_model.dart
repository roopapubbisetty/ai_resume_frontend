import 'resume_model.dart';
import 'job_model.dart';

class ScreeningModel {
  final String id;
  final String resumeId;
  final String jobId;
  final double score; // 0 - 100
  final String status; // 'Selected' | 'Rejected' | 'Pending'
  final List<String> matchedSkills;
  final List<String> missingSkills;
  final String recommendation;
  final String summary;
  final ResumeModel? resume;
  final JobModel? job;
  final DateTime createdAt;

  ScreeningModel({
    required this.id,
    required this.resumeId,
    required this.jobId,
    required this.score,
    required this.status,
    required this.matchedSkills,
    required this.missingSkills,
    required this.recommendation,
    required this.summary,
    this.resume,
    this.job,
    required this.createdAt,
  });

  factory ScreeningModel.fromJson(Map<String, dynamic> json) {
    return ScreeningModel(
      id: json['id'] ?? '',
      resumeId: json['resumeId'] ?? json['resume_id'] ?? '',
      jobId: json['jobId'] ?? json['job_id'] ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Pending',
      matchedSkills: List<String>.from(json['matchedSkills'] ?? json['matched_skills'] ?? []),
      missingSkills: List<String>.from(json['missingSkills'] ?? json['missing_skills'] ?? []),
      recommendation: json['recommendation'] ?? '',
      summary: json['summary'] ?? '',
      resume: json['resume'] != null ? ResumeModel.fromJson(json['resume']) : null,
      job: json['job'] != null ? JobModel.fromJson(json['job']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resumeId': resumeId,
      'jobId': jobId,
      'score': score,
      'status': status,
      'matchedSkills': matchedSkills,
      'missingSkills': missingSkills,
      'recommendation': recommendation,
      'summary': summary,
      'resume': resume?.toJson(),
      'job': job?.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
