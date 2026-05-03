import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Tracks whether the device has any non-none network interface (Wi‑Fi, ethernet, etc.).
///
/// This is **interface** reachability, not a full “internet works” probe—enough to drive
/// “local vs live cloud” UX and to skip obvious remote calls (e.g. weather) when unplugged.
class NetworkReachabilityNotifier extends ChangeNotifier {
  NetworkReachabilityNotifier({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// `true` if any path other than [ConnectivityResult.none] is present.
  bool _online = true;

  bool get isOnline => _online;

  Future<void> init() async {
    final initial = await _connectivity.checkConnectivity();
    _apply(initial);
    _subscription = _connectivity.onConnectivityChanged.listen(_apply);
  }

  void _apply(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    if (online != _online) {
      _online = online;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
