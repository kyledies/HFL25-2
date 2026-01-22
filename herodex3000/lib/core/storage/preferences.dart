//Onboarding val, status samt valt tema sparade lokalt med shared preferences
//OBS onboarding, Analytics/crashlytics/location är per användare (uid)
// Teman är globalt (ingen uid)

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesStore {

  String _onboardedKey(String uid) => 'onboarded_$uid';
  String _analyticsKey(String uid) => 'analytics_$uid';
  String _crashlyticsKey(String uid) => 'crashlytics_$uid';
  String _locationKey(String uid) => 'location_$uid';
  static const _keyThemePref = 'theme_pref'; // 'system' | 'light' | 'dark'
  static const _keyHighContrast = 'high_contrast';

//   ----------------------------- Onboarding status per UID -----------------------------
// --- Har användare sett onboarding? ---
  Future<bool> getHasSeenOnboardingForUser(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardedKey(uid)) ?? false;
  }

  Future<void> setHasSeenOnboardingForUser(String uid, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardedKey(uid), value);
  }

  // ---Användares val kring analytics ---
  Future<bool> getAnalyticsEnabledForUser(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_analyticsKey(uid)) ?? false; // default: OFF
  }

  Future<void> setAnalyticsEnabledForUser(String uid, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_analyticsKey(uid), value);
  }

  // ---Användares val kring crashlytics ---
  Future<bool> getCrashlyticsEnabledForUser(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_crashlyticsKey(uid)) ?? false; // default: OFF
  }

  Future<void> setCrashlyticsEnabledForUser(String uid, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_crashlyticsKey(uid), value);
  }

  // ---Användares val kring location ---
  Future<bool> getLocationEnabledForUser(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_locationKey(uid)) ?? false; // default: OFF
  }

  Future<void> setLocationEnabledForUser(String uid, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationKey(uid), value);
  }

//   ----------------------------- Tema-preferenser (globalt) -----------------------------

  Future<String> getThemePref() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyThemePref) ?? 'system';
  }

  Future<void> setThemePref(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyThemePref, value);
  }

  Future<bool> getHighContrast() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHighContrast) ?? false;
  }

  Future<void> setHighContrast(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHighContrast, value);
  }
}