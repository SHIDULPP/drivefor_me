import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

/// Socket.IO client for live trip tracking and in-app notifications.
class TripSocketService {
  TripSocketService({required this.socketUrl});

  final String socketUrl;
  io.Socket? _socket;
  void Function(Map<String, dynamic>)? _onDriverLocation;
  String? _userId;
  String? _tripId;

  bool get isConnected => _socket?.connected ?? false;

  void ensureConnected() => connect();

  void connect({
    void Function(Map<String, dynamic>)? onDriverLocation,
  }) {
    if (onDriverLocation != null) _onDriverLocation = onDriverLocation;

    _socket ??= io.io(
      socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .disableAutoConnect()
          .build(),
    );

    _socket!
      ..off('connect')
      ..off('driver_location_update')
      ..on('connect', (_) {
        log('Trip socket connected', name: 'TripSocketService');
        _rejoinRooms();
      })
      ..on('disconnect', (_) {
        log('Trip socket disconnected', name: 'TripSocketService');
      })
      ..on('driver_location_update', (data) {
        final map = _asMap(data);
        if (map != null) _onDriverLocation?.call(map);
      });

    if (_socket!.connected != true) {
      _socket!.connect();
    } else {
      _rejoinRooms();
    }
  }

  void _rejoinRooms() {
    if (_socket?.connected != true) return;
    if (_userId != null && _userId!.isNotEmpty) {
      _socket!.emit('join_user_room', {'userId': _userId});
    }
    if (_tripId != null && _tripId!.isNotEmpty) {
      _socket!.emit('join_trip_room', {'tripId': _tripId});
    }
  }

  void joinUserRoom(String userId) {
    if (userId.isEmpty) return;
    _userId = userId;
    ensureConnected();

    void join() => _socket?.emit('join_user_room', {'userId': userId});

    if (_socket?.connected == true) {
      join();
      return;
    }

    _socket?.once('connect', (_) => join());
  }

  void leaveUserRoom(String userId) {
    if (_userId == userId) _userId = null;
    if (_socket?.connected == true && userId.isNotEmpty) {
      _socket!.emit('leave_user_room', {'userId': userId});
    }
  }

  void joinTripRoom(String tripId) {
    if (tripId.isEmpty) return;
    _tripId = tripId;
    ensureConnected();

    void join() => _socket?.emit('join_trip_room', {'tripId': tripId});

    if (_socket?.connected == true) {
      join();
      return;
    }

    _socket?.once('connect', (_) => join());
  }

  void leaveTripRoom(String tripId) {
    if (_tripId == tripId) _tripId = null;
    if (_socket?.connected == true && tripId.isNotEmpty) {
      _socket!.emit('leave_trip_room', {'tripId': tripId});
    }
  }

  void listenForNewNotifications(void Function() onNewNotification) {
    _socket?.off('new_notification');
    _socket?.on('new_notification', (_) => onNewNotification());
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _onDriverLocation = null;
    _userId = null;
    _tripId = null;
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}

String socketUrlFromApiBase(String apiBaseUrl) {
  final uri = Uri.parse(apiBaseUrl);
  final portPart = uri.hasPort ? ':${uri.port}' : '';
  return '${uri.scheme}://${uri.host}$portPart';
}

final tripSocketServiceProvider = Provider<TripSocketService>((ref) {
  ref.keepAlive();
  final apiBase = dotenv.env['BASE_URL'] ?? '';
  final socketUrl = socketUrlFromApiBase(apiBase);
  final service = TripSocketService(socketUrl: socketUrl);
  ref.onDispose(service.disconnect);
  return service;
});
