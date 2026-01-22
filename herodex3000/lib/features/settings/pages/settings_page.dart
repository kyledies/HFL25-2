import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:herodex3000/core/services/analytics_service.dart';
import '../settings_cubit.dart';
import '../settings_state.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Inställningar',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          body: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Tema',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              // Vi använder RadioGroup för att hantera värdet och ändringar centralt.
              RadioGroup<ThemePreference>(
                groupValue: state.themePreference, // Det nuvarande valda värdet
                onChanged: (ThemePreference? v) {
                  if (v != null) {
                    context.read<SettingsCubit>().setThemePreference(v);
                  }
                },
                child: Column(
                  children: const [
                    RadioListTile<ThemePreference>(
                      title: Text('Auto (System)'),
                      value: ThemePreference.system,
                      // groupValue och onChanged behövs inte här längre
                    ),
                    RadioListTile<ThemePreference>(
                      title: Text('Light mode'),
                      value: ThemePreference.light,
                    ),
                    RadioListTile<ThemePreference>(
                      title: Text('Dark mode'),
                      value: ThemePreference.dark,
                    ),
                  ],
                ),
              ),

              const Divider(),

              CheckboxListTile(
                title: const Text('High contrast'),
                subtitle: const Text('Ökar kontrast för bättre läsbarhet.'),
                value: state.highContrast,
                onChanged: (v) =>
                    context.read<SettingsCubit>().setHighContrast(v ?? false),
              ),
              const Divider(),

              // --- NY SEKTION: DINA MEDGIVANDEN ---
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Dina medgivanden',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              // Analytics
              SwitchListTile(
                title: const Text('Analytics'),
                subtitle: const Text('Hjälp oss förbättra appen anonymt.'),
                secondary: const Icon(Icons.analytics_outlined),
                value: state
                    .analyticsEnabled, // OBS: Se till att denna finns i SettingsState
                onChanged: (v) => context.read<SettingsCubit>().setAnalytics(v),
              ),

              //Testknapp Analytics - !!
              ListTile(
                title: const Text('Testa Analytics'),
                subtitle: const Text(
                  'Loggar knapptryck (endast för utveckling).',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  if (!context.mounted) return;

                  await context.read<SettingsCubit>().logAnalyticsEvent(
                    'knapp_trycktes',
                    parameters: {
                      'knapp_namn': 'Testa Analytics',
                      'timestamp': DateTime.now().toIso8601String(),
                    },
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.read<SettingsCubit>().state.analyticsEnabled
                            ? 'Event skickat (Analytics är PÅ).'
                            : 'Ingen loggning (Analytics är AV).',
                      ),
                    ),
                  );
                },
              ),

              // Crashlytics
              SwitchListTile(
                title: const Text('Crashlytics'),
                subtitle: const Text('Rapportera krascher automatiskt.'),
                secondary: const Icon(Icons.bug_report_outlined),
                value: state
                    .crashlyticsEnabled, // OBS: Se till att denna finns i SettingsState
                onChanged: (v) => context.read<SettingsCubit>().setCrashlytics(
                  v,
                ), // OBS: Skapa denna metod i Cubit
              ),

              //Testknapp crashlytics - FUNGERAR!!
              // setCrashlyticsCollectionEnabled(false) -> Firebase sdk tar emot men skickar INTE till firebase
              ListTile(
                title: const Text('Testa Crashlytics'),
                subtitle: const Text(
                  'Skickar ett testfel (endast för utveckling).',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  try {
                    throw Exception('HeroDex Crashlytics test error');
                  } catch (e, st) {
                    await FirebaseCrashlytics.instance.recordError(
                      e,
                      st,
                      reason: 'Manual test button',
                      fatal: true,
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Testfel skickat (om Crashlytics är PÅ).',
                        ),
                      ),
                    );
                  }
                },
              ),

              // Location
              SwitchListTile(
                title: const Text('Platsdata'),
                subtitle: const Text('Används för lokala funktioner.'),
                secondary: const Icon(Icons.location_on_outlined),
                value: state
                    .locationEnabled, // OBS: Se till att denna finns i SettingsState
                onChanged: (v) => context.read<SettingsCubit>().setLocation(
                  v,
                ), // OBS: Skapa denna metod i Cubit
              ),
              const Divider(thickness: 7,),
              ListTile(
                title: Text(
                  'Om appen',
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                subtitle: Text(
                  'Beskrivning \nVersion: 1.0.0 \nSkapare: Fredrik Kristoffersson\n© 2026 HeroDex Inc.',
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                
              ),
            ],
          ),
        );
      },
    );
  }
}
