part of 'auth_cubit.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading, failure }

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.unknown, this.user, this.errorMessage});

  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState.unknown() : this();

  AuthState copyWith({AuthStatus? status, User? user, String? errorMessage}) {
    return AuthState(status: status ?? this.status, user: user ?? this.user, errorMessage: errorMessage);
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
