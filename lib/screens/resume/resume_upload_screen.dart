import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../providers/resume_provider.dart';
import '../../utils/responsive_utils.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/dashboard/side_menu.dart';
import '../../widgets/resume/resume_upload_card.dart';
import '../../widgets/resume/resume_file_picker.dart';
import '../../widgets/primary_button.dart';

class ResumeUploadScreen extends StatefulWidget {
  const ResumeUploadScreen({super.key});

  @override
  State<ResumeUploadScreen> createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends State<ResumeUploadScreen> {
  PlatformFile? _selectedFile;

  void _onFileSelected(PlatformFile file) {
    setState(() {
      _selectedFile = file;
    });
  }

  void _handleUpload() async {
    if (_selectedFile == null) {
      SnackbarUtils.showError(context, 'Please select a resume file first.');
      return;
    }

    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    final List<int> bytes = _selectedFile!.bytes?.toList() ?? [];

    final success = await resumeProvider.uploadResume(
      fileName: _selectedFile!.name,
      bytes: bytes,
    );

    if (success && mounted) {
      SnackbarUtils.showSuccess(context, 'Resume uploaded and parsed successfully!');
      Navigator.of(context).pushReplacementNamed(AppRoutes.resumeList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final resumeProvider = Provider.of<ResumeProvider>(context);

    return Scaffold(
      appBar: const DashboardAppBar(title: 'Upload Resume'),
      drawer: isDesktop ? null : const SideMenu(currentRoute: AppRoutes.uploadResume),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: SideMenu(currentRoute: AppRoutes.uploadResume),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Upload Candidate Resume',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Select a resume in PDF or DOCX format to parse skills and prepare for AI screening.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ResumeUploadCard(
                        onTap: () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'docx', 'doc'],
                            withData: true,
                          );
                          if (result != null && result.files.isNotEmpty) {
                            _onFileSelected(result.files.first);
                          }
                        },
                        selectedFileName: _selectedFile?.name,
                        isUploading: resumeProvider.isLoading,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ResumeFilePicker(onFilePicked: _onFileSelected),
                      ),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        label: 'Upload & Parse Resume',
                        isLoading: resumeProvider.isLoading,
                        onPressed: _selectedFile != null ? _handleUpload : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
