import '../storage/preferences.dart';
import 'analytics_service.dart';

class ConsentAnalytics {
  final PreferencesStore prefs;
  final AnalyticsService analytics;

  ConsentAnalytics({
    required this.prefs,
    required this.analytics,
  });

  Future<void> logLogin(String uid) async {
    if (!await prefs.getAnalyticsEnabledForUser(uid)) return;
    await analytics.logLogin(method: 'email');
  }

  Future<void> logSignUp(String uid) async {
    if (!await prefs.getAnalyticsEnabledForUser(uid)) return;
    await analytics.logSignUp(method: 'email');
  }

  Future<void> logLogout(String uid) async {
    if (!await prefs.getAnalyticsEnabledForUser(uid)) return;
    await analytics.logLogout();
  }
}
