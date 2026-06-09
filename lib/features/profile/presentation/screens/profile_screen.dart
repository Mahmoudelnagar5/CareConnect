import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthCubit>().state.user;
      if (user != null) context.read<ProfileCubit>().loadProfile(user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await context.read<AuthCubit>().logout();
              if (mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          switch (state.status) {
            case ProfileStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ProfileStatus.failure:
              return StateView(
                icon: Icons.error_outline,
                title: 'Could not load profile',
                message: state.errorMessage ?? 'Something went wrong.',
                actionLabel: 'Retry',
                onAction: () {
                  final user = context.read<AuthCubit>().state.user;
                  if (user != null) context.read<ProfileCubit>().loadProfile(user.id);
                },
              );
            case ProfileStatus.initial:
            case ProfileStatus.loaded:
              final user = state.user ?? context.read<AuthCubit>().state.user;
              if (user == null) {
                return StateView(
                  icon: Icons.person_off_outlined,
                  title: 'No user data',
                  message: 'Please sign in to view your profile.',
                );
              }
              return RefreshIndicator(
                onRefresh: () async => context.read<ProfileCubit>().loadProfile(user.id),
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  children: [
                    _Avatar(user: user),
                    const SizedBox(height: AppSpacing.xxl),
                    _InfoTile(label: 'Name', value: user.name, icon: Icons.person_outline),
                    _InfoTile(label: 'Email', value: user.email, icon: Icons.mail_outline),
                    _InfoTile(label: 'Phone', value: user.phone, icon: Icons.phone_outlined),
                    if (user.id.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _InfoTile(label: 'User ID', value: user.id, icon: Icons.fingerprint),
                    ],
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: AppColors.primaryLight,
          backgroundImage: user.imageProfile != null ? CachedNetworkImageProvider(user.imageProfile!) : null,
          child: user.imageProfile == null
              ? Text(user.initials, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.primary))
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(user.name, style: theme.textTheme.headlineSmall),
        Text(user.email, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Icon(icon, size: 22, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
