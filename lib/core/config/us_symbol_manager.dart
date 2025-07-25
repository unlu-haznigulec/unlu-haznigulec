import 'dart:async';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:signalr_netcore/hub_connection.dart';

class UsSymbolManager {
  HubConnection? hubConnection;
  final Future<void> Function() connectCallback;
  bool _isConnecting = false;
  int _retryCount = 0;
  final int _maxRetryAttempts = 5;
  final Duration _retryDelay = const Duration(seconds: 5);
  bool _isManuallyDisconnected = false;

  UsSymbolManager(this.hubConnection, this.connectCallback) {
    _setupConnectionEvents();
    _startConnectionLoop();
  }

  bool get isConnected => hubConnection?.state == HubConnectionState.Connected;

  void _setupConnectionEvents() {
    if (hubConnection == null) return;

    hubConnection!.onclose(({error}) {
      if (!_isManuallyDisconnected) {
        talker.warning('SignalR connection closed. Trying to reconnect...');
        _retryStartConnection();
      } else {
        talker.warning('Connection closed by manual disconnection');
      }
    });

    hubConnection!.onreconnecting(({error}) async {
      if (_isManuallyDisconnected) {
        talker.warning('Manual disconnect during reconnect, stopping connection...');
        await hubConnection!.stop();
      } else {
        talker.warning('SignalR is reconnecting...');
      }
    });

    hubConnection!.onreconnected(({connectionId}) {
      if (!_isManuallyDisconnected) {
        talker.warning('SignalR reconnected with id: $connectionId');
        _retryCount = 0;
      }
    });
  }

  Future<void> _ensureConnection() async {
    if (hubConnection == null) {
      talker.warning('HubConnection is null, trying to reconnect from callback...');
      await connectCallback();
      hubConnection = getIt<UsSymbolManager>().hubConnection;
      _setupConnectionEvents();
    }
  }

  Future<void> _retryStartConnection() async {
    await _ensureConnection();

    if (_isConnecting || _retryCount >= _maxRetryAttempts || _isManuallyDisconnected) return;
    if (hubConnection?.state == HubConnectionState.Connected) {
      talker.warning('Connection already established. Skipping retry.');
      _isConnecting = false;
      _retryCount = 0;
      return;
    }

    _isConnecting = true;
    _retryCount++;

    try {
      await hubConnection?.stop();
      await hubConnection?.start();
      talker.warning('SignalR reconnected successfully.');
      _retryCount = 0;
    } catch (e) {
      talker.warning('Reconnection failed (Attempt $_retryCount/$_maxRetryAttempts): $e');
      if (_retryCount < _maxRetryAttempts && !_isManuallyDisconnected) {
        await Future.delayed(_retryDelay);
        await _retryStartConnection();
      } else {
        talker.warning('Max reconnection attempts reached. Stopping.');
      }
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> startConnection() async {
    await _ensureConnection();

    if (hubConnection == null ||
        _isConnecting ||
        isConnected ||
        hubConnection!.state == HubConnectionState.Connecting ||
        hubConnection!.state == HubConnectionState.Reconnecting) {
      return;
    }

    _isManuallyDisconnected = false;
    await _retryStartConnection();
  }

  Future<void> subscribeToSymbols(List<String> symbols) async {
    await _ensureConnection();
    if (!isConnected) return;

    try {
      await hubConnection!.invoke('Subscribe', args: [symbols]);
      talker.warning('Subscribed to: $symbols');
    } catch (e) {
      talker.warning('Error subscribing to symbols: $e');
    }
  }

  Future<void> unsubscribeFromSymbols(List<String> symbols) async {
    await _ensureConnection();
    if (!isConnected) return;

    try {
      await hubConnection!.invoke('Unsubscribe', args: [symbols]);
      talker.warning('Unsubscribed from symbols: $symbols');
    } catch (e) {
      talker.warning('Error unsubscribing from symbols: $e');
    }
  }

  Future<void> stopConnection({bool isManualDisconnect = false}) async {
    if (hubConnection == null) return;
    if (isManualDisconnect) {
      _isManuallyDisconnected = true;
    }
    try {
      await hubConnection!.stop();
      talker.warning('SignalR connection stopped. isManual: $isManualDisconnect');
    } catch (e) {
      talker.warning('Error stopping connection: $e');
    } finally {
      if (!isManualDisconnect) {
        _isManuallyDisconnected = false;
      }
    }
  }

  void _startConnectionLoop() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!_isManuallyDisconnected && !isConnected && !_isConnecting) {
        talker.warning('Periodic check: connection lost, attempting to reconnect...');
        await startConnection();
      }
    });
  }

  void dispose() {
    stopConnection(isManualDisconnect: true);
  }
}
