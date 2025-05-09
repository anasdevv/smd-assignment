// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:smd_project/features/authentication/presentation/bloc/auth_event.dart';
// import 'package:smd_project/features/authentication/presentation/bloc/auth_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:smd_project/features/authentication/presentation/bloc/auth_state.dart';
// import 'package:smd_project/features/groups/presentation/pages/view_groups_page.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) {
//         if (state is Unauthenticated) {
//           context.go('/login'); // Redirect only after state is updated
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: BlocBuilder<AuthBloc, AuthState>(
//             builder: (context, state) {
//               if (state is AuthLoading) {
//                 return const CircularProgressIndicator();
//               } else if (state is Authenticated) {
//                 return Text("Welcome ${state.user.displayName}");
//               } else if (state is AuthError) {
//                 return const Text("Error");
//               }
//               return const Text("Welcome User");
//             },
//           ),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.logout),
//               tooltip: 'Logout',
//               onPressed: () {
//                 context.read<AuthBloc>().add(SignOutRequested());
//               },
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: const ViewGroupsPage(),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       context.go('/create-group');
//                     },
//                     child: const Text('Create Group'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Navigate to Join Group Page
//                     },
//                     child: const Text('Join Group'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_event.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_state.dart';
import 'package:smd_project/features/groups/presentation/pages/view_groups_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
<<<<<<< Updated upstream
=======
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
>>>>>>> Stashed changes
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go('/login'); // Redirect only after state is updated
        }
      },
      child: Scaffold(
        appBar: AppBar(
<<<<<<< Updated upstream
          title: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const CircularProgressIndicator();
              } else if (state is Authenticated) {
                return Text("Welcome ${state.user.displayName}");
              } else if (state is AuthError) {
                return const Text("Error");
              }
              return const Text("Welcome User");
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
=======
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: _buildBloc(),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              tooltip: 'Settings',
              onPressed: () {
                context.push('/home/settings');
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
>>>>>>> Stashed changes
              tooltip: 'Logout',
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
            ),
          ],
        ),
<<<<<<< Updated upstream
        body: Column(
          children: [
            const Expanded(
              child: ViewGroupsPage(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.go('/home/create-group');
                    },
                    child: const Text('Create Group'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/home/join-group');
                    },
                    child: const Text('Join Group'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
=======
        body: ViewGroupsPage(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => {
            if (value == 0)
              {
                context.push('/home'),
              }
            else if (value == 1)
              {
                context.push('/home/create-group'),
              }
            else
              {
                context.push('/home/join-group'),
              }
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.group), label: 'My Groups'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline), label: 'Create'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline), label: 'Join'),
          ],
        ),
      ),
    );
  }

  BlocBuilder<AuthBloc, AuthState> _buildBloc() {
    return BlocBuilder<AuthBloc, AuthState>(
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
>>>>>>> Stashed changes
    );
  }
}
