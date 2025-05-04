import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_event.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_state.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:smd_project/features/authentication/presentation/widgets/auth_guard.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            ResetPasswordRequested(_emailController.text),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            String errorMessage = state.message;
            // Format Firebase error messages to be more user-friendly
            if (errorMessage.contains('user-not-found')) {
              errorMessage = 'No account found with this email address.';
            } else if (errorMessage.contains('invalid-email')) {
              errorMessage = 'Please enter a valid email address.';
            } else if (errorMessage.contains('too-many-requests')) {
              errorMessage = 'Too many attempts. Please try again later.';
            } else if (errorMessage.contains('network-request-failed')) {
              errorMessage =
                  'Network error. Please check your internet connection.';
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'Dismiss',
                  textColor: Colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          } else if (state is Unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Password reset email sent. Please check your inbox.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 4),
              ),
            );
            // Navigate back using go_router
            context.go('/login');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Reset Password'),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Enter your email address and we will send you a link to reset your password.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state is AuthLoading
                                ? null
                                : _handleResetPassword,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: state is AuthLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Send Reset Link',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
