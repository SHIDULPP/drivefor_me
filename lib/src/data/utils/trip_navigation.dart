import 'package:driveforme_user/src/data/models/trip_model.dart';

class TripNavigationTarget {
  final String route;
  final Map<String, dynamic> arguments;

  const TripNavigationTarget({
    required this.route,
    required this.arguments,
  });
}

const _activeTripStatuses = {
  'pending_assignment',
  'scheduled',
  'driver_assigned',
  'in_progress',
};

bool isActiveTripStatus(String status) => _activeTripStatuses.contains(status);

/// Returns the route + args for resuming or transitioning based on trip status.
TripNavigationTarget? tripNavigationTarget(TripModel trip) {
  switch (trip.status) {
    case 'pending_assignment':
    case 'scheduled':
      return TripNavigationTarget(
        route: 'waiting_driver',
        arguments: trip.toWaitingDriverArguments(),
      );
    case 'driver_assigned':
      return TripNavigationTarget(
        route: 'driver_found',
        arguments: trip.toDriverFoundArguments(),
      );
    case 'in_progress':
      return TripNavigationTarget(
        route: 'trip_progress',
        arguments: trip.toProgressArguments(),
      );
    case 'completed':
      if (trip.isRated) return null;
      return TripNavigationTarget(
        route: 'trip_completed',
        arguments: trip.toTripCompletedArguments(),
      );
    case 'cancelled':
      return null;
    default:
      return null;
  }
}
