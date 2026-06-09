import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/caregiver.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;

  BookingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Caregiver>>> getCaregivers({String? query, String? specialty}) async {
    try {
      final result = await remoteDataSource.getCaregivers(query: query, specialty: specialty);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Failed to load caregivers'));
    }
  }

  @override
  Future<Either<Failure, Caregiver>> getCaregiverById(String id) async {
    try {
      return Right(await remoteDataSource.getCaregiverById(id));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Failed to load caregiver'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAvailableSlots(String caregiverId, DateTime date) async {
    try {
      return Right(await remoteDataSource.getAvailableSlots(caregiverId, date));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Failed to load availability'));
    }
  }

  @override
  Future<Either<Failure, Booking>> createBooking(BookingRequest request) async {
    try {
      return Right(await remoteDataSource.createBooking(request));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Failed to create booking'));
    }
  }

  @override
  Future<Either<Failure, List<Booking>>> getBookings() async {
    try {
      return Right(await remoteDataSource.getBookings());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Failed to load bookings'));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelBooking(String bookingId) async {
    try {
      await remoteDataSource.cancelBooking(bookingId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Failed to cancel booking'));
    }
  }
}
