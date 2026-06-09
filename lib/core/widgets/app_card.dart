import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Reusable elevated white card with soft shadow and rounded corners.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.card,
    this.onTap,
    this.color = AppColors.surface,
    this.border,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadius.cardRadius,
            border: border,
            boxShadow: AppShadows.subtle,
          ),
          child: child,
        ),
      ),
    );
  }
}
