import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/resume_provider.dart';
import '../../providers/admin_provider.dart';
import '../../services/agent_service.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/agent/chat_input.dart';
import '../../widgets/agent/chat_message.dart';
import '../../widgets/agent/typing_indicator.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/dashboard/side_menu.dart';

class AgentChatScreen extends StatefulWidget {
  const AgentChatScreen({super.key});

  @override
  State<AgentChatScreen> createState() => _AgentChatScreenState();
}

class _AgentChatScreenState extends State<AgentChatScreen> {
  final AgentService _agentService = AgentService();
  final TextEditingController _inputController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  void _initializeChat() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dashProvider = Provider.of<DashboardProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);

    await resumeProvider.fetchResumes();
    await dashProvider.fetchDashboardData();
    await adminProvider.fetchAdminData();

    final userName = authProvider.user?.fullName ?? 'User';

    if (!_isInitialized && mounted) {
      setState(() {
        _isInitialized = true;
        _messages.add({
          'text': 'Hi $userName, how can I help you?',
          'isUser': false,
          'time': DateTime.now(),
        });
      });
    }
  }

  void _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dashProvider = Provider.of<DashboardProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);

    final userName = authProvider.user?.fullName ?? 'User';
    final data = dashProvider.dashboardData;

    _inputController.clear();
    setState(() {
      _messages.add({
        'text': text,
        'isUser': true,
        'time': DateTime.now(),
      });
      _isTyping = true;
    });

    final reply = await _agentService.sendMessage(
      text,
      userName: userName,
      totalResumes: resumeProvider.resumes.length,
      selectedCandidates: data?.selectedCandidates ?? 0,
      rejectedCandidates: data?.rejectedCandidates ?? 0,
      totalJobs: adminProvider.jobs.length,
      avgScore: data?.averageMatchScore ?? 0.0,
    );

    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add({
          'text': reply,
          'isUser': false,
          'time': DateTime.now(),
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Scaffold(
      appBar: const DashboardAppBar(title: 'AI Career Assistant'),
      drawer: isDesktop ? null : const SideMenu(currentRoute: AppRoutes.agent),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: SideMenu(currentRoute: AppRoutes.agent),
            ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return ChatMessage(
                        text: msg['text'],
                        isUser: msg['isUser'],
                        timestamp: msg['time'],
                      );
                    },
                  ),
                ),
                if (_isTyping) const TypingIndicator(),
                const Divider(height: 1),
                ChatInput(
                  controller: _inputController,
                  onSend: _sendMessage,
                  isLoading: _isTyping,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
