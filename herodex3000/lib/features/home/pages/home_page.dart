import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:herodex3000/core/services/consent_analytics.dart';
import 'package:herodex3000/core/services/location_service.dart';
import 'package:herodex3000/features/auth/auth_cubit.dart';
import 'package:herodex3000/features/auth/auth_repository.dart';
import 'package:herodex3000/features/home/widgets/simple_weather_view.dart';
import 'package:herodex3000/features/settings/settings_cubit.dart';
import 'package:herodex3000/features/settings/settings_state.dart';
import 'package:herodex3000/shared/widgets/loading_widget.dart';
import '../widgets/simple_map_view.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthRepository>().currentUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Hem', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(
            onPressed: () async {
              final authCubit = context.read<AuthCubit>();
              final authRepo = context.read<AuthRepository>();
              final consentAnalytics = context.read<ConsentAnalytics>();
              final uid = authRepo.currentUser?.uid;
              //1 Logga logout om vi har medgivande, annars loggas inget
              if (uid != null) {
                await consentAnalytics.logLogout(uid);
              }
              //2 Logga ut användare
              await authCubit.signOut();
            },
            icon: Icon(
              Icons.logout_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            tooltip: 'Logga ut',
            padding: const EdgeInsets.all(12),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 24), // lite top-spacing

            Text(
              'This is the home Page',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Welcome to the home page ${user!.email}!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🗺️ NYTT: KARTA UNDER TEXTEN
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, settings) {
                //Ett tag visades gif med plats avstängd oavsett vid ut/inloggning.
                // Checkar nu först isLoading först:
                if (settings.isLoading) {
                  return Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: AppLoader(label: 'Laddar…'),
                    ),
                  );
                }
                // Nu check - OM location är AVSTÄNGD:
                if (!settings.locationEnabled) {
                  return Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 🎞️ GIF
                        SizedBox(
                          height: 120,
                          child: Image.asset(
                            'assets/nyan-cat.gif',
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // 📝 Text
                        Text(
                          'Platsdata är avstängt 😢\n'
                          'Slå på platsåtkomst i Inställningar\n'
                          'så kan vi visa kartan och väder!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextButton.icon(
                          onPressed: () {
                            context.push('/settings');
                          },
                          icon: const Icon(Icons.settings),
                          label: const Text('Öppna inställningar'),
                        ),
                      ],
                    ),
                  );
                }

                // ✅ Location ON
                return SizedBox(
                  height: 250,
                  child: Column(
                    children: [
                      SimpleWeatherBox(
                        locationService: context.read<LocationService>(),
                      ),
                      const Expanded(child: SimpleMapView()),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
