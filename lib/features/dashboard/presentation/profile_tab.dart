import 'package:care_connect_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.huge),
        children: [
          Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.lg),
          const _ProfileHeader(),
          const SizedBox(height: AppSpacing.xl),
          const _MenuGroup(
            title: 'Account',
            items: [
              (
                icon: Icons.person_outline_rounded,
                label: 'Personal information',
                color: AppColors.accentBlue,
                bg: AppColors.accentBlueBg,
              ),
              (icon: Icons.favorite_border_rounded, label: 'Health records', color: AppColors.accentPink, bg: AppColors.accentPinkBg),
              (icon: Icons.payment_rounded, label: 'Payment methods', color: AppColors.accentPurple, bg: AppColors.accentPurpleBg),
              (
                icon: Icons.location_on_outlined,
                label: 'Saved addresses',
                color: AppColors.accentOrange,
                bg: AppColors.accentOrangeBg,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const _MenuGroup(
            title: 'Preferences',
            items: [
              (icon: Icons.notifications_none_rounded, label: 'Notifications', color: AppColors.info, bg: AppColors.infoBg),
              (
                icon: Icons.lock_outline_rounded,
                label: 'Privacy & security',
                color: AppColors.secondary,
                bg: AppColors.secondaryLight,
              ),
              (icon: Icons.help_outline_rounded, label: 'Help & support', color: AppColors.success, bg: AppColors.successBg),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          OutlinedButton.icon(
            onPressed: () => _confirmLogout(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            ),
            icon: const Icon(Icons.logout_rounded, size: 20),
            label: const Text('Sign out'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text('CareConnect v1.0.0', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You will need to log in again to access your account.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthCubit>().logout();
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state.user;
        return AppCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  user?.initials ?? 'U',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 22),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Guest user',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(user?.email ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    if (user?.phone.isNotEmpty ?? false) ...[
                      const SizedBox(height: 2),
                      Text(user!.phone, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              ),
            ],
          ),
        );
      },
    );
  }
}

typedef _MenuEntry = ({IconData icon, String label, Color color, Color bg});

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.title, required this.items});
  final String title;
  final List<_MenuEntry> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(fontSize: 12, letterSpacing: 0.6, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                _MenuRow(entry: items[i]),
                if (i != items.length - 1) const Divider(height: 1, indent: 64, color: AppColors.border),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.entry});
  final _MenuEntry entry;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(color: entry.bg, borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Icon(entry.icon, color: entry.color, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                entry.label,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
