import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

enum ConnectionStatus { online, poor, offline }

@lazySingleton
class ConnectivityService {
  final Connectivity _connectivity;
  final _statusController = StreamController<ConnectionStatus>.broadcast();

  ConnectionStatus _currentStatus = ConnectionStatus.online;

  ConnectivityService() : _connectivity = Connectivity() {
    _init();
  }

  Stream<ConnectionStatus> get statusStream => _statusController.stream;
  ConnectionStatus get currentStatus => _currentStatus;

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final newStatus = _mapToConnectionStatus(results);
    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _statusController.add(newStatus);
    }
  }

  ConnectionStatus _mapToConnectionStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      return ConnectionStatus.offline;
    }
    if (results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet)) {
      return ConnectionStatus.online;
    }
    if (results.contains(ConnectivityResult.mobile)) {
      // Could implement ping test here for "poor" detection
      return ConnectionStatus.online;
    }
    return ConnectionStatus.offline;
  }

  Future<void> dispose() async {
    await _statusController.close();
  }
}
