import 'package:equatable/equatable.dart';

import '../../../domain/entities/booking.dart';
import '../../../domain/entities/caregiver.dart';

enum BookingFlowStatus { idle, loadingSlots, slotsLoaded, submitting, success, failure }

class BookingFlowState extends Equatable {
  final BookingFlowStatus status;
  final Caregiver caregiver;
  final int currentStep; // 0: service, 1: date/time, 2: details, 3: review
  final String? serviceType;
  final DateTime? date;
  final String? startTime;
  final int durationHours;
  final String address;
  final String notes;
  final List<String> availableSlots;
  final Booking? createdBooking;
  final String? errorMessage;

  const BookingFlowState({
    this.status = BookingFlowStatus.idle,
    required this.caregiver,
    this.currentStep = 0,
    this.serviceType,
    this.date,
    this.startTime,
    this.durationHours = 2,
    this.address = '',
    this.notes = '',
    this.availableSlots = const [],
    this.createdBooking,
    this.errorMessage,
  });

  double get estimatedTotal => caregiver.hourlyRate * durationHours;

  bool get canProceed {
    switch (currentStep) {
      case 0:
        return serviceType != null;
      case 1:
        return date != null && startTime != null;
      case 2:
        return address.trim().isNotEmpty;
      default:
        return true;
    }
  }

  BookingFlowState copyWith({
    BookingFlowStatus? status,
    int? currentStep,
    String? serviceType,
    DateTime? date,
    String? startTime,
    int? durationHours,
    String? address,
    String? notes,
    List<String>? availableSlots,
    Booking? createdBooking,
    String? errorMessage,
  }) {
    return BookingFlowState(
      status: status ?? this.status,
      caregiver: caregiver,
      currentStep: currentStep ?? this.currentStep,
      serviceType: serviceType ?? this.serviceType,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      durationHours: durationHours ?? this.durationHours,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      availableSlots: availableSlots ?? this.availableSlots,
      createdBooking: createdBooking ?? this.createdBooking,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    caregiver,
    currentStep,
    serviceType,
    date,
    startTime,
    durationHours,
    address,
    notes,
    availableSlots,
    createdBooking,
    errorMessage,
  ];
}
