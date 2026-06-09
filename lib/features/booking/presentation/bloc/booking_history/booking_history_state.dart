import 'package:equatable/equatable.dart';

import '../../../domain/entities/booking.dart';

enum BookingHistoryStatus { initial, loading, success, failure }

/// Tabs used to segment a member's bookings on the history screen.
enum BookingFilter { upcoming, past, cancelled }

class BookingHistoryState extends Equatable {
  final BookingHistoryStatus status;
  final List<Booking> bookings;
  final BookingFilter filter;
  final String? errorMessage;
  final String? cancellingId;

  const BookingHistoryState({
    this.status = BookingHistoryStatus.initial,
    this.bookings = const [],
    this.filter = BookingFilter.upcoming,
    this.errorMessage,
    this.cancellingId,
  });

  /// Bookings visible under the currently-selected [filter].
  List<Booking> get visibleBookings {
    switch (filter) {
      case BookingFilter.upcoming:
        return bookings
            .where((b) =>
                b.status == BookingStatus.pending ||
                b.status == BookingStatus.confirmed ||
                b.status == BookingStatus.inProgress)
            .toList();
      case BookingFilter.past:
        return bookings
            .where((b) => b.status == BookingStatus.completed)
            .toList();
      case BookingFilter.cancelled:
        return bookings
            .where((b) => b.status == BookingStatus.cancelled)
            .toList();
    }
  }

  int get upcomingCount => bookings
      .where((b) =>
          b.status == BookingStatus.pending ||
          b.status == BookingStatus.confirmed ||
          b.status == BookingStatus.inProgress)
      .length;

  BookingHistoryState copyWith({
    BookingHistoryStatus? status,
    List<Booking>? bookings,
    BookingFilter? filter,
    String? errorMessage,
    String? cancellingId,
    bool clearCancellingId = false,
  }) {
    return BookingHistoryState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
      cancellingId:
          clearCancellingId ? null : (cancellingId ?? this.cancellingId),
    );
  }

  @override
  List<Object?> get props => [status, bookings, filter, errorMessage, cancellingId];
}
