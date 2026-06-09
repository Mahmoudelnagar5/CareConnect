import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../features/auth/domain/entities/user.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> getProfile(String uId);
  Future<Either<Failure, Unit>> updateProfile(User user);
}
