import '../config/api_endpoints.dart';
import 'api_service.dart';

class AgentService {
  final ApiService _apiService = ApiService();

  Future<String> sendMessage(
    String query, {
    required String userName,
    required int totalResumes,
    required int selectedCandidates,
    required int rejectedCandidates,
    required int totalJobs,
    required double avgScore,
    List<Map<String, String>>? history,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.agentChat,
        body: {
          'message': query,
          'user': userName,
          'stats': {
            'totalResumes': totalResumes,
            'selectedCandidates': selectedCandidates,
            'rejectedCandidates': rejectedCandidates,
            'totalJobs': totalJobs,
            'avgScore': avgScore,
          },
          'history': history ?? [],
        },
      );
      return response['reply'] ?? response['message'] ?? 'AI Agent responded successfully.';
    } catch (_) {
      final lower = query.trim().toLowerCase();

      // 1. Thank You & Courtesy Expressions (Formal & Friendly)
      if (lower.contains('thank') || lower.contains('thanks') || lower.contains('thx') || lower.contains('appreciate')) {
        return "You're very welcome, $userName! I am always happy to assist with your candidate screening and recruitment process. Let me know if you need any further information!";
      }

      // 2. Simple Acknowledgements ("ok", "okay", "got it", "sure", "cool", "great", "awesome", "perfect")
      if (lower == 'ok' || lower == 'okay' || lower == 'got it' || lower == 'sure' || lower == 'cool' || lower == 'great' || lower == 'awesome' || lower == 'perfect' || lower == 'alright') {
        return "Understood! Please feel free to ask whenever you need details on candidate resumes, shortlisted profiles, or screening scores.";
      }

      // 3. Greetings ("hi", "hello", "hey")
      if (lower == 'hi' || lower == 'hello' || lower == 'hey' || lower.startsWith('hi ') || lower.startsWith('hello ') || lower.startsWith('hey ')) {
        return 'Hello $userName! How can I assist you with your candidate evaluations and screening metrics today?';
      }

      // 4. Shortlisted / Selected Candidates (Checked BEFORE general 'resume')
      if (lower.contains('selected') || lower.contains('shortlist') || lower.contains('passed') || lower.contains('how many selected') || lower.contains('how many shortlist')) {
        if (selectedCandidates == 0) {
          return 'Currently, no candidates have been shortlisted yet. You can run AI candidate screening from the **Job Selection** page.';
        }
        return 'A total of **$selectedCandidates candidate(s)** have been shortlisted/selected based on qualification fit.';
      }

      // 5. Rejected Candidates (Checked BEFORE general 'resume')
      if (lower.contains('rejected') || lower.contains('reject') || lower.contains('failed') || lower.contains('how many reject')) {
        if (rejectedCandidates == 0) {
          return 'Currently, there are **0 rejected candidates** recorded in the system.';
        }
        return '**$rejectedCandidates candidate(s)** were categorized as rejected due to missing required skills.';
      }

      // 6. Resume Status & Counts
      if (lower.contains('status') || lower.contains('resume') || lower.contains('cv')) {
        if (totalResumes == 0) {
          return 'There are currently **no resumes** uploaded in the system. You can upload candidate resumes using the **Upload Resume** page.';
        }
        return 'There are currently **$totalResumes resume(s)** uploaded in your account system.';
      }

      // 7. Job Positions
      if (lower.contains('job') || lower.contains('post') || lower.contains('opening') || lower.contains('position')) {
        if (totalJobs == 0) {
          return 'There are currently **no active job posts**. Admin users can add new job descriptions in the Admin Portal.';
        }
        return 'You currently have **$totalJobs active job description(s)** configured for candidate screening.';
      }

      // 8. General Stats / Summary
      if (lower.contains('stat') || lower.contains('score') || lower.contains('average') || lower.contains('summary') || lower.contains('metric') || lower.contains('overview')) {
        return 'Here is your current recruitment summary:\n\n'
            '• **Total Resumes**: $totalResumes\n'
            '• **Shortlisted Candidates**: $selectedCandidates\n'
            '• **Rejected Candidates**: $rejectedCandidates\n'
            '• **Active Job Positions**: $totalJobs\n'
            '• **Average Fit Score**: ${avgScore.toStringAsFixed(1)}%';
      }

      // 9. Upload guidance
      if (lower.contains('upload') || lower.contains('add')) {
        return 'To upload candidate resumes, navigate to **My Resumes** and click **Upload New**. We support PDF, DOCX, and DOC formats up to 10MB.';
      }

      // 10. Fallback: Formal, friendly, conversational
      return 'I am glad to assist you, $userName. Feel free to ask about uploaded resumes ($totalResumes), shortlisted candidates ($selectedCandidates), active jobs ($totalJobs), or candidate fit scores!';
    }
  }
}
