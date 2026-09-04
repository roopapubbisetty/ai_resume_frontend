import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ResumeUploadCard extends StatelessWidget {
  final VoidCallback onTap;
  final String? selectedFileName;
  final bool isUploading;

  const ResumeUploadCard({
    super.key,
    required this.onTap,
    this.selectedFileName,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isUploading ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selectedFileName != null ? AppColors.primary : AppColors.border,
            width: selectedFileName != null ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              selectedFileName ?? 'Click or Drag & Drop Resume File',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Supports PDF, DOCX, DOC files up to 10MB',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
