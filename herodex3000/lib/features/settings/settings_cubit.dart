/*SettingsCubit gör primärt två saker:
1 - Läser sparade inställningar (SharePreferenses från core) 
-> Lägger i SettingsState så UI visar rätt
2 - Enable/disable på datatjänster*/

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:herodex3000/core/services/location_service.dart';
import '../../core/storage/preferences.dart';
import '../auth/auth_repository.dart';
import 'settings_state.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final PreferencesStore prefs;
  final AuthRepository authRepository;
  final LocationService locationService;

  SettingsCubit(this.prefs, this.authRepository, this.locationService) : super(const SettingsState());

  /// Laddar inställningar från SharedPreferences och uppdaterar både:
  /// 1) UI (SettingsState) och
  /// 2) runtime-beteende (t.ex. Crashlytics på/av)
  ///
  /// Den här bör köras:
  /// - vid appstart
  /// - när användaren loggar in
  /// - när användare byts (A -> B)

  Future<void> load() async {
    // ----------------------------
    // 1) Tema-inställningar (globala, INTE per user)
    // ----------------------------
    final themePref = await prefs.getThemePref();
    final highContrast = await prefs.getHighContrast();

    // ----------------------------
    // 2) Consent-inställningar (per user/uid)
    // OBS: Hanteras i AuthCubit och laddas efter inloggning.
    final uid = authRepository.currentUser?.uid; // null om ej inloggad

    // Om uid är null (utloggad) sätter vi defaults (OFF) för consent i state.
    final analyticsEnabled = uid == null
        ? false
        : await prefs.getAnalyticsEnabledForUser(uid);
    final crashlyticsEnabled = uid == null
        ? false
        : await prefs.getCrashlyticsEnabledForUser(uid);
    final locationEnabled = uid == null
        ? false
        : await prefs.getLocationEnabledForUser(uid);

    // ----------------------------
    // 3) Applicera Crashlytics och Analytics inställning direkt
    // ----------------------------
    // Viktigt: detta gör att Crashlytics blir korrekt av/på även utan att
    // användaren rör en switch (t.ex. efter app-restart).
    await _applyCrashlyticsConfig(uid: uid, enabled: crashlyticsEnabled);
    await _applyAnalyticsConfig(uid: uid, enabled: analyticsEnabled);

    // ----------------------------
    // 4) Uppdatera UI-state med ändringar
    // ----------------------------

    emit(
      state.copyWith(
        isLoading: false,
        themePreference: _parseThemePref(themePref),
        highContrast: highContrast,
        analyticsEnabled: analyticsEnabled,
        crashlyticsEnabled: crashlyticsEnabled,
        locationEnabled: locationEnabled,
      ),
    );
  }

  // ----------------------------
  // Tema (globalt)
  // ----------------------------
  Future<void> setThemePreference(ThemePreference pref) async {
    emit(state.copyWith(themePreference: pref));
    // Spara tema i Preferences
    await prefs.setThemePref(_serializeThemePref(pref));
  }

  Future<void> setHighContrast(bool value) async {
    emit(state.copyWith(highContrast: value));
    await prefs.setHighContrast(value);
  }

  // ----------------------------
  // Consent (per uid)
  // ----------------------------
  Future<void> setAnalytics(bool value) async {
    final uid = authRepository.currentUser?.uid;
    if (uid == null) return;

    // 1) Uppdatera UI
    emit(state.copyWith(analyticsEnabled: value));
    // 2) Spara per user
    await prefs.setAnalyticsEnabledForUser(uid, value);
    // 3) Applicera i direkt
    await _applyAnalyticsConfig(uid: uid, enabled: value);
  }

  //Här slår vi på/av Crashlytics
  Future<void> setCrashlytics(bool value) async {
    final uid = authRepository.currentUser?.uid;
    if (uid == null) return;

    // 1) Uppdatera UI
    emit(state.copyWith(crashlyticsEnabled: value));
    // 2) Spara per user
    await prefs.setCrashlyticsEnabledForUser(uid, value);
    // 3) Applicera i direkt (så toggle gör skillnad direkt)
    await _applyCrashlyticsConfig(uid: uid, enabled: value);
  }

  Future<void> setLocation(bool value) async {
    final uid = authRepository.currentUser?.uid;
    if (uid == null) return;
    //Uppdatera UI direkt
    emit(state.copyWith(locationEnabled: value));
    await prefs.setLocationEnabledForUser(uid, value);

    //Riktig hantering av on/off för location nedan
    if (!value) {
      //location off
      return;
    }

    //ON: Be om plats-tillstånd - användare kan dock neka
    final granted = await locationService.ensurePermission();
    if (!granted) {
      //Användaren nekade plats-tillstånd
      emit(state.copyWith(locationEnabled: false));
      await prefs.setLocationEnabledForUser(uid, false);
    }
  }

  /// Körs när användaren loggar ut, så att UI inte visar tidigare användares consent.
  /// Tema/high-contrast är globalt och kan ligga kvar.
  void resetForLogout() {
    emit(
      state.copyWith(
        isLoading: true,
        analyticsEnabled: false,
        crashlyticsEnabled: false,
        locationEnabled: false,
      ),
    );
  }

  // ----------------------------
  // Runtime-konfig: Crashlytics
  // ----------------------------
  /// Slår på/av Crashlytics "på riktigt" och kopplar rapporter till rätt user.
  ///
  /// enabled = false:
  /// - stoppar insamling
  /// - rensar userIdentifier
  ///
  /// enabled = true:
  /// - tillåter insamling
  /// - sätter userIdentifier + custom keys
  Future<void> _applyCrashlyticsConfig({
    required String? uid,
    required bool enabled,
  }) async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled);

    if (!enabled || uid == null) {
      // Rensa identifiering om avstängt eller ingen användare
      await FirebaseCrashlytics.instance.setUserIdentifier('');
      return;
    }

    await FirebaseCrashlytics.instance.setUserIdentifier(uid);

    // Custom keys gör det enkelt att se vilket konto rapporten hör till
    await FirebaseCrashlytics.instance.setCustomKey('uid', uid);
    await FirebaseCrashlytics.instance.setCustomKey(
      'crashlytics_enabled',
      true,
    );
  }

  // Motsvarande för Analytics
  Future<void> _applyAnalyticsConfig({
    required String? uid,
    required bool enabled,
  }) async {
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(enabled);

    if (!enabled || uid == null) {
      // Rensa “koppling” (valfritt men snyggt)
      await FirebaseAnalytics.instance.setUserId(id: null);
      return;
    }

    // Sätt user id så events kopplas till rätt konto (i GA/Firebase)
    await FirebaseAnalytics.instance.setUserId(id: uid);

    // user property så man kan filtrera i rapporter
    await FirebaseAnalytics.instance.setUserProperty(
      name: 'analytics_enabled',
      value: 'true',
    );
  }

  // ----------------------------
  // --- Helpers ---
  // ----------------------------

/// Loggar ett Analytics-event OM analytics är på för användaren.
Future<void> logAnalyticsEvent(
  String name, {
  Map<String, Object?>? parameters,
}) async {
  if (!state.analyticsEnabled) return;

  await FirebaseAnalytics.instance.logEvent(
    name: name,
    parameters: parameters as Map<String, Object>?,
  );
}

  ThemePreference _parseThemePref(String value) {
    switch (value) {
      case 'light':
        return ThemePreference.light;
      case 'dark':
        return ThemePreference.dark;
      default:
        return ThemePreference.system;
    }
  }

  String _serializeThemePref(ThemePreference pref) {
    switch (pref) {
      case ThemePreference.light:
        return 'light';
      case ThemePreference.dark:
        return 'dark';
      case ThemePreference.system:
        //default:
        return 'system';
    }
  }
}
