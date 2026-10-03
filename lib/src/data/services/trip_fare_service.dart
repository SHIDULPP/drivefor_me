import 'package:DriveForme/src/data/models/pricing_settings_model.dart';
import 'package:DriveForme/src/data/models/trip_price_estimate_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mirrors backend `calculateTripFare` in `trip.service.js` using pricing rules
/// from `GET /pricing`.
class TripFareService {
  TripPriceEstimateModel? estimate({
    required Map<String, dynamic> payload,
    required PricingSettingsModel settings,
  }) {
    final tripType = payload['tripType']?.toString();
    final durationValue = _toInt(payload['durationValue']);
    final durationUnit = payload['durationUnit']?.toString() ?? 'hours';
    final additionalHours = _toInt(payload['additionalHours']) ?? 0;
    final overnightStay = payload['overnightStay'] as Map<String, dynamic>? ??
        const {'required': false};
    final tripProtection = payload['tripProtection'] as Map<String, dynamic>?;

    if (tripType == null || durationValue == null) {
      return null;
    }
    if (durationUnit != 'custom' && durationValue < 1) {
      return null;
    }
    if (durationUnit == 'custom' &&
        durationValue < 1 &&
        additionalHours < 1) {
      return null;
    }

    final pickupAt = _resolvePickupAt(payload);
    final fare = _calculateTripFare(
      settings: settings,
      tripType: tripType,
      durationValue: durationValue,
      durationUnit: durationUnit,
      additionalHours: additionalHours,
      overnightStay: overnightStay,
      pickupAt: pickupAt,
    );

    final protectionFee = tripProtection?['enabled'] == true
        ? (_toDouble(tripProtection?['fee']) ?? 0)
        : 0.0;
    final customerTotal = fare.totalFare + protectionFee;
    final isShort = tripType == 'short_trip';

    return TripPriceEstimateModel(
      minimum: customerTotal,
      maximum: customerTotal,
      currency: 'INR',
      basisLabel: isShort ? 'Short trip fare' : 'Long trip fare',
      includesWaitingTime: isShort,
      cashTotal: customerTotal,
      payOnlineTotal: customerTotal,
      baseFare: fare.baseFare,
      // Runtime Extra Time (actual vs maps ETA) is unknown at booking.
      extraTimeCharge: 0,
      extraHours: 0,
      tripProtectionFee: protectionFee,
      gstAmount: fare.gstAmount,
    );
  }

  DateTime _resolvePickupAt(Map<String, dynamic> payload) {
    if (payload['rideTime'] == 'scheduled') {
      final date = payload['pickupDate']?.toString();
      final time = payload['pickupTime']?.toString();
      if (date != null && time != null) {
        final parsed = DateTime.tryParse('${date}T$time:00');
        if (parsed != null) return parsed;
      }
    }
    return DateTime.now();
  }

  _FareBreakdown _calculateTripFare({
    required PricingSettingsModel settings,
    required String tripType,
    required int durationValue,
    required String durationUnit,
    int additionalHours = 0,
    required Map<String, dynamic> overnightStay,
    required DateTime pickupAt,
  }) {
    final isShort = tripType == 'short_trip';
    var baseFare = 0.0;
    var packageAdditionalCharge = 0.0;
    var stayAllowanceCharge = 0.0;

    if (isShort) {
      // Flat minimum charge for ~10 min through baseDurationHrs (default 4h).
      // Not "rate × hours" inside that window.
      baseFare = settings.shortTripBaseHourlyRate;
      final baseHrs = settings.shortTripBaseDurationHrs.toInt();
      // Booked hours beyond the minimum window only.
      if (durationValue > baseHrs) {
        packageAdditionalCharge =
            (durationValue - baseHrs) * settings.shortTripAdditionalHourlyRate;
      }
    } else if (durationUnit == 'custom') {
      // UI "1 day + 13 hrs" = 37 hours planned — long-trip hours formula.
      // perDayRate covers first 12h; remaining hours × additionalHourlyRate.
      // (Extra Time at trip end is actual − this planned expected, not the 13h.)
      final totalHours = durationValue * 24 + additionalHours;
      baseFare = settings.longTripPerDayRate;
      if (totalHours > 12) {
        packageAdditionalCharge =
            (totalHours - 12) * settings.longTripAdditionalHourlyRate;
      }
      if (overnightStay['required'] == true && durationValue >= 1) {
        final nights = _toInt(overnightStay['nights']) ?? 0;
        stayAllowanceCharge = nights * settings.longTripStayAllowance;
      }
    } else if (durationUnit == 'days') {
      baseFare = durationValue * settings.longTripPerDayRate;
      if (overnightStay['required'] == true) {
        final nights = _toInt(overnightStay['nights']) ?? 0;
        stayAllowanceCharge = nights * settings.longTripStayAllowance;
      }
    } else {
      baseFare = settings.longTripPerDayRate;
      if (durationValue > 12) {
        packageAdditionalCharge =
            (durationValue - 12) * settings.longTripAdditionalHourlyRate;
      }
    }

    final packageLabor = baseFare + packageAdditionalCharge;
    final subtotal = packageLabor + stayAllowanceCharge;
    var oddHoursCharge = 0.0;

    if (settings.oddHoursEnabled) {
      final hours = pickupAt.hour;
      if (hours >= 22 || hours < 5) {
        oddHoursCharge =
            ((subtotal * settings.oddHoursExtraChargePct) / 100).roundToDouble();
      }
    }

    final subtotalWithTime = subtotal + oddHoursCharge;
    final gstAmount =
        ((subtotalWithTime * settings.gstPct) / 100).roundToDouble();
    final totalFare = subtotalWithTime + gstAmount;

    return _FareBreakdown(
      baseFare: packageLabor,
      extraTimeCharge: 0,
      extraHours: 0,
      gstAmount: gstAmount,
      totalFare: totalFare,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class _FareBreakdown {
  final double baseFare;
  final double extraTimeCharge;
  final int extraHours;
  final double gstAmount;
  final double totalFare;

  const _FareBreakdown({
    required this.baseFare,
    required this.extraTimeCharge,
    required this.extraHours,
    required this.gstAmount,
    required this.totalFare,
  });
}

final tripFareServiceProvider = Provider<TripFareService>((ref) {
  return TripFareService();
});
