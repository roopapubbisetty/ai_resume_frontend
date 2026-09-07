import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class MissingSkillsCard extends StatelessWidget {
  final List<String> skills;

  const MissingSkillsCard({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.cancel_rounded, color: AppColors.error, size: 20),
                SizedBox(width: 8),
                Text(
                  'Missing / Gap Skills',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (skills.isEmpty)
              const Text('No skill gaps detected!', style: TextStyle(color: AppColors.textSecondary))
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((skill) {
                  return Chip(
                    label: Text(skill, style: const TextStyle(fontSize: 12, color: AppColors.error)),
                    backgroundColor: AppColors.error.withValues(alpha: 0.1),
                    side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
