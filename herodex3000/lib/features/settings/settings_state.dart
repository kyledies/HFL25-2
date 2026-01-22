import 'package:equatable/equatable.dart';

enum ThemePreference { system, light, dark }

class SettingsState extends Equatable {
  final bool isLoading;
  //Temaval - lagras i Preferences
  final ThemePreference themePreference;
  final bool highContrast;

  // Medgivanden till analytics, crashlytics och location - lagras per användare i PreferencesStore (med UID som nyckel).
  final bool analyticsEnabled;
  final bool crashlyticsEnabled;
  final bool locationEnabled;

  const SettingsState({
    this.isLoading = true,
    this.themePreference = ThemePreference.system,
    this.highContrast = false,
    this.analyticsEnabled = false,
    this.crashlyticsEnabled = false,
    this.locationEnabled = false,
  });

  SettingsState copyWith({
    bool? isLoading,
    ThemePreference? themePreference,
    bool? highContrast,
    bool? analyticsEnabled,
    bool? crashlyticsEnabled,
    bool? locationEnabled,
}) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      themePreference: themePreference ?? this.themePreference,
      highContrast: highContrast ?? this.highContrast,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      crashlyticsEnabled: crashlyticsEnabled ?? this.crashlyticsEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
        themePreference,
        highContrast,
        analyticsEnabled,
        crashlyticsEnabled,
        locationEnabled,
  ];
}
