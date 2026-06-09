import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../auth/presentation/bloc/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final onboardingDone = prefs.getBool('cc_onboarding_done') ?? false;
      if (!mounted) return;

      if (!onboardingDone) {
        context.go(AppRoutes.onboarding);
        return;
      }

      await context.read<AuthCubit>().checkSession();
    } catch (_) {
      if (!mounted) return;
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (prev, curr) => curr.status != AuthStatus.unknown,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go(AppRoutes.dashboard);
        } else if (state.status == AuthStatus.failure) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 96,
                width: 96,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppRadius.xl)),
                child: const Icon(Icons.medical_services_outlined, size: 52, color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text(
                'CareConnect',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text('Certified home-care nursing', style: TextStyle(color: Color(0xFFCFE0FB), fontSize: 14)),
              const SizedBox(height: AppSpacing.huge),
              const SizedBox(height: 28, width: 28, child: CircularProgressIndicator(strokeWidth: 2.6, color: Colors.white)),
              const SizedBox(height: AppSpacing.xxxl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.lock_outline, size: 14, color: Color(0xFFCFE0FB)),
                  SizedBox(width: AppSpacing.xs),
                  Text('Secure healthcare messaging', style: TextStyle(color: Color(0xFFCFE0FB), fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
