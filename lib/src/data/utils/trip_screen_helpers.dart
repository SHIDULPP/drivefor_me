import 'package:driveforme_user/src/data/apis/trip_api.dart';
import 'package:driveforme_user/src/data/models/trip_model.dart';
import 'package:driveforme_user/src/data/providers/active_trip_provider.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:driveforme_user/src/data/utils/trip_lifecycle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches trip from API and caches it in [activeTripProvider].
Future<TripModel?> fetchAndCacheTrip(WidgetRef ref, String tripMongoId) async {
  if (tripMongoId.isEmpty) return null;

  final response = await ref.read(tripApiProvider).getTripById(tripMongoId);
  if (!response.success || response.data == null) return null;

  final trip = response.data!;
  await ref
      .read(activeTripProvider.notifier)
      .setActiveTrip(tripMongoId, trip: trip);
  return trip;
}

/// Navigates away from [driver_found] when the trip advances past OTP sharing.
/// Handles in-progress, completed, and cancelled without requiring the user
/// to have visited [trip_progress] first.
Future<bool> navigateIfTripLeftDriverFoundStage({
  required WidgetRef ref,
  required TripModel trip,
}) async {
  if (trip.isCancelled) {
    await ref.read(activeTripProvider.notifier).clear();
    await navigateAfterTripCancelled(trip.toCancelledDetailsArguments());
    return true;
  }

  if (trip.isInProgress) {
    NavigationService().pushNamedReplacement(
      'trip_progress',
      arguments: trip.toProgressArguments(),
    );
    return true;
  }

  if (trip.isCompleted) {
    await ref.read(activeTripProvider.notifier).clear();
    NavigationService().pushNamedReplacement(
      'trip_completed',
      arguments: trip.toTripCompletedArguments(),
    );
    return true;
  }

  return false;
}

void openTripHelp({
  required String tripLabel,
  String? tripMongoId,
}) {
  NavigationService().pushNamed(
    'raise_ticket',
    arguments: {
      'tripId': tripLabel,
      if (tripMongoId != null && tripMongoId.isNotEmpty)
        'tripMongoId': tripMongoId,
      'category': 'Trip Support',
    },
  );
}
