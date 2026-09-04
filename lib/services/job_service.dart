import '../config/api_endpoints.dart';
import '../models/job_model.dart';
import 'api_service.dart';

class JobService {
  final ApiService _apiService = ApiService();

  Future<List<JobModel>> fetchJobs() async {
    try {
      final response = await _apiService.get(ApiEndpoints.jobs);
      return (response as List).map((e) => JobModel.fromJson(e)).toList();
    } catch (_) {
      // Mock jobs
      return [
        JobModel(
          id: 'job_1',
          title: 'Senior Flutter Developer',
          company: 'TechCorp Solutions',
          location: 'San Francisco, CA (Remote)',
          description: 'Looking for a Senior Flutter Developer with 4+ years experience building mobile & web apps.',
          requiredSkills: ['Flutter', 'Dart', 'REST APIs', 'State Management'],
          preferredSkills: ['Firebase', 'CI/CD', 'GraphQL'],
          minExperience: '4',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        JobModel(
          id: 'job_2',
          title: 'AI / Machine Learning Engineer',
          company: 'AI Research Lab',
          location: 'New York, NY',
          description: 'Join our cutting-edge AI team working on LLMs, resume parsers, and automated screening engines.',
          requiredSkills: ['Python', 'PyTorch', 'NLP', 'Scikit-learn'],
          preferredSkills: ['Docker', 'FastAPI', 'LangChain'],
          minExperience: '3',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
        JobModel(
          id: 'job_3',
          title: 'Full Stack Engineer',
          company: 'InnoTech',
          location: 'Austin, TX',
          description: 'Build robust web and backend infrastructure supporting real-time data pipelines.',
          requiredSkills: ['React', 'Node.js', 'PostgreSQL', 'TypeScript'],
          preferredSkills: ['AWS', 'Docker', 'Redis'],
          minExperience: '2',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
      ];
    }
  }

  Future<JobModel> createJob(JobModel job) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.adminJobs,
        body: job.toJson(),
      );
      return JobModel.fromJson(response);
    } catch (_) {
      return job;
    }
  }

  Future<JobModel> updateJob(JobModel job) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.adminJobDetail(job.id),
        body: job.toJson(),
      );
      return JobModel.fromJson(response);
    } catch (_) {
      return job;
    }
  }

  Future<bool> deleteJob(String id) async {
    try {
      await _apiService.delete(ApiEndpoints.adminJobDetail(id));
      return true;
    } catch (_) {
      return true;
    }
  }
}