import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../features/auth/data/models/user_model.dart';
import '../../../../features/auth/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remote);
  final ProfileRemoteDataSource _remote;

  @override
  Future<Either<Failure, User>> getProfile(String uId) async {
    try {
      final user = await _remote.getProfile(uId);
      if (user == null) return const Left(NotFoundFailure());
      return Right(user);
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile(User user) async {
    try {
      await _remote.updateProfile(UserModel.fromEntity(user));
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }
}
