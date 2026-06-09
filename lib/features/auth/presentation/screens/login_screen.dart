import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_cubit.dart';
import '../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: '');
  final _password = TextEditingController(text: '');
  bool _obscure = true;
  bool _remember = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().login(email: _email.text.trim(), password: _password.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              context.go(AppRoutes.dashboard);
            } else if (state.status == AuthStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Login failed')));
            }
          },
          builder: (context, state) {
            final loading = state.status == AuthStatus.loading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    _Logo(),
                    const SizedBox(height: AppSpacing.xxxl),
                    Text('Welcome back', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Sign in to manage your home-care bookings.', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.xxxl),
                    AppTextField(
                      label: 'Email',
                      controller: _email,
                      hint: 'you@example.com',
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Password',
                      controller: _password,
                      hint: 'Enter your password',
                      icon: Icons.lock_outline,
                      obscure: _obscure,
                      validator: Validators.password,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.textTertiary,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v ?? false)),
                            const Text('Remember me'),
                          ],
                        ),
                        TextButton(onPressed: () => context.push(AppRoutes.forgotPassword), child: const Text('Forgot password?')),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton(
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                            )
                          : const Text('Sign In'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    OutlinedButton.icon(
                      onPressed: loading ? null : _submit,
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Sign in with biometrics'),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? ", style: theme.textTheme.bodyMedium),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.register),
                          child: const Text(
                            'Create one',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: const Icon(Icons.medical_services_outlined, color: Colors.white, size: 26),
        ),
        const SizedBox(width: AppSpacing.md),
        const Text(
          'CareConnect',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
