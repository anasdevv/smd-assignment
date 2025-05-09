import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smd_project/features/authentication/presentation/pages/login_page.dart';
import 'package:smd_project/features/authentication/presentation/pages/signup_page.dart';
import 'package:smd_project/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:smd_project/features/authentication/presentation/pages/user_settings_page.dart';
import 'package:smd_project/features/groups/presentation/pages/join_group_page.dart';
import 'package:smd_project/features/home/presentation/pages/home_page.dart';
import 'package:smd_project/features/groups/presentation/pages/create_groups_page.dart';
import 'package:smd_project/features/groups/presentation/pages/group_info_page.dart';
import 'package:smd_project/features/groups/presentation/pages/group_details_page.dart';
import 'package:smd_project/features/groups/domain/entities/group_entity.dart';
import 'package:smd_project/features/groups/data/models/group_model.dart';

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
    GoRoute(
      path: '/home/group/:groupId',
      builder: (context, state) {
        final rawGroupId = state.pathParameters['groupId']!;
        // Clean the UniqueKey format by removing brackets and # symbol
        final groupId = rawGroupId.replaceAll(RegExp(r'[\[\]#]'), '');
        print("Raw Group id: $rawGroupId");
        print("Cleaned Group id: $groupId");

        return FutureBuilder<GroupModel>(
          future: FirebaseFirestore.instance
              .collection('groups')
              .doc(groupId)
              .get()
              .then((doc) {
            if (!doc.exists) {
              throw Exception('Group not found');
            }
            return GroupModel.fromMap(
                doc.id, doc.data() as Map<String, dynamic>);
          }),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(
                  child: Text('Group not found'),
                ),
              );
            }
            return GroupDetailsPage(group: snapshot.data!);
          },
        );
      },
    ),
    GoRoute(
      path: '/home/settings',
      builder: (context, state) => const UserSettingsPage(),
    ),
  ],
);
