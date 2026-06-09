import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/state_view.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/booking.dart';
import '../bloc/booking_history/booking_history_cubit.dart';
import '../bloc/booking_history/booking_history_state.dart';

/// History tab: lists the member's bookings segmented into Upcoming, Past and
/// Cancelled, with the ability to cancel an active booking.
class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => sl<BookingHistoryCubit>()..load(), child: const _BookingHistoryView());
  }
}

class _BookingHistoryView extends StatelessWidget {
  const _BookingHistoryView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
            child: Text('My Bookings', style: theme.textTheme.headlineSmall),
          ),
          const _FilterTabs(),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
              builder: (context, state) {
                switch (state.status) {
                  case BookingHistoryStatus.initial:
                  case BookingHistoryStatus.loading:
                    return ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (_, __) => const SkeletonCard(),
                    );
                  case BookingHistoryStatus.failure:
                    return StateView(
                      icon: Icons.cloud_off_rounded,
                      iconColor: AppColors.error,
                      iconBg: AppColors.errorBg,
                      title: 'Something went wrong',
                      message: state.errorMessage ?? 'Unable to load bookings.',
                      actionLabel: 'Retry',
                      onAction: () => context.read<BookingHistoryCubit>().load(),
                    );
                  case BookingHistoryStatus.success:
                    final items = state.visibleBookings;
                    if (items.isEmpty) {
                      return StateView(
                        icon: Icons.event_busy_outlined,
                        title: 'No ${_filterLabel(state.filter).toLowerCase()} bookings',
                        message: 'When you book a caregiver, it will appear here.',
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () => context.read<BookingHistoryCubit>().load(),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.huge),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final booking = items[index];
                          return _BookingCard(
                            booking: booking,
                            isCancelling: state.cancellingId == booking.id,
                            onCancel: () => _confirmCancel(context, booking),
                          );
                        },
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  static String _filterLabel(BookingFilter filter) {
    switch (filter) {
      case BookingFilter.upcoming:
        return 'Upcoming';
      case BookingFilter.past:
        return 'Past';
      case BookingFilter.cancelled:
        return 'Cancelled';
    }
  }

  Future<void> _confirmCancel(BuildContext context, Booking booking) async {
    final cubit = context.read<BookingHistoryCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: Text('Your ${booking.serviceType} visit with ${booking.caregiverName} will be cancelled.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Keep')),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.cancel(booking.id);
    }
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
      buildWhen: (a, b) => a.filter != b.filter,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(
              children: [
                for (final filter in BookingFilter.values)
                  Expanded(
                    child: _SegmentButton(
                      label: _BookingHistoryView._filterLabel(filter),
                      selected: state.filter == filter,
                      onTap: () => context.read<BookingHistoryCubit>().changeFilter(filter),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          boxShadow: selected ? AppShadows.subtle : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: selected ? AppColors.primary : AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.isCancelling, required this.onCancel});

  final Booking booking;
  final bool isCancelling;
  final VoidCallback onCancel;

  ({String label, StatusVariant variant}) get _status {
    switch (booking.status) {
      case BookingStatus.pending:
        return (label: 'Pending', variant: StatusVariant.warning);
      case BookingStatus.confirmed:
        return (label: 'Confirmed', variant: StatusVariant.success);
      case BookingStatus.inProgress:
        return (label: 'In Progress', variant: StatusVariant.info);
      case BookingStatus.completed:
        return (label: 'Completed', variant: StatusVariant.neutral);
      case BookingStatus.cancelled:
        return (label: 'Cancelled', variant: StatusVariant.error);
    }
  }

  bool get _isActive => booking.status == BookingStatus.pending || booking.status == BookingStatus.confirmed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = _status;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  _initials(booking.caregiverName),
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.serviceType, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(booking.caregiverName, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              StatusBadge(label: status.label, variant: status.variant),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(icon: Icons.event_outlined, text: DateFormat('EEE, MMM d, yyyy').format(booking.date)),
          const SizedBox(height: AppSpacing.sm),
          _DetailRow(icon: Icons.schedule_outlined, text: '${booking.startTime} - ${booking.endTime} · ${booking.durationHours}h'),
          const SizedBox(height: AppSpacing.sm),
          _DetailRow(icon: Icons.place_outlined, text: booking.address),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text(
                '\$${booking.totalAmount.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(color: AppColors.primary),
              ),
              const Spacer(),
              if (_isActive)
                OutlinedButton(
                  onPressed: isCancelling ? null : onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    minimumSize: const Size(0, 44),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  child: isCancelling
                      ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.error))
                      : const Text('Cancel'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}
