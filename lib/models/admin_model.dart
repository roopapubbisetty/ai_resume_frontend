class AdminAnalyticsModel {
  final int totalUsers;
  final int totalJobs;
  final int totalResumes;
  final int totalScreenings;
  final int selectedCount;
  final int rejectedCount;
  final double averageScore;
  final Map<String, int> monthlyScreenings;

  AdminAnalyticsModel({
    required this.totalUsers,
    required this.totalJobs,
    required this.totalResumes,
    required this.totalScreenings,
    required this.selectedCount,
    required this.rejectedCount,
    required this.averageScore,
    required this.monthlyScreenings,
  });

  factory AdminAnalyticsModel.fromJson(Map<String, dynamic> json) {
    Map<String, int> monthlyMap = {};
    if (json['monthlyScreenings'] != null) {
      (json['monthlyScreenings'] as Map<String, dynamic>).forEach((key, value) {
        monthlyMap[key] = (value as num).toInt();
      });
    }

    return AdminAnalyticsModel(
      totalUsers: json['totalUsers'] ?? 0,
      totalJobs: json['totalJobs'] ?? 0,
      totalResumes: json['totalResumes'] ?? 0,
      totalScreenings: json['totalScreenings'] ?? 0,
      selectedCount: json['selectedCount'] ?? 0,
      rejectedCount: json['rejectedCount'] ?? 0,
      averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0.0,
      monthlyScreenings: monthlyMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'totalJobs': totalJobs,
      'totalResumes': totalResumes,
      'totalScreenings': totalScreenings,
      'selectedCount': selectedCount,
      'rejectedCount': rejectedCount,
      'averageScore': averageScore,
      'monthlyScreenings': monthlyScreenings,
    };
  }
}
