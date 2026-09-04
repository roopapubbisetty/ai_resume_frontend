import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../theme/app_colors.dart';

class ResumeFilePicker extends StatelessWidget {
  final Function(PlatformFile file) onFilePicked;

  const ResumeFilePicker({
    super.key,
    required this.onFilePicked,
  });

  Future<void> _pickFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        onFilePicked(result.files.first);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _pickFile(context),
      icon: const Icon(Icons.folder_open_rounded),
      label: const Text('Browse Device Files'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
