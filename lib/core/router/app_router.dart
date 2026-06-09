import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/splash/splash_screen.dart';
import 'app_routes.dart';

final _publicRoutes = {AppRoutes.splash, AppRoutes.onboarding, AppRoutes.login, AppRoutes.register, AppRoutes.forgotPassword};

GoRouter buildRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final status = authCubit.state.status;
      final location = state.matchedLocation;

      if (status == AuthStatus.unknown) {
        if (_publicRoutes.contains(location)) return null;
        return AppRoutes.splash;
      }

      final isAuthenticated = status == AuthStatus.authenticated;

      if (!isAuthenticated) {
        if (_publicRoutes.contains(location)) return null;
        return AppRoutes.login;
      }

      if (isAuthenticated && (location == AppRoutes.splash || _publicRoutes.contains(location))) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.onboarding, builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: AppRoutes.register, builder: (_, _) => const RegisterScreen()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (_, _) => const ForgotPasswordScreen()),
      GoRoute(path: AppRoutes.dashboard, builder: (_, _) => const DashboardScreen()),
      GoRoute(path: AppRoutes.profile, builder: (_, _) => const ProfileScreen()),
    ],
  );
}
