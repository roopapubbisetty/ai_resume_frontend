import 'package:flutter/material.dart';
import '../../models/resume_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/file_utils.dart';

class ResumeCard extends StatelessWidget {
  final ResumeModel resume;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ResumeCard({
    super.key,
    required this.resume,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary),
        ),
        title: Text(
          resume.fileName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Size: ${FileUtils.formatBytes(resume.fileSize)} • Skills: ${resume.extractedSkills.length}',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                onPressed: onDelete,
              )
            : isSelected
                ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                : null,
      ),
    );
  }
}
