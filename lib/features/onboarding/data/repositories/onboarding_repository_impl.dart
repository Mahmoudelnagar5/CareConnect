import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._local);
  final OnboardingLocalDataSource _local;

  @override
  Future<bool> isOnboardingCompleted() => _local.isCompleted();

  @override
  Future<void> completeOnboarding() => _local.setCompleted();
}
