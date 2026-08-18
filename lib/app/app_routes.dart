// File: lib/app/app_routes.dart
// Purpose: Routing table and GoRouter configuration for brokerflow-portal.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../modules/auth/screens/social_connection_success_screen.dart';
import '../modules/form/screens/lead_form_screen.dart';
import '../modules/splash/screens/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Global Navigator Key for AppOverlay/Toasts access
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  // Route Paths
  static const String initial = '/';

  // GoRouter Singleton Instance
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initial,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Route not found: ${state.uri.path}',
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: initial,
        name: 'home',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/form/:id',
        name: 'form-detail',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return LeadFormScreen(postId: id);
        },
      ),
      GoRoute(
        path: '/social-connection-result',
        name: 'social-connection-result',
        builder: (context, state) {
          final platform = state.uri.queryParameters['platform'] ?? 'facebook';
          final connected = state.uri.queryParameters['connected'] != 'false';
          final errorMessage = state.uri.queryParameters['error'];

          return SocialConnectionSuccessScreen(
            platform: platform,
            isConnected: connected,
            errorMessage: errorMessage,
          );
        },
      ),
    ],
  );
}
