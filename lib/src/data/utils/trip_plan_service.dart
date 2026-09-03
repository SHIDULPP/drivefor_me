import 'package:driveforme_user/src/data/models/route_summary_model.dart';

class TripPlanSuggestion {
  final bool isShortTrip;
  final int durationValue;
  final String durationUnit;
  final RouteSummary route;
  final int driveMinutes;

  const TripPlanSuggestion({
    required this.isShortTrip,
    required this.durationValue,
    required this.durationUnit,
    required this.route,
    required this.driveMinutes,
  });
}

class TripPlanService {
  static const shortTripMaxHours = 7;
  static const longTripMinHours = 8;

  const TripPlanService();

  /// Converts drive minutes to booking hours aligned with the map label
  /// (e.g. 8 hr 20 min drive → 8 booking hours, not 9 or 10).
  static int bookingHoursFromMinutes(int minutes) {
    if (minutes <= 0) return 1;

    final hours = minutes ~/ 60;
    final remainder = minutes % 60;

    if (remainder == 0) {
      return hours.clamp(1, 168);
    }

    // Only round up when the partial hour is more than half an hour.
    if (remainder > 30) {
      return (hours + 1).clamp(1, 168);
    }

    return hours.clamp(1, 168);
  }

  TripPlanSuggestion suggestFromRoute({
    required RouteSummary route,
  }) {
    final driveMinutes = route.durationMinutes;
    final suggestedHours = bookingHoursFromMinutes(driveMinutes);

    if (suggestedHours <= shortTripMaxHours) {
      return TripPlanSuggestion(
        isShortTrip: true,
        durationValue: suggestedHours,
        durationUnit: 'hours',
        route: route,
        driveMinutes: driveMinutes,
      );
    }

    if (suggestedHours < 24) {
      return TripPlanSuggestion(
        isShortTrip: false,
        durationValue: suggestedHours.clamp(longTripMinHours, 23),
        durationUnit: 'hours',
        route: route,
        driveMinutes: driveMinutes,
      );
    }

    final days = (suggestedHours / 24).ceil().clamp(1, 30);
    return TripPlanSuggestion(
      isShortTrip: false,
      durationValue: days,
      durationUnit: 'days',
      route: route,
      driveMinutes: driveMinutes,
    );
  }
}
