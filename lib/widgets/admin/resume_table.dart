import 'package:flutter/material.dart';
import '../../models/resume_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/file_utils.dart';

class ResumeTable extends StatelessWidget {
  final List<ResumeModel> resumes;
  final Function(ResumeModel) onDelete;

  const ResumeTable({
    super.key,
    required this.resumes,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (resumes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No resumes uploaded yet.', style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('File Name', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Size', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Skills Extracted', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: resumes.map((resume) {
          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(resume.fileName),
                  ],
                ),
              ),
              DataCell(Text(FileUtils.formatBytes(resume.fileSize))),
              DataCell(Text('${resume.extractedSkills.length} skills')),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                  onPressed: () => onDelete(resume),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
