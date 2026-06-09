import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_cubit.dart';
import '../widgets/app_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final cubit = context.read<AuthCubit>();
    final error = await cubit.forgotPassword(email: _email.text.trim());
    if (error == null && mounted) {
      setState(() => _sent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Reset password')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: _sent ? _successView(theme) : _formView(theme),
        ),
      ),
    );
  }

  Widget _formView(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Forgot your password?', style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('Enter your email and we will send you a password reset link.', style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xxxl),
        AppTextField(
          label: 'Email',
          controller: _email,
          hint: 'you@example.com',
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
        ),
        const SizedBox(height: AppSpacing.xxl),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final loading = state.status == AuthStatus.loading;
            return ElevatedButton(
              onPressed: loading ? null : _submit,
              child: loading
                  ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                  : const Text('Send Reset Link'),
            );
          },
        ),
      ],
    );
  }

  Widget _successView(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.huge),
        const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
        const SizedBox(height: AppSpacing.xl),
        Text('Check your inbox', style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('If an account exists for ${_email.text.trim()}, we sent a password reset link.', style: theme.textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xxl),
        ElevatedButton(onPressed: () => context.pop(), child: const Text('Back to Sign In')),
      ],
    );
  }
}
