import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_event.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
              context.go('/login');
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
