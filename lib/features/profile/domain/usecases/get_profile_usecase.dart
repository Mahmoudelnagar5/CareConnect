import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../features/auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class GetProfileParams extends Equatable {
  const GetProfileParams({required this.uId});
  final String uId;

  @override
  List<Object?> get props => [uId];
}

class GetProfileUseCase implements UseCase<User, GetProfileParams> {
  const GetProfileUseCase(this._repository);
  final ProfileRepository _repository;

  @override
  Future<Either<Failure, User>> call(GetProfileParams params) {
    return _repository.getProfile(params.uId);
  }
}
