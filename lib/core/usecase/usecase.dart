import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Base contract for all use cases. Keeps the domain layer consistent.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Marker for use cases that take no parameters.
class NoParams {
  const NoParams();
}
