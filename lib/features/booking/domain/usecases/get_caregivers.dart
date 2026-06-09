import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/caregiver.dart';
import '../repositories/booking_repository.dart';

class GetCaregiversParams {
  final String? query;
  final String? specialty;
  const GetCaregiversParams({this.query, this.specialty});
}

class GetCaregivers implements UseCase<List<Caregiver>, GetCaregiversParams> {
  final BookingRepository repository;
  const GetCaregivers(this.repository);

  @override
  Future<Either<Failure, List<Caregiver>>> call(GetCaregiversParams params) {
    return repository.getCaregivers(query: params.query, specialty: params.specialty);
  }
}

class GetCaregiverById implements UseCase<Caregiver, String> {
  final BookingRepository repository;
  const GetCaregiverById(this.repository);

  @override
  Future<Either<Failure, Caregiver>> call(String id) => repository.getCaregiverById(id);
}

class GetAvailableSlotsParams {
  final String caregiverId;
  final DateTime date;
  const GetAvailableSlotsParams({required this.caregiverId, required this.date});
}

class GetAvailableSlots implements UseCase<List<String>, GetAvailableSlotsParams> {
  final BookingRepository repository;
  const GetAvailableSlots(this.repository);

  @override
  Future<Either<Failure, List<String>>> call(GetAvailableSlotsParams params) {
    return repository.getAvailableSlots(params.caregiverId, params.date);
  }
}
