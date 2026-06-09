import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/caregiver.dart';
import '../bloc/booking_flow/booking_flow_cubit.dart';
import '../bloc/booking_flow/booking_flow_state.dart';
import 'booking_confirmation_screen.dart';

class BookingFlowScreen extends StatelessWidget {
  final Caregiver caregiver;
  const BookingFlowScreen({super.key, required this.caregiver});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingFlowCubit>(param1: caregiver),
      child: const _BookingFlowView(),
    );
  }
}

class _BookingFlowView extends StatelessWidget {
  const _BookingFlowView();

  static const _services = ['Elderly Care', 'Pediatric Care', 'Post-Surgery Care', 'Disability Support', 'Companionship'];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingFlowCubit, BookingFlowState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        if (state.status == BookingFlowStatus.success && state.createdBooking != null) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => BookingConfirmationScreen(booking: state.createdBooking!)));
        } else if (state.status == BookingFlowStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Booking failed')));
        }
      },
      builder: (context, state) {
        final cubit = context.read<BookingFlowCubit>();
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Book a Visit'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (state.currentStep == 0) {
                  Navigator.of(context).pop();
                } else {
                  cubit.previousStep();
                }
              },
            ),
          ),
          body: Column(
            children: [
              _StepIndicator(currentStep: state.currentStep),
              Expanded(
                child: AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: _buildStep(context, state, cubit)),
              ),
            ],
          ),
          bottomNavigationBar: _BottomBar(state: state, cubit: cubit),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context, BookingFlowState state, BookingFlowCubit cubit) {
    switch (state.currentStep) {
      case 0:
        return _ServiceStep(
          key: const ValueKey('service'),
          services: _services,
          selected: state.serviceType,
          onSelect: cubit.selectService,
        );
      case 1:
        return _DateTimeStep(key: const ValueKey('datetime'), state: state, cubit: cubit);
      case 2:
        return _DetailsStep(key: const ValueKey('details'), state: state, cubit: cubit);
      default:
        return _ReviewStep(key: const ValueKey('review'), state: state);
    }
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  static const _labels = ['Service', 'Schedule', 'Details', 'Review'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          for (var i = 0; i < _labels.length; i++) ...[
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= currentStep ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _labels[i],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: i <= currentStep ? AppColors.primary : AppColors.textTertiary,
                      fontWeight: i == currentStep ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            if (i < _labels.length - 1) const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _ServiceStep extends StatelessWidget {
  final List<String> services;
  final String? selected;
  final ValueChanged<String> onSelect;
  const _ServiceStep({super.key, required this.services, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('What type of care do you need?', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        for (final service in services)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _SelectableTile(label: service, selected: selected == service, onTap: () => onSelect(service)),
          ),
      ],
    );
  }
}

class _DateTimeStep extends StatelessWidget {
  final BookingFlowState state;
  final BookingFlowCubit cubit;
  const _DateTimeStep({super.key, required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateLabel = state.date == null ? 'Select a date' : DateFormat('EEEE, MMM d').format(state.date!);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Choose date & time', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: state.date ?? now.add(const Duration(days: 1)),
              firstDate: now,
              lastDate: now.add(const Duration(days: 90)),
            );
            if (picked != null) cubit.selectDate(picked);
          },
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Text(dateLabel, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        if (state.status == BookingFlowStatus.loadingSlots)
          const Center(
            child: Padding(padding: EdgeInsets.all(AppSpacing.xl), child: CircularProgressIndicator()),
          )
        else if (state.date != null) ...[
          Text('Available times', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          if (state.availableSlots.isEmpty)
            Text('No slots available on this day.', style: theme.textTheme.bodyMedium)
          else
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final slot in state.availableSlots)
                  ChoiceChip(label: Text(slot), selected: state.startTime == slot, onSelected: (_) => cubit.selectSlot(slot)),
              ],
            ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Text('Duration', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            for (final hours in [2, 4, 6, 8])
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: ChoiceChip(
                  label: Text('${hours}h'),
                  selected: state.durationHours == hours,
                  onSelected: (_) => cubit.setDuration(hours),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DetailsStep extends StatelessWidget {
  final BookingFlowState state;
  final BookingFlowCubit cubit;
  const _DetailsStep({super.key, required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Visit details', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          onChanged: cubit.updateAddress,
          controller: TextEditingController(text: state.address)..selection = TextSelection.collapsed(offset: state.address.length),
          decoration: const InputDecoration(
            labelText: 'Address',
            hintText: 'Where should the caregiver visit?',
            prefixIcon: Icon(Icons.home_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          onChanged: cubit.updateNotes,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Notes (optional)',
            hintText: 'Any specific needs or instructions',
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  final BookingFlowState state;
  const _ReviewStep({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Review your booking', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _ReviewRow(label: 'Caregiver', value: state.caregiver.name),
              _ReviewRow(label: 'Service', value: state.serviceType ?? '-'),
              _ReviewRow(label: 'Date', value: state.date == null ? '-' : DateFormat('EEE, MMM d').format(state.date!)),
              _ReviewRow(label: 'Time', value: state.startTime ?? '-'),
              _ReviewRow(label: 'Duration', value: '${state.durationHours} hours'),
              _ReviewRow(label: 'Address', value: state.address),
              const Divider(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: theme.textTheme.titleMedium),
                  Text(
                    '\$${state.estimatedTotal.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  const _ReviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(label, style: theme.textTheme.bodyMedium)),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyLarge, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _SelectableTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SelectableTile({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: selected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? AppColors.primary : AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final BookingFlowState state;
  final BookingFlowCubit cubit;
  const _BottomBar({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final isLast = state.currentStep == 3;
    final isSubmitting = state.status == BookingFlowStatus.submitting;
    return Container(
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
            onPressed: state.canProceed && !isSubmitting ? () => isLast ? cubit.submit() : cubit.nextStep() : null,
            child: isSubmitting
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.surface))
                : Text(isLast ? 'Confirm Booking' : 'Continue'),
          ),
        ),
      ),
    );
  }
}
