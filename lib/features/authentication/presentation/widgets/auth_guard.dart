import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_state.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          // If user is authenticated, redirect to home page
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/home');
          });
          // Show a loading indicator while redirecting
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // If not authenticated, show the child widget
        return child;
      },
    );
  }
}
