import 'dart:async';
import 'package:flutter/foundation.dart';

/// Gör en Stream till en Listenable som GoRouter kan "refresh:a" på.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _sub;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
