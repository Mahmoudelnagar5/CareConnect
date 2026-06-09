/// Base failure type returned from the data/domain layer.
///
/// Failures are surfaced to BLoCs via `Either<Failure, T>` (dartz), keeping
/// the UI free of exception handling.
abstract class Failure {
  const Failure(this.message);
  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on our end.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Please try again.',
  ]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to read local data.']);
}
