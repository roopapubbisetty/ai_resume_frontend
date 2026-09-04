import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ScreeningStatusBadge extends StatelessWidget {
  final String status;

  const ScreeningStatusBadge({super.key, required this.status});

  Color _getBadgeColor() {
    switch (status.toLowerCase()) {
      case 'selected':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getBadgeColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
