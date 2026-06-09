import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum StatusVariant { neutral, info, success, warning, error }

/// Pill-shaped status badge used for booking states and history.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.variant = StatusVariant.neutral,
  });

  final String label;
  final StatusVariant variant;

  ({Color bg, Color fg}) get _colors {
    switch (variant) {
      case StatusVariant.info:
        return (bg: AppColors.infoBg, fg: AppColors.info);
      case StatusVariant.success:
        return (bg: AppColors.successBg, fg: AppColors.success);
      case StatusVariant.warning:
        return (bg: AppColors.warningBg, fg: AppColors.warning);
      case StatusVariant.error:
        return (bg: AppColors.errorBg, fg: AppColors.error);
      case StatusVariant.neutral:
        return (bg: AppColors.surfaceAlt, fg: AppColors.textSecondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: c.fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
