import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/camera/presentation/screens/camera_screen_placeholder.dart';
import '../../features/pose/presentation/screens/pose_screen_placeholder.dart';
import '../../features/editor/presentation/screens/editor_screen_placeholder.dart';
import '../../features/profile/presentation/screens/profile_screen_placeholder.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

/// App GoRouter navigation configuration.
class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNav');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splashPath,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: RouteNames.splash,
        path: RouteNames.splashPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: RouteNames.onboarding,
        path: RouteNames.onboardingPath,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: RouteNames.home,
        path: RouteNames.homePath,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: RouteNames.camera,
        path: RouteNames.cameraPath,
        builder: (context, state) => const CameraScreenPlaceholder(),
      ),
      GoRoute(
        name: RouteNames.pose,
        path: RouteNames.posePath,
        builder: (context, state) => const PoseScreenPlaceholder(),
      ),
      GoRoute(
        name: RouteNames.editor,
        path: RouteNames.editorPath,
        builder: (context, state) => const EditorScreenPlaceholder(),
      ),
      GoRoute(
        name: RouteNames.profile,
        path: RouteNames.profilePath,
        builder: (context, state) => const ProfileScreenPlaceholder(),
      ),
      GoRoute(
        name: RouteNames.settings,
        path: RouteNames.settingsPath,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route Error: ${state.error}'),
      ),
    ),
  );
}
