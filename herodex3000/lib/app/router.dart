//import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/auth_cubit.dart';
import '../features/auth/auth_state.dart';

import '../app/router_refresh.dart';
import '../core/storage/preferences.dart';

import '../features/auth/pages/login_page.dart';
import '../features/onboarding/pages/onboarding_page.dart';
import '../features/home/pages/home_page.dart';
import '../features/search/pages/search_page.dart';
import '../features/squad/pages/squad_page.dart';
import '../features/settings/pages/settings_page.dart';
import '../features/splash/pages/splash_page.dart';

import 'shell_scaffold.dart';

GoRouter createRouter({
  required AuthCubit authCubit,
  required PreferencesStore prefs,
}) {
  return GoRouter(
    // Starta alltid i splash så vi slipper redirect-flimmer innan auth är klar
    initialLocation: '/splash',

    // Redirect körs när AuthCubit emittar nytt state
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(path: 
      '/login', 
      builder: (context, state) => const LoginPage()
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),

      /// Shell runt “inloggade delen” av appen
      ShellRoute(
        builder: (context, state, child) {
          return ShellScaffold(location: state.uri.toString(), child: child);
        },
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomePage()),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: '/squad',
            builder: (context, state) => const SquadPage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],

    /// Här är hela "AuthFlow"-logiken, fast på router-nivå.
    redirect: (context, state) async {
      final authState = authCubit.state;

      final goingToSplash = state.matchedLocation == '/splash';
      final goingToLogin = state.matchedLocation == '/login';
      final goingToOnboarding = state.matchedLocation == '/onboarding';

       // 0) Auth inte redo än -> håll kvar i splash
      if (authState is AuthInitial) {
        return goingToSplash ? null : '/splash';
      }

      // 1) Utloggad -> alltid /login (ej splash)
      if (authState is AuthUnauthenticated) {
        return goingToLogin ? null : '/login';
      }

      // 2) Inloggad -> kolla onboarding
      if (authState is AuthAuthenticated) {
        final uid = authState.user.uid;

        final hasSeenOnboarding =
            await prefs.getHasSeenOnboardingForUser(uid);

        if (!hasSeenOnboarding) {
          return goingToOnboarding ? null : '/onboarding';
        }

        // 3) Inloggad + onboardad:
        // Om man försöker gå till login/onboarding/splash -> skicka till /home
        if (goingToLogin || goingToOnboarding || goingToSplash) {
          return '/home';
        }

        return null;
      }

      // Fallback (ska inte behövas)
      return null;
    },
  );
}