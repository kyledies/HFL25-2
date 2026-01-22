import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'app/app.dart';

Future<void> main() async {
  // 1. "Koppla in telefonlinjen" - Se till att Flutter kan prata med hårdvaran
  WidgetsFlutterBinding.ensureInitialized();
  // 2. Starta Firebase och vänta tills det är klart
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // crashlytics init - Flutter errors rapporteras automatiskt när detta är på 
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details); //fel skrivs ut i konsollen
    FirebaseCrashlytics.instance.recordFlutterError(details); //fel skickas till crashlytics
  };

  PlatformDispatcher.instance.onError = (error, stack) { // icke-Flutter fel, t.ex. nätverksfel etc - loggas som fatal i crashlytics
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final app = Firebase.app();
  debugPrint('Firebase projectId: ${app.options.projectId}');
  debugPrint('Firebase appId: ${app.options.appId}');
  // Tidigare: Kolla om användare sett introt
  //Nu ska vi istället använda Gorouter för att hantera detta.
  //final prefs = await SharedPreferences.getInstance();
  //final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  // Skicka med värdet in i MyApp
  //runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
  runApp(const App());
}


