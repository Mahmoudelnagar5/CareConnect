import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.imageFilePath,
  });

  final String name;
  final String email;
  final String phone;
  final String password;
  final String? imageFilePath;

  @override
  List<Object?> get props => [name, email, phone, password, imageFilePath];
}

class RegisterUseCase implements UseCase<User, RegisterParams> {
  const RegisterUseCase(this._repository);
  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(RegisterParams params) {
    return _repository.register(
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
      imageFilePath: params.imageFilePath,
    );
  }
}
