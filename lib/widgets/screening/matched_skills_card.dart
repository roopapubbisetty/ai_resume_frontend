import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class MatchedSkillsCard extends StatelessWidget {
  final List<String> skills;

  const MatchedSkillsCard({super.key, required this.skills});

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
                Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                SizedBox(width: 8),
                Text(
                  'Matched Skills',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (skills.isEmpty)
              const Text('No matched skills identified.', style: TextStyle(color: AppColors.textSecondary))
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((skill) {
                  return Chip(
                    label: Text(skill, style: const TextStyle(fontSize: 12, color: AppColors.success)),
                    backgroundColor: AppColors.success.withValues(alpha: 0.1),
                    side: BorderSide(color: AppColors.success.withValues(alpha: 0.3)),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
