import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:smd_project/features/authentication/presentation/pages/login_page.dart';
import 'package:smd_project/features/authentication/presentation/pages/signup_page.dart';
import 'package:smd_project/features/authentication/presentation/pages/forgot_password_page.dart';
<<<<<<< Updated upstream
import 'package:smd_project/features/groups/presentation/pages/join_group_page.dart';
import 'package:smd_project/features/home/presentation/pages/home_page.dart';
import 'package:smd_project/features/groups/presentation/pages/create_groups_page.dart';
import 'package:smd_project/features/groups/presentation/pages/group_info_page.dart';
=======
import 'package:smd_project/features/authentication/presentation/pages/user_settings_page.dart';
import 'package:smd_project/features/groups/presentation/pages/group_page.dart';
import 'package:smd_project/features/groups/presentation/pages/join_group_by_code_page.dart';
import 'package:smd_project/features/groups/presentation/pages/view_groups_page.dart';
import 'package:smd_project/features/home/presentation/pages/home_page.dart';
import 'package:smd_project/features/groups/presentation/pages/create_groups_page.dart';
>>>>>>> Stashed changes

final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final isAuth = FirebaseAuth.instance.currentUser != null;
    final isAuthRoute = state.matchedLocation == '/login' ||
        state.matchedLocation == '/signup' ||
        state.matchedLocation == '/forgot-password';

    if (!isAuth && !isAuthRoute) {
      return '/login';
    }

    if (isAuth && isAuthRoute) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/login',
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/home/create-group',
      builder: (context, state) => const CreateGroupPage(),
    ),
    GoRoute(
      path: '/home/join-group',
      builder: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          // fallback if user is not logged in
          return const LoginPage();
        }
        return JoinGroupScreen(userId: user.uid);
      },
    ),
<<<<<<< Updated upstream
    // GoRoute(
    //   path: '/home/group/:groupId',
    //   builder: (context, state) {
    //     final groupId = state.pathParameters['groupId']!;
    //     return GroupDetailPage(groupId: groupId);
    //   },
    // ),
=======
    GoRoute(
      path: '/home/group/:groupId',
      builder: (context, state) {
        return GroupLoader(rawGroupId: state.pathParameters['groupId']!);
      },
    ),
    GoRoute(
      path: '/home/settings',
      builder: (context, state) => const UserSettingsPage(),
    ),
    GoRoute(
      path: '/home/view-groups',
      builder: (context, state) => const ViewGroupsPage(),
    ),
>>>>>>> Stashed changes
  ],
);
