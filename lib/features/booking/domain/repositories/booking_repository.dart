import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/booking.dart';
import '../entities/caregiver.dart';

abstract class BookingRepository {
  Future<Either<Failure, List<Caregiver>>> getCaregivers({String? query, String? specialty});
  Future<Either<Failure, Caregiver>> getCaregiverById(String id);
  Future<Either<Failure, List<String>>> getAvailableSlots(String caregiverId, DateTime date);
  Future<Either<Failure, Booking>> createBooking(BookingRequest request);
  Future<Either<Failure, List<Booking>>> getBookings();
  Future<Either<Failure, Unit>> cancelBooking(String bookingId);
}

class BookingRequest {
  final String caregiverId;
  final String serviceType;
  final DateTime date;
  final String startTime;
  final int durationHours;
  final String address;
  final String? notes;

  const BookingRequest({
    required this.caregiverId,
    required this.serviceType,
    required this.date,
    required this.startTime,
    required this.durationHours,
    required this.address,
    this.notes,
  });
}
