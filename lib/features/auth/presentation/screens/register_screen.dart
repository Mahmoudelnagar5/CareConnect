import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_cubit.dart';
import '../widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;
  bool _terms = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_terms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept the Terms to continue.')));
      return;
    }
    context.read<AuthCubit>().register(
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              context.go(AppRoutes.dashboard);
            } else if (state.status == AuthStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Registration failed')));
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
                    Text('Join CareConnect', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Create an account to book certified nurses at home.', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: AppSpacing.xxl),
                    AppTextField(
                      label: 'Full name',
                      controller: _name,
                      hint: 'Jane Doe',
                      icon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: (v) => Validators.required(v, field: 'Full name'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
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
                      label: 'Phone number',
                      controller: _phone,
                      hint: '+1 (555) 000-0000',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Password',
                      controller: _password,
                      hint: 'At least 6 characters',
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
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Confirm password',
                      controller: _confirm,
                      hint: 'Re-enter your password',
                      icon: Icons.lock_outline,
                      obscure: _obscure,
                      validator: (v) => Validators.confirm(v, _password.text),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(value: _terms, onChanged: (v) => setState(() => _terms = v ?? false)),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: AppSpacing.md),
                            child: Text(
                              'I accept the Terms of Service and Privacy Policy.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
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
                          : const Text('Create Account'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Center(
                      child: TextButton(onPressed: () => context.pop(), child: const Text('Already have an account? Sign in')),
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
