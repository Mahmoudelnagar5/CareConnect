import '../../../../core/config/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Remote auth contract. The mock implementation simulates a backend so the
/// app runs without a server; swap with a Dio-backed impl for production.
abstract class AuthRemoteDataSource {
  Future<({String token, UserModel user})> login({
    required String email,
    required String password,
  });

  Future<({String token, UserModel user})> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}

/// In-memory mock used while [AppConfig.useMockData] is true.
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  static const _demoEmail = 'nurse@careconnect.com';
  static const _demoPassword = 'password123';

  @override
  Future<({String token, UserModel user})> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(AppConfig.mockLatency);

    // Accept the demo credentials, or any well-formed credentials for ease of
    // testing the flow.
    final emailValid = email.contains('@');
    final passwordValid = password.length >= 6;
    if (!emailValid || !passwordValid) {
      throw const AuthException('Invalid email or password.');
    }
    if (email == _demoEmail && password != _demoPassword) {
      throw const AuthException('Incorrect password for the demo account.');
    }

    return (
      token: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
      user: UserModel(
        id: 'u_1001',
        name: 'Amelia Carter',
        email: email,
        phone: '+1 (555) 204-9981',
      ),
    );
  }

  @override
  Future<({String token, UserModel user})> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future<void>.delayed(AppConfig.mockLatency);
    if (password.length < 6) {
      throw const AuthException('Password must be at least 6 characters.');
    }
    return (
      token: 'mock-token-${DateTime.now().millisecondsSinceEpoch}',
      user: UserModel(
        id: 'u_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone,
      ),
    );
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future<void>.delayed(AppConfig.mockLatency);
    if (!email.contains('@')) {
      throw const AuthException('Please enter a valid email.');
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await Future<void>.delayed(AppConfig.mockLatency);
    if (code.trim().length < 4) {
      throw const AuthException('Invalid verification code.');
    }
    if (newPassword.length < 6) {
      throw const AuthException('Password must be at least 6 characters.');
    }
  }
}
