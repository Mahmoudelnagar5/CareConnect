import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/caregiver.dart';
import 'booking_flow_screen.dart';

class CaregiverDetailScreen extends StatelessWidget {
  final Caregiver caregiver;
  const CaregiverDetailScreen({super.key, required this.caregiver});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = caregiver.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Caregiver Profile')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(AppRadius.lg)),
                alignment: Alignment.center,
                child: Text(initials, style: theme.textTheme.headlineSmall?.copyWith(color: AppColors.primary)),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(caregiver.name, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(caregiver.specialty, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.primary)),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                        const SizedBox(width: 2),
                        Text('${caregiver.rating} (${caregiver.reviewCount})', style: theme.textTheme.labelLarge),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              _StatTile(label: 'Experience', value: '${caregiver.yearsExperience} yrs', icon: Icons.workspace_premium_outlined),
              const SizedBox(width: AppSpacing.md),
              _StatTile(label: 'Rate', value: '\$${caregiver.hourlyRate.toStringAsFixed(0)}/hr', icon: Icons.payments_outlined),
              const SizedBox(width: AppSpacing.md),
              _StatTile(label: 'Location', value: caregiver.location.split(',').first, icon: Icons.location_on_outlined),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('About', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(caregiver.bio, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          Text('Skills', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final skill in caregiver.skills)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(skill, style: theme.textTheme.bodySmall),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: caregiver.isAvailable
                  ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookingFlowScreen(caregiver: caregiver)))
                  : null,
              child: Text(caregiver.isAvailable ? 'Book ${caregiver.name.split(' ').first}' : 'Currently unavailable'),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: theme.textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
