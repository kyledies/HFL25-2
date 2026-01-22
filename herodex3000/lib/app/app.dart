import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:herodex3000/core/services/location_service.dart';
import 'package:herodex3000/features/auth/auth_state.dart';

import '../core/storage/preferences.dart';
import '../core/ui/themes.dart';

import '../features/settings/settings_cubit.dart';
import '../features/settings/settings_state.dart';

import '../features/auth/auth_cubit.dart';
import '../features/auth/auth_repository.dart';
import 'router.dart';

import '../core/services/analytics_service.dart';
import '../core/services/consent_analytics.dart';

/*
ARKITEKTURÖVERSIKT (Repository + Cubit + State)
----------------------------------------------

Repository
- Datalagret.
- Pratar med externa system (Firebase, SharedPreferences, GPS, API:er).
- Ska vara stabilt, förutsägbart och fritt från UI-logik.

State
- Kontraktet mellan logik och UI.
- Beskriver vilka lägen appen kan befinna sig i
  (t.ex. inloggad/utloggad, loading/färdig).

Cubit
- Logiklagret.
- Håller ett aktuellt State.
- Exponerar metoder som UI kan anropa.
- Emitterar nytt State när något förändras.
*/
class App extends StatelessWidget {
  const App({super.key});
  // App är "root"-widgeten. Här kopplar vi in:
  // 1) Dependency Injection (Repository/Service providers)
  // 2) State management (Cubits)
  // 3) Router + Theme (som beror på SettingsState)
  @override
  Widget build(BuildContext context) {
    // RepositoryProvider = "globalt tillgängliga objekt" (tjänster/repositories)
    // Alla widgets under denna nivå kan göra: context.read<T>()
    return MultiRepositoryProvider(
      providers: [
        /// 1) PreferencesStore (lokal key-value-lagring via SharedPreferences)
        /// - Globala inställningar: tema (system/light/dark), high contrast
        /// - Per användare (uid): onboarding + consent (analytics/crashlytics/location)
        /// - Används av:
        ///   * SettingsCubit (läsa/spara inställningar)
        ///   * router redirect (avgör onboarding)
        ///   * ConsentAnalytics (kollar medgivande innan loggning)
        RepositoryProvider(create: (_) => PreferencesStore()),

        /// 2) LocationService
        /// - Hanterar plats-behörighet och position via Geolocator
        /// - Själva "on/off" styrs av SettingsCubit (consent per uid)
        RepositoryProvider(create: (_) => LocationService()),

        /// 3) AnalyticsService (abstraktion)
        /// - FirebaseAnalyticsService loggar event till Firebase Analytics
        /// - Byggt som interface så vi kan byta implementation (t.ex. Noop)
        /// - I vår app används det alltid via ConsentAnalytics, så användarens
        ///   medgivande respekteras (inget loggas om consent = OFF)
        RepositoryProvider<AnalyticsService>(
          create: (_) => FirebaseAnalyticsService(),
        ),

        /// 4) ConsentAnalytics (”gate” framför analytics)
        /// - Wrapper som kontrollerar medgivande i PreferencesStore per uid
        /// - Endast om consent är ON skickas event vidare till AnalyticsService
        RepositoryProvider<ConsentAnalytics>(
          create: (context) => ConsentAnalytics(
            prefs: context.read<PreferencesStore>(),
            analytics: context.read<AnalyticsService>(),
          ),
        ),

        /// 5) AuthRepository (datalager för Firebase Auth)
        /// - Enda klassen som pratar direkt med FirebaseAuth
        /// - Exponerar authStateChanges stream (inloggad/utloggad)
        RepositoryProvider(create: (_) => AuthRepository()),
      ],
      // MultiBlocProvider skapar våra Cubits och ger dem det Repository de behöver.
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            /// AuthCubit:
            /// - Lyssnar på AuthRepository.authStateChanges i realtid
            /// - Emit: AuthAuthenticated(user) / AuthUnauthenticated()
            create: (context) => AuthCubit(context.read<AuthRepository>()),
          ),

          /// SettingsCubit:
          /// - Läser sparade inställningar från PreferencesStore
          /// - load() körs direkt för att sätta theme + defaults vid appstart
          BlocProvider(
            create: (context) => SettingsCubit(
              context.read<PreferencesStore>(),
              context.read<AuthRepository>(),
              context.read<LocationService>(),
            )..load(),
          ),
        ],
        // Builder används här för att vi vill skapa router med åtkomst till context,
        // dvs efter att providers/cubits är på plats.
        child: Builder(
          builder: (context) {
            // Router skapas med redirect-funktion som kollar AuthState + onboarding-status
            // och skickar användaren till rätt sida
            // Vid appstart: /splash
            // - skicka utloggade till /login
            // - skicka inloggade men ej onboardade till /onboarding
            // - släppa in onboardade till /home och övriga sidor i ShellRoute
            final router = createRouter(
              authCubit: context.read<AuthCubit>(),
              prefs: context.read<PreferencesStore>(),
            );

            // SettingsCubit styr temat. När SettingsState ändras byggs MaterialApp om
            return BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                // Vi använder high-contrast först när vi laddat klart settings
                final useHighContrast = !state.isLoading && state.highContrast;

                final theme = useHighContrast
                    ? AppThemes.highContrastLight()
                    : AppThemes.light();

                final darkTheme = useHighContrast
                    ? AppThemes.highContrastDark()
                    : AppThemes.dark();

                final themeMode = switch (state.themePreference) {
                  ThemePreference.system => ThemeMode.system,
                  ThemePreference.light => ThemeMode.light,
                  ThemePreference.dark => ThemeMode.dark,
                };

                return BlocListener<AuthCubit, AuthState>(
                  listener: (context, authState) async {
                    final settingsCubit = context.read<SettingsCubit>();
                    final consentAnalytcs = context.read<ConsentAnalytics>();
                    final authRepo = context.read<AuthRepository>();

                    // Vid login:
                    // - ladda inställningar för aktuell användare (uid-baserad consent)
                    // - logga login-event om analytics-consent är ON
                    if (authState is AuthAuthenticated) {
                      await settingsCubit.load();

                      // Logga login per uid och consent när man är inloggad
                      final uid = authRepo.currentUser?.uid;
                      if (uid != null) {
                        await consentAnalytcs.logLogin(uid);
                      }
                    }
                    // Vid logout:
                    // - nollställ consent i UI (så vi inte visar förra användarens val)
                    // - (själva logout-event kan loggas där du triggar logout, t.ex. HomePage)
                    if (authState is AuthUnauthenticated) {
                      settingsCubit.resetForLogout();
                    }
                  },
                  child: MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    routerConfig: router,
                    theme: theme,
                    darkTheme: darkTheme,
                    themeMode: themeMode,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
