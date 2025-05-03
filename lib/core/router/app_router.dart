import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smd_project/features/authentication/presentation/pages/login_page.dart';
import 'package:smd_project/features/home/presentation/pages/home_page.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isAuth = FirebaseAuth.instance.currentUser != null;
    final isAuthRoute = state.matchedLocation == '/login';

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
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
