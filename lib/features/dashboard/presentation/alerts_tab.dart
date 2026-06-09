import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AlertsTab extends StatelessWidget {
  const AlertsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 48, color: AppColors.textSecondary),
          SizedBox(height: 16),
          Text('No alerts yet', style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
