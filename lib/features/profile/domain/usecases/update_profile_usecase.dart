import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../features/auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase implements UseCase<Unit, User> {
  const UpdateProfileUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(User params) {
    return _repository.updateProfile(params);
  }
}
