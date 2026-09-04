class ResumeModel {
  final String id;
  final String userId;
  final String fileName;
  final String fileUrl;
  final int fileSize;
  final String? parsedContent;
  final List<String> extractedSkills;
  final String? experienceYears;
  final DateTime uploadedAt;

  ResumeModel({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.fileUrl,
    required this.fileSize,
    this.parsedContent,
    required this.extractedSkills,
    this.experienceYears,
    required this.uploadedAt,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? json['user_id'] ?? '',
      fileName: json['fileName'] ?? json['file_name'] ?? '',
      fileUrl: json['fileUrl'] ?? json['file_url'] ?? '',
      fileSize: json['fileSize'] ?? json['file_size'] ?? 0,
      parsedContent: json['parsedContent'] ?? json['parsed_content'],
      extractedSkills: List<String>.from(json['extractedSkills'] ?? json['extracted_skills'] ?? []),
      experienceYears: json['experienceYears']?.toString() ?? json['experience_years']?.toString(),
      uploadedAt: json['uploadedAt'] != null
          ? DateTime.parse(json['uploadedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileSize': fileSize,
      'parsedContent': parsedContent,
      'extractedSkills': extractedSkills,
      'experienceYears': experienceYears,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}