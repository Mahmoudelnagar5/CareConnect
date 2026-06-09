import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase implements UseCase<Unit, NoParams> {
  const CompleteOnboardingUseCase(this._repository);
  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    try {
      await _repository.completeOnboarding();
      return const Right(unit);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
