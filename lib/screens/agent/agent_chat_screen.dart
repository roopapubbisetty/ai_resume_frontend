import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/resume_provider.dart';
import '../../providers/admin_provider.dart';
import '../../services/agent_service.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/agent/chat_input.dart';
import '../../widgets/agent/chat_message.dart';
import '../../widgets/agent/typing_indicator.dart';
import '../../widgets/dashboard/side_menu.dart';

class AgentChatScreen extends StatefulWidget {
  const AgentChatScreen({super.key});

  @override
  State<AgentChatScreen> createState() => _AgentChatScreenState();
}

class _AgentChatScreenState extends State<AgentChatScreen> {
  final AgentService _agentService = AgentService();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  bool _isInitialized = false;

  static const String _memoryKey = 'ai_chat_history_memory';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _initializeChat() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dashProvider = Provider.of<DashboardProvider>(context, listen: false);
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);

    await resumeProvider.fetchResumes();
    await dashProvider.fetchDashboardData();
    await adminProvider.fetchAdminData();

    final userName = authProvider.user?.fullName ?? 'User';

    if (!_isInitialized && mounted) {
      final prefs = await SharedPreferences.getInstance();
      final savedMemory = prefs.getString(_memoryKey);

      List<Map<String, dynamic>> loadedMessages = [];
      if (savedMemory != null && savedMemory.isNotEmpty) {
        try {
          final List decoded = jsonDecode(savedMemory);
          loadedMessages = decoded.map((e) {
            return {
              'text': e['text'] ?? '',
              'isUser': e['isUser'] ?? false,
              'time': e['time'] != null ? DateTime.parse(e['time']) : DateTime.now(),
            };
          }).toList();
        } catch (_) {}
      }

      // If no memory exists, add initial greeting ONCE
      if (loadedMessages.isEmpty) {
        loadedMessages.add({
          'text': 'Hi $userName, how can I help you?',
          'isUser': false,
          'time': DateTime.now(),
        });
      }

      setState(() {
        _isInitialized = true;
        _messages.clear();
        _messages.addAll(loadedMessages);
      });

      _saveMemory();
      _scrollToBottom();
    }
  }

  Future<void> _saveMemory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final serializable = _messages.map((m) {
        return {
          'text': m['text'],
          'isUser': m['isUser'],
          'time': (m['time'] as DateTime).toIso8601String(),
        };
      }).toList();
      await prefs.setString(_memoryKey, jsonEncode(serializable));
    } catch (_) {}
  }

  void _clearMemory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_memoryKey);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userName = authProvider.user?.fullName ?? 'User';

    setState(() {
      _messages.clear();
      _messages.add({
        'text': 'Hi $userName, how can I help you?',
        'isUser': false,
        'time': DateTime.now(),
      });
    });
    _saveMemory();
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

    _saveMemory();
    _scrollToBottom();

    // Prepare history for model context
    final historyList = _messages.map((m) {
      return {
        'role': m['isUser'] == true ? 'user' : 'assistant',
        'content': m['text'].toString(),
      };
    }).toList();

    final reply = await _agentService.sendMessage(
      text,
      userName: userName,
      totalResumes: resumeProvider.resumes.length,
      selectedCandidates: data?.selectedCandidates ?? 0,
      rejectedCandidates: data?.rejectedCandidates ?? 0,
      totalJobs: adminProvider.jobs.length,
      avgScore: data?.averageMatchScore ?? 0.0,
      history: historyList.map((e) => Map<String, String>.from(e)).toList(),
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

      _saveMemory();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Career Assistant'),
        actions: [
          IconButton(
            tooltip: 'Clear Chat Memory',
            icon: const Icon(Icons.delete_sweep_rounded, color: AppColors.error),
            onPressed: _clearMemory,
          ),
          const SizedBox(width: 8),
        ],
      ),
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
                    controller: _scrollController,
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
