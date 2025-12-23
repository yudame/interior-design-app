import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/design_studio/presentation/pages/design_studio_page.dart';
import '../../features/gallery/presentation/pages/gallery_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/gallery',
    redirect: (context, state) {
      // TODO: Add auth redirect logic
      // final isLoggedIn = authBloc.state.isAuthenticated;
      // final isAuthRoute = state.matchedLocation.startsWith('/auth');
      // if (!isLoggedIn && !isAuthRoute) return '/auth/login';
      // if (isLoggedIn && isAuthRoute) return '/gallery';
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/auth/signup',
        name: 'signup',
        builder: (context, state) => const SignupPage(),
      ),

      // Main routes
      GoRoute(
        path: '/gallery',
        name: 'gallery',
        builder: (context, state) => const GalleryPage(),
      ),
      GoRoute(
        path: '/studio',
        name: 'studio-new',
        builder: (context, state) => const DesignStudioPage(),
      ),
      GoRoute(
        path: '/studio/:projectId',
        name: 'studio',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return DesignStudioPage(projectId: projectId);
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
}
