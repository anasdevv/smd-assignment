import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_event.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_state.dart';
import 'package:smd_project/features/groups/presentation/pages/view_groups_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              } else if (state is Authenticated) {
                return Text(
                  "Welcome ${state.user.displayName}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else if (state is AuthError) {
                return const Text(
                  "Error",
                  style: TextStyle(color: Colors.white),
                );
              }
              return const Text(
                "Welcome User",
                style: TextStyle(color: Colors.white),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              tooltip: 'Settings',
              onPressed: () {
                context.go('/home/settings');
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Logout',
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _selectedIndex == 0
                  ? const ViewGroupsPage()
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Create or Join a Group',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildActionButton(
                                context,
                                'Create Group',
                                Icons.add_circle_outline,
                                () => context.go('/home/create-group'),
                              ),
                              const SizedBox(width: 20),
                              _buildActionButton(
                                context,
                                'Join Group',
                                Icons.group_add_outlined,
                                () => context.go('/home/join-group'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.group),
              label: 'My Groups',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Create/Join',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
