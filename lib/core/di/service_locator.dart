import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/firebase_auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/session_usecases.dart';
import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/onboarding/data/datasources/onboarding_local_datasource.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/check_onboarding_usecase.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/bloc/profile_cubit.dart';
import '../../features/booking/data/datasources/booking_remote_datasource.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/usecases/booking_usecases.dart';
import '../../features/booking/presentation/bloc/booking_history/booking_history_cubit.dart';
import '../../features/booking/presentation/bloc/caregiver_list/caregiver_list_cubit.dart';
import '../../features/booking/presentation/bloc/booking_flow/booking_flow_cubit.dart';
import '../../features/booking/domain/usecases/get_caregivers.dart';
import '../../features/booking/domain/entities/caregiver.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));

  // Auth - Data
  final firebaseAuthRemote = FirebaseAuthRemoteDataSource(auth: sl(), firestore: sl());
  sl.registerLazySingleton<FirebaseAuthRemoteDataSource>(() => firebaseAuthRemote);
  sl.registerLazySingleton<AuthRemoteDataSource>(() => firebaseAuthRemote);
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), local: sl(), dioClient: sl(), firebase: sl<FirebaseAuthRemoteDataSource>()),
  );

  // Auth - Domain
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));

  // Auth - Presentation
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      getCurrentUserUseCase: sl(),
      logoutUseCase: sl(),
      forgotPasswordUseCase: sl(),
    ),
  );

  // Onboarding - Data
  sl.registerLazySingleton<OnboardingLocalDataSource>(() => OnboardingLocalDataSourceImpl(sl()));
  sl.registerLazySingleton<OnboardingRepository>(() => OnboardingRepositoryImpl(sl()));

  // Onboarding - Domain
  sl.registerLazySingleton(() => CheckOnboardingUseCase(sl()));
  sl.registerLazySingleton(() => CompleteOnboardingUseCase(sl()));

  // Profile - Data
  sl.registerLazySingleton<ProfileRemoteDataSource>(() => ProfileRemoteDataSourceImpl(firestore: sl()));
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepositoryImpl(sl()));

  // Profile - Domain
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // Profile - Presentation
  sl.registerFactory(() => ProfileCubit(getProfileUseCase: sl(), updateProfileUseCase: sl()));

  // Booking - Data
  sl.registerLazySingleton<BookingRemoteDataSource>(() => MockBookingRemoteDataSource());
  sl.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(sl()));

  // Booking - Domain
  sl.registerLazySingleton(() => GetBookings(sl()));
  sl.registerLazySingleton(() => CancelBooking(sl()));
  sl.registerLazySingleton(() => GetCaregivers(sl()));
  sl.registerLazySingleton(() => GetAvailableSlots(sl()));
  sl.registerLazySingleton(() => CreateBooking(sl()));

  // Booking - Presentation
  sl.registerFactory(() => BookingHistoryCubit(getBookings: sl(), cancelBooking: sl()));
  sl.registerFactory(() => CaregiverListCubit(sl()));
  sl.registerFactoryParam<BookingFlowCubit, Caregiver, void>(
    (caregiver, _) => BookingFlowCubit(getAvailableSlots: sl(), createBooking: sl(), caregiver: caregiver),
  );
}
