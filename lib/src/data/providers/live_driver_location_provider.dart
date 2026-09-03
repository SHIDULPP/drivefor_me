import 'package:driveforme_user/src/data/models/trip_location_model.dart';
import 'package:driveforme_user/src/data/providers/notification_provider.dart';
import 'package:driveforme_user/src/data/providers/user_provider.dart';
import 'package:driveforme_user/src/data/services/secure_storage_service.dart';
import 'package:driveforme_user/src/data/services/trip_socket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiveDriverLocationUpdate {
  final String tripId;
  final String driverId;
  final TripLocation location;
  final String? tripStatus;

  const LiveDriverLocationUpdate({
    required this.tripId,
    required this.driverId,
    required this.location,
    this.tripStatus,
  });
}

class LiveDriverLocationNotifier extends Notifier<LiveDriverLocationUpdate?> {
  @override
  LiveDriverLocationUpdate? build() {
    ref.keepAlive();
    return null;
  }

  void apply(LiveDriverLocationUpdate update) {
    state = update;
  }

  void applyFromTrip({
    required String tripId,
    required String driverId,
    required TripLocation location,
    String? tripStatus,
  }) {
    if (tripId.isEmpty || !location.hasCoordinates) return;
    apply(
      LiveDriverLocationUpdate(
        tripId: tripId,
        driverId: driverId,
        location: location,
        tripStatus: tripStatus,
      ),
    );
  }

  void clearForTrip(String tripId) {
    if (state?.tripId == tripId) state = null;
  }
}

final liveDriverLocationProvider =
    NotifierProvider<LiveDriverLocationNotifier, LiveDriverLocationUpdate?>(
  LiveDriverLocationNotifier.new,
);

/// Connects the owner app to Socket.IO and keeps live driver GPS in sync.
class LiveTripTrackingNotifier extends Notifier<int> {
  @override
  int build() {
    ref.keepAlive();
    final socket = ref.watch(tripSocketServiceProvider);
    socket.connect(
      onDriverLocation: (payload) {
        final tripId = payload['tripId']?.toString() ?? '';
        final latitude = _toDouble(payload['latitude']);
        final longitude = _toDouble(payload['longitude']);
        if (tripId.isEmpty || latitude == null || longitude == null) return;

        ref.read(liveDriverLocationProvider.notifier).apply(
              LiveDriverLocationUpdate(
                tripId: tripId,
                driverId: payload['driverId']?.toString() ?? '',
                location: TripLocation(
                  latitude: latitude,
                  longitude: longitude,
                ),
                tripStatus: payload['tripStatus']?.toString(),
              ),
            );
      },
    );

    socket.listenForNewNotifications(() {
      ref.invalidate(notificationsProvider);
    });

    Future<void> joinOwnerRoom() async {
      final user = await ref.read(userProvider.future);
      var userId = user?.userId ?? '';
      if (userId.isEmpty) {
        userId = await ref.read(secureStorageServiceProvider).getUserId() ?? '';
      }
      if (userId.isEmpty) return;
      socket.joinUserRoom(userId);
    }

    joinOwnerRoom();
    return 0;
  }

  void trackTrip(String tripId) {
    if (tripId.isEmpty) return;
    ref.read(tripSocketServiceProvider).joinTripRoom(tripId);
  }

  void stopTrackingTrip(String tripId, {bool clearLocation = false}) {
    if (tripId.isEmpty) return;
    ref.read(tripSocketServiceProvider).leaveTripRoom(tripId);
    if (clearLocation) {
      ref.read(liveDriverLocationProvider.notifier).clearForTrip(tripId);
    }
  }
}

final liveTripTrackingProvider =
    NotifierProvider<LiveTripTrackingNotifier, int>(LiveTripTrackingNotifier.new);

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}
