import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/user_avatar.dart';
import '../../auth/presentation/bloc/auth_cubit.dart';
import 'widgets/quick_actions_row.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({
    super.key,
    required this.onBookNurse,
    required this.onViewHistory,
    required this.onViewRecords,
    required this.onSupport,
    required this.onOpenAlerts,
  });

  final VoidCallback onBookNurse;
  final VoidCallback onViewHistory;
  final VoidCallback onViewRecords;
  final VoidCallback onSupport;
  final VoidCallback onOpenAlerts;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.huge),
        children: [
          _HomeHeader(onOpenAlerts: onOpenAlerts),
          const SizedBox(height: AppSpacing.xxl),
          const _StatsGrid(),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionTitle('Quick Actions'),
          const SizedBox(height: AppSpacing.md),
          QuickActionsRow(
            actions: [
              QuickAction(
                label: 'Book Nurse',
                icon: Icons.person_add_alt_1_rounded,
                color: AppColors.accentPurple,
                background: AppColors.accentPurpleBg,
                onTap: onBookNurse,
              ),
              QuickAction(
                label: 'Records',
                icon: Icons.monitor_heart_rounded,
                color: AppColors.accentPink,
                background: AppColors.accentPinkBg,
                onTap: onViewRecords,
              ),
              QuickAction(
                label: 'History',
                icon: Icons.access_time_rounded,
                color: AppColors.accentOrange,
                background: AppColors.accentOrangeBg,
                onTap: onViewHistory,
              ),
              QuickAction(
                label: 'Support',
                icon: Icons.notifications_active_rounded,
                color: AppColors.accentBlue,
                background: AppColors.accentBlueBg,
                onTap: onSupport,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const _SectionTitle('Recent activity'),
          const SizedBox(height: AppSpacing.md),
          const _RecentActivity(),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onOpenAlerts});

  final VoidCallback onOpenAlerts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final name = state.user?.name.split(' ').first ?? 'there';
        final initials = state.user?.initials ?? 'U';
        return Row(
          children: [
            UserAvatar(imageProfile: state.user?.imageProfile, initials: initials, radius: 26),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good morning,', style: theme.textTheme.bodyMedium),
                  Text(name, style: theme.textTheme.titleLarge),
                ],
              ),
            ),
            _IconBadge(icon: Icons.notifications_none_rounded, onTap: onOpenAlerts, showDot: true),
          ],
        );
      },
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.onTap, this.showDot = false});
  final IconData icon;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: AppColors.textPrimary),
            if (showDot)
              Positioned(
                right: -1,
                top: -1,
                child: Container(
                  height: 9,
                  width: 9,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  @override
  Widget build(BuildContext context) {
    const stats = [
      (label: 'Active requests', value: '3', icon: Icons.pending_actions, color: AppColors.info, bg: AppColors.infoBg),
      (label: 'Upcoming visits', value: '2', icon: Icons.event_outlined, color: AppColors.secondary, bg: AppColors.secondaryLight),
      (label: 'Completed', value: '18', icon: Icons.check_circle_outline, color: AppColors.success, bg: AppColors.successBg),
      (label: 'Total bookings', value: '23', icon: Icons.receipt_long_outlined, color: AppColors.warning, bg: AppColors.warningBg),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.3,
      children: [
        for (final s in stats)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(color: s.bg, borderRadius: BorderRadius.circular(AppRadius.sm)),
                  child: Icon(s.icon, color: s.color, size: 20),
                ),
                Text(
                  s.value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                Text(s.label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
      ],
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        service: 'Post-Surgery Care',
        nurse: 'David Kim, RN',
        date: 'Today, 2:00 PM',
        status: 'In Progress',
        variant: StatusVariant.info,
      ),
      (
        service: 'Elderly Care',
        nurse: 'Sofia Reyes, RN',
        date: 'Tomorrow, 9:00 AM',
        status: 'Confirmed',
        variant: StatusVariant.success,
      ),
      (
        service: 'IV Therapy',
        nurse: 'Pending assignment',
        date: 'Jun 12, 11:00 AM',
        status: 'Pending',
        variant: StatusVariant.warning,
      ),
    ];
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AppCard(
              onTap: () {},
              child: Row(
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(AppRadius.md)),
                    child: const Icon(Icons.medical_services_outlined, color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.service,
                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text('${item.nurse} · ${item.date}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  StatusBadge(label: item.status, variant: item.variant),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}
