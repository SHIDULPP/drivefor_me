import 'package:driveforme_user/src/data/apis/trip_api.dart';
import 'package:driveforme_user/src/data/models/trip_model.dart';
import 'package:driveforme_user/src/data/services/secure_storage_service.dart';
import 'package:driveforme_user/src/data/utils/trip_navigation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveTripService {
  final SecureStorageService _storage;
  final TripApi _tripApi;

  ActiveTripService({
    required SecureStorageService storage,
    required TripApi tripApi,
  })  : _storage = storage,
        _tripApi = tripApi;

  Future<TripNavigationTarget?> resolveResumableTrip() async {
    final storedId = await _storage.getActiveTripId();
    if (storedId != null && storedId.isNotEmpty) {
      final target = await _targetFromTripId(storedId);
      if (target != null) return target;
      await _storage.clearActiveTripId();
    }

    final inProgress = await _tripApi.listOngoingTrips();
    if (inProgress.success &&
        inProgress.data != null &&
        inProgress.data!.isNotEmpty) {
      final trip = inProgress.data!.first;
      await _storage.saveActiveTripId(trip.id);
      return tripNavigationTarget(trip);
    }

    final upcoming = await _tripApi.listUpcomingTrips();
    if (!upcoming.success || upcoming.data == null) return null;

    TripModel? best;
    for (final trip in upcoming.data!) {
      if (!isActiveTripStatus(trip.status)) continue;
      if (trip.status == 'driver_assigned') {
        best = trip;
        break;
      }
      best ??= trip;
    }

    if (best == null) return null;
    await _storage.saveActiveTripId(best.id);
    return tripNavigationTarget(best);
  }

  Future<TripNavigationTarget?> _targetFromTripId(String tripId) async {
    final response = await _tripApi.getTripById(tripId);
    if (!response.success || response.data == null) return null;

    final trip = response.data!;
    if (!isActiveTripStatus(trip.status) &&
        trip.status != 'completed') {
      return null;
    }

    if (trip.status == 'completed' && trip.isRated) return null;

    return tripNavigationTarget(trip);
  }
}

final activeTripServiceProvider = Provider<ActiveTripService>((ref) {
  return ActiveTripService(
    storage: ref.watch(secureStorageServiceProvider),
    tripApi: ref.watch(tripApiProvider),
  );
});
