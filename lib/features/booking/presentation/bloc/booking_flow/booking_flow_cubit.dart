import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/caregiver.dart';
import '../../../domain/repositories/booking_repository.dart';
import '../../../domain/usecases/booking_usecases.dart';
import '../../../domain/usecases/get_caregivers.dart';
import 'booking_flow_state.dart';

class BookingFlowCubit extends Cubit<BookingFlowState> {
  final GetAvailableSlots getAvailableSlots;
  final CreateBooking createBooking;

  BookingFlowCubit({
    required this.getAvailableSlots,
    required this.createBooking,
    required Caregiver caregiver,
  }) : super(BookingFlowState(caregiver: caregiver));

  void selectService(String service) =>
      emit(state.copyWith(serviceType: service));

  void setDuration(int hours) => emit(state.copyWith(durationHours: hours));

  void updateAddress(String value) => emit(state.copyWith(address: value));

  void updateNotes(String value) => emit(state.copyWith(notes: value));

  Future<void> selectDate(DateTime date) async {
    emit(state.copyWith(
      date: date,
      startTime: null,
      status: BookingFlowStatus.loadingSlots,
    ));
    final result = await getAvailableSlots(
      GetAvailableSlotsParams(caregiverId: state.caregiver.id, date: date),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: BookingFlowStatus.failure,
        errorMessage: failure.message,
      )),
      (slots) => emit(state.copyWith(
        status: BookingFlowStatus.slotsLoaded,
        availableSlots: slots,
      )),
    );
  }

  void selectSlot(String slot) => emit(state.copyWith(startTime: slot));

  void nextStep() {
    if (state.currentStep < 3 && state.canProceed) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  Future<void> submit() async {
    emit(state.copyWith(status: BookingFlowStatus.submitting));
    final result = await createBooking(
      BookingRequest(
        caregiverId: state.caregiver.id,
        serviceType: state.serviceType!,
        date: state.date!,
        startTime: state.startTime!,
        durationHours: state.durationHours,
        address: state.address,
        notes: state.notes.isEmpty ? null : state.notes,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: BookingFlowStatus.failure,
        errorMessage: failure.message,
      )),
      (booking) => emit(state.copyWith(
        status: BookingFlowStatus.success,
        createdBooking: booking,
      )),
    );
  }
}
