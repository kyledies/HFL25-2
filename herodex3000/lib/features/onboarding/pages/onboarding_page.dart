import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:herodex3000/features/auth/auth_repository.dart';
import 'package:herodex3000/features/settings/settings_cubit.dart';
import '../../../core/storage/preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool analytics = false;
  bool crashlytics = false;
  bool location = false;

  final prefs = PreferencesStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Rubrik som använder temat (headlineSmall passar bra för sidrubriker)
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Hjälp oss att optimera din upplevelse!',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),

            // Analytics
            SwitchListTile(
              title: const Text('Analytics'),
              subtitle: const Text('Hjälp oss förstå användning (kan stängas av).'),
              secondary: const Icon(Icons.analytics_outlined),
              value: analytics,
              onChanged: (v) => setState(() => analytics = v),
            ),

            // Crashlytics
            SwitchListTile(
              title: const Text('Crashlytics'),
              subtitle: const Text('Skickar kraschrapporter (kan stängas av).'),
              secondary: const Icon(Icons.bug_report_outlined),
              value: crashlytics,
              onChanged: (v) => setState(() => crashlytics = v),
            ),

            // Location
            SwitchListTile(
              title: const Text('Platsdata'), // Ändrade till svenska för konsekvens
              subtitle: const Text('Används för karta & väder.'),
              secondary: const Icon(Icons.location_on_outlined),
              value: location,
              onChanged: (v) => setState(() => location = v),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              // FilledButton är standard för "viktigaste knappen" i Material 3
              child: FilledButton(
                onPressed: () async {
                  final user = context.read<AuthRepository>().currentUser;
                  if (user != null) {
                    await prefs.setAnalyticsEnabledForUser(user.uid, analytics);
                    await prefs.setCrashlyticsEnabledForUser(user.uid, crashlytics);
                    await prefs.setLocationEnabledForUser(user.uid, location);
                    await prefs.setHasSeenOnboardingForUser(user.uid, true);

                    if (!mounted) return;

                    // Ladda om inställningarna så appen vet vad som valdes
                    context.read<SettingsCubit>().load();

                    context.go('/home');
                  }
                },
                child: const Text('Fortsätt'), // Ändrade till svenska
              ),
            ),
            const SizedBox(height: 16), // Lite luft i botten
          ],
        ),
      ),
    );
  }
}
