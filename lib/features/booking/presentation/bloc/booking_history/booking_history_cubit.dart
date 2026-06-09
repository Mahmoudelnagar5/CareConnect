import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../domain/usecases/booking_usecases.dart';
import 'booking_history_state.dart';

/// Loads and manages the member's booking history, including cancellation and
/// tab-based filtering (upcoming / past / cancelled).
class BookingHistoryCubit extends Cubit<BookingHistoryState> {
  BookingHistoryCubit({required GetBookings getBookings, required CancelBooking cancelBooking})
    : _getBookings = getBookings,
      _cancelBooking = cancelBooking,
      super(const BookingHistoryState());

  final GetBookings _getBookings;
  final CancelBooking _cancelBooking;

  Future<void> load() async {
    emit(state.copyWith(status: BookingHistoryStatus.loading));
    final result = await _getBookings(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: BookingHistoryStatus.failure, errorMessage: failure.message)),
      (bookings) => emit(state.copyWith(status: BookingHistoryStatus.success, bookings: bookings)),
    );
  }

  void changeFilter(BookingFilter filter) {
    if (filter == state.filter) return;
    emit(state.copyWith(filter: filter));
  }

  Future<void> cancel(String bookingId) async {
    emit(state.copyWith(cancellingId: bookingId));
    final result = await _cancelBooking(bookingId);
    await result.fold(
      (failure) async =>
          emit(state.copyWith(status: BookingHistoryStatus.failure, errorMessage: failure.message, clearCancellingId: true)),
      (_) async {
        emit(state.copyWith(clearCancellingId: true));
        await load();
      },
    );
  }
}
