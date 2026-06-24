import 'package:driveforme_user/src/data/apis/trip_api.dart';
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

  /// Resumes only the trip id persisted during booking — never scans all trips.
  Future<TripNavigationTarget?> resolveResumableTrip() async {
    final storedId = await _storage.getActiveTripId();
    if (storedId == null || storedId.isEmpty) return null;

    return _targetFromTripId(storedId);
  }

  Future<TripNavigationTarget?> _targetFromTripId(String tripId) async {
    final response = await _tripApi.getTripById(tripId);
    if (!response.success || response.data == null) {
      await _storage.clearActiveTripId();
      return null;
    }

    final trip = response.data!;

    if (trip.isCancelled || (trip.isCompleted && trip.isRated)) {
      await _storage.clearActiveTripId();
      return null;
    }

    if (!isActiveTripStatus(trip.status) && !trip.isCompleted) {
      await _storage.clearActiveTripId();
      return null;
    }

    final target = tripNavigationTarget(trip);
    if (target == null) {
      await _storage.clearActiveTripId();
    }
    return target;
  }
}

final activeTripServiceProvider = Provider<ActiveTripService>((ref) {
  return ActiveTripService(
    storage: ref.watch(secureStorageServiceProvider),
    tripApi: ref.watch(tripApiProvider),
  );
});
