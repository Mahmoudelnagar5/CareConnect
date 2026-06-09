import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/onboarding_repository.dart';

class CheckOnboardingUseCase implements UseCase<bool, NoParams> {
  const CheckOnboardingUseCase(this._repository);
  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final result = await _repository.isOnboardingCompleted();
      return Right(result);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
