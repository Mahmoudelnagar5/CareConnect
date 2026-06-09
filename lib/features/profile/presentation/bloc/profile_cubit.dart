import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/entities/user.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required GetProfileUseCase getProfileUseCase, required UpdateProfileUseCase updateProfileUseCase})
      : _getProfile = getProfileUseCase,
        _updateProfile = updateProfileUseCase,
        super(const ProfileState());

  final GetProfileUseCase _getProfile;
  final UpdateProfileUseCase _updateProfile;

  Future<void> loadProfile(String uId) async {
    emit(const ProfileState(status: ProfileStatus.loading));
    final result = await _getProfile(GetProfileParams(uId: uId));
    result.fold(
      (failure) => emit(ProfileState(status: ProfileStatus.failure, errorMessage: failure.message)),
      (user) => emit(ProfileState(status: ProfileStatus.loaded, user: user)),
    );
  }

  Future<void> refresh(String uId) async => loadProfile(uId);

  Future<String?> updateProfile(User user) async {
    final result = await _updateProfile(user);
    String? error;
    result.fold(
      (failure) => error = failure.message,
      (_) => emit(ProfileState(status: ProfileStatus.loaded, user: user)),
    );
    return error;
  }
}
