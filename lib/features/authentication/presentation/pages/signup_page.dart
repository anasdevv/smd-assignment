import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_event.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_state.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:smd_project/features/authentication/presentation/widgets/auth_guard.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();

  String _selectedCountry = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpRequested(
              _emailController.text,
              _passwordController.text,
              _displayNameController.text,
            ),
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
            if (errorMessage.contains('email-already-in-use')) {
              errorMessage =
                  'This email is already registered. Please try logging in.';
            } else if (errorMessage.contains('weak-password')) {
              errorMessage =
                  'Password is too weak. Please use a stronger password.';
            } else if (errorMessage.contains('invalid-email')) {
              errorMessage = 'Please enter a valid email address.';
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
          } else if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Account created successfully!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 2),
              ),
            );
            // Navigate to home page using go_router
            context.go('/home');
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha((0.80 * 255).round()),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Getting Started",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Seems you are new here, let's set up your profile.",
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextFormField(
                              controller: _displayNameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Full name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email Address',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                final emailRegex =
                                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.info_outline, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      text:
                                          "By creating an account, you agree to our ",
                                      children: [
                                        TextSpan(
                                          text: "Terms and Conditions",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: state is AuthLoading
                                      ? null
                                      : _handleSignUp,
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    backgroundColor: Colors.blue.shade800,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: state is AuthLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          "Continue",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account? "),
                                GestureDetector(
                                  onTap: () => context.go('/login'),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
