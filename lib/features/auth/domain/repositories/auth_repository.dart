import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Auth repository contract owned by the domain layer.
abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? imageFilePath,
  });

  Future<Either<Failure, Unit>> forgotPassword({required String email});

  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });

  Future<Either<Failure, Unit>> logout();

  /// Returns the persisted user if a session exists, otherwise null.
  Future<Either<Failure, User?>> currentUser();
}
