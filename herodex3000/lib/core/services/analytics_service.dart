import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object?>? parameters});
  Future<void> logLogin({required String method});
  Future<void> logSignUp({required String method});
  Future<void> logLogout();
}

class FirebaseAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) {
    return FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters as Map<String, Object>?);
  }
  @override
  Future<void> logLogin({required String method}) {
    return FirebaseAnalytics.instance.logLogin(loginMethod: method);
  }

  @override
  Future<void> logSignUp({required String method}) {
    return FirebaseAnalytics.instance.logSignUp(signUpMethod: method);
  }

  @override
  Future<void> logLogout() {
    return FirebaseAnalytics.instance.logEvent(name: 'logout');
  }
}

class NoopAnalyticsService implements AnalyticsService {
  @override
  Future<void> logEvent(String name, {Map<String, Object?>? parameters}) async {
    // Do nothing (användaren har sagt nej)
  }
  @override
  Future<void> logLogin({required String method}) async {
    // gör ingenting
  }

  @override
  Future<void> logSignUp({required String method}) async {
    // gör ingenting
  }

  @override
  Future<void> logLogout() async {
    // gör ingenting
  }
}
