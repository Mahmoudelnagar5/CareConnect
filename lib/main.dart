import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initServiceLocator();

  final authCubit = sl<AuthCubit>();
  final router = buildRouter(authCubit);

  runApp(
    BlocProvider.value(
      value: authCubit,
      child: DevicePreview(enabled: false, builder: (context) => CareConnectApp(router: router)),
    ),
  );
}

class CareConnectApp extends StatelessWidget {
  const CareConnectApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(title: 'CareConnect', theme: AppTheme.light, routerConfig: router, debugShowCheckedModeBanner: false);
  }
}
