import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/firebase_auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remote, required this.local, required this.dioClient, this.firebase});

  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;
  final DioClient dioClient;

  /// When provided, Firebase is the source of truth for session restoration
  /// and sign-out, while [local] still mirrors the session for fast startup.
  final FirebaseAuthRemoteDataSource? firebase;

  @override
  Future<Either<Failure, User>> login({required String email, required String password}) async {
    try {
      final result = await remote.login(email: email, password: password);
      await local.cacheSession(token: result.token, user: result.user);
      dioClient.setAuthToken(result.token);
      return Right(result.user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? imageFilePath,
  }) async {
    try {
      final result = await remote.register(name: name, email: email, phone: phone, password: password, imageFilePath: imageFilePath);
      await local.cacheSession(token: result.token, user: result.user);
      dioClient.setAuthToken(result.token);
      return Right(result.user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword({required String email}) async {
    try {
      await remote.forgotPassword(email: email);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({required String email, required String code, required String newPassword}) async {
    try {
      await remote.resetPassword(email: email, code: code, newPassword: newPassword);
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await firebase?.logout();
      await local.clear();
      dioClient.setAuthToken(null);
      return const Right(unit);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User?>> currentUser() async {
    try {
      // Prefer Firebase's persisted auth state when available.
      if (firebase != null) {
        final session = await firebase!.currentSession();
        if (session != null) {
          await local.cacheSession(token: session.token, user: session.user);
          dioClient.setAuthToken(session.token);
          return Right(session.user);
        }
        await local.clear();
        dioClient.setAuthToken(null);
        return const Right(null);
      }

      final user = await local.getCachedUser();
      final token = await local.getToken();
      if (user != null && token != null) {
        dioClient.setAuthToken(token);
      }
      return Right(user);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }
}
