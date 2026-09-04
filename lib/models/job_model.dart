class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final List<String> requiredSkills;
  final List<String> preferredSkills;
  final String minExperience;
  final String status; // 'active' | 'closed'
  final DateTime createdAt;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.requiredSkills,
    required this.preferredSkills,
    required this.minExperience,
    this.status = 'active',
    required this.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      requiredSkills: List<String>.from(json['requiredSkills'] ?? json['required_skills'] ?? []),
      preferredSkills: List<String>.from(json['preferredSkills'] ?? json['preferred_skills'] ?? []),
      minExperience: json['minExperience']?.toString() ?? json['min_experience']?.toString() ?? '0',
      status: json['status'] ?? 'active',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'requiredSkills': requiredSkills,
      'preferredSkills': preferredSkills,
      'minExperience': minExperience,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}