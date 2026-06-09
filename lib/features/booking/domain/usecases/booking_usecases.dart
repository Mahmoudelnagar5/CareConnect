import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class CreateBooking implements UseCase<Booking, BookingRequest> {
  final BookingRepository repository;
  const CreateBooking(this.repository);

  @override
  Future<Either<Failure, Booking>> call(BookingRequest params) => repository.createBooking(params);
}

class GetBookings implements UseCase<List<Booking>, NoParams> {
  final BookingRepository repository;
  const GetBookings(this.repository);

  @override
  Future<Either<Failure, List<Booking>>> call(NoParams params) => repository.getBookings();
}

class CancelBooking implements UseCase<Unit, String> {
  final BookingRepository repository;
  const CancelBooking(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String bookingId) => repository.cancelBooking(bookingId);
}
