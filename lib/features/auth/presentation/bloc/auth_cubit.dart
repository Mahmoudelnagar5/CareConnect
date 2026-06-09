import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/session_usecases.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
  }) : _login = loginUseCase,
       _register = registerUseCase,
       _getCurrentUser = getCurrentUserUseCase,
       _logout = logoutUseCase,
       _forgotPassword = forgotPasswordUseCase,
       super(const AuthState.unknown());

  final LoginUseCase _login;
  final RegisterUseCase _register;
  final GetCurrentUserUseCase _getCurrentUser;
  final LogoutUseCase _logout;
  final ForgotPasswordUseCase _forgotPassword;

  Future<void> checkSession() async {
    final result = await _getCurrentUser(const NoParams());
    result.fold(
      (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
      (user) => emit(
        user != null ? AuthState(status: AuthStatus.authenticated, user: user) : const AuthState(status: AuthStatus.unauthenticated),
      ),
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _login(LoginParams(email: email, password: password));
    result.fold(
      (failure) => emit(state.copyWith(status: AuthStatus.failure, errorMessage: failure.message)),
      (user) => emit(AuthState(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<void> register({required String name, required String email, required String phone, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _register(RegisterParams(name: name, email: email, phone: phone, password: password));
    result.fold(
      (failure) => emit(state.copyWith(status: AuthStatus.failure, errorMessage: failure.message)),
      (user) => emit(AuthState(status: AuthStatus.authenticated, user: user)),
    );
  }

  Future<String?> forgotPassword({required String email}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _forgotPassword(ForgotPasswordParams(email: email));
    String? error;
    result.fold(
      (failure) => error = failure.message,
      (_) {},
    );
    if (error != null) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: error));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
    return error;
  }

  Future<void> logout() async {
    await _logout(const NoParams());
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
