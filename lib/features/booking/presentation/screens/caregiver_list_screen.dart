import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/state_view.dart';
import '../../domain/entities/caregiver.dart';
import '../bloc/caregiver_list/caregiver_list_cubit.dart';
import '../bloc/caregiver_list/caregiver_list_state.dart';
import '../widgets/caregiver_card.dart';
import 'caregiver_detail_screen.dart';

class CaregiverListScreen extends StatelessWidget {
  const CaregiverListScreen({super.key});

  static const _specialties = ['All', 'Elderly Care', 'Pediatric Care', 'Post-Surgery Care', 'Disability Support'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CaregiverListCubit>()..load(),
      child: const _CaregiverListView(specialties: _specialties),
    );
  }
}

class _CaregiverListView extends StatelessWidget {
  final List<String> specialties;
  const _CaregiverListView({required this.specialties});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Find a Caregiver')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
            child: TextField(
              onChanged: (value) => context.read<CaregiverListCubit>().search(value),
              decoration: const InputDecoration(hintText: 'Search by name or specialty', prefixIcon: Icon(Icons.search)),
            ),
          ),
          SizedBox(
            height: 44,
            child: BlocBuilder<CaregiverListCubit, CaregiverListState>(
              buildWhen: (a, b) => a.selectedSpecialty != b.selectedSpecialty,
              builder: (context, state) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: specialties.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final s = specialties[index];
                    final selected = s == state.selectedSpecialty;
                    return ChoiceChip(
                      label: Text(s),
                      selected: selected,
                      onSelected: (_) => context.read<CaregiverListCubit>().filter(s),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: BlocBuilder<CaregiverListCubit, CaregiverListState>(
              builder: (context, state) {
                switch (state.status) {
                  case CaregiverListStatus.loading:
                  case CaregiverListStatus.initial:
                    return ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (_, __) => const SkeletonCard(),
                    );
                  case CaregiverListStatus.failure:
                    return StateView(
                      icon: Icons.cloud_off_rounded,
                      iconColor: AppColors.error,
                      iconBg: AppColors.errorBg,
                      title: 'Something went wrong',
                      message: state.errorMessage ?? 'Unable to load caregivers.',
                      actionLabel: 'Retry',
                      onAction: () => context.read<CaregiverListCubit>().load(),
                    );
                  case CaregiverListStatus.success:
                    if (state.caregivers.isEmpty) {
                      return const StateView(
                        icon: Icons.person_search_outlined,
                        title: 'No caregivers found',
                        message: 'Try adjusting your search or filters.',
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: state.caregivers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final caregiver = state.caregivers[index];
                        return CaregiverCard(caregiver: caregiver, onTap: () => _openDetail(context, caregiver));
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, Caregiver caregiver) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => CaregiverDetailScreen(caregiver: caregiver)));
  }
}
