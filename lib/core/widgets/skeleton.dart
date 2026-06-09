import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// A shimmering rectangle used to compose skeleton loaders.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({super.key, required this.height, this.width = double.infinity, this.radius = AppRadius.sm});

  final double height;
  final double width;
  final double radius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
    ..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1 - _controller.value * 2, 0),
              end: Alignment(1 - _controller.value * 2, 0),
              colors: const [AppColors.surfaceAlt, AppColors.border, AppColors.surfaceAlt],
            ),
          ),
        );
      },
    );
  }
}

/// A generic card skeleton (used in dashboard, catalog and history lists).
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.card,
      decoration: const BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.cardRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              ShimmerBox(height: 48, width: 48, radius: AppRadius.md),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(height: 14, width: 140),
                    SizedBox(height: AppSpacing.sm),
                    ShimmerBox(height: 12, width: 90),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          ShimmerBox(height: 12),
          SizedBox(height: AppSpacing.sm),
          ShimmerBox(height: 12, width: 200),
        ],
      ),
    );
  }
}
