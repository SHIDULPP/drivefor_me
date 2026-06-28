import 'package:driveforme_user/src/data/models/pricing_settings_model.dart';
import 'package:driveforme_user/src/data/models/trip_price_estimate_model.dart';
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
    final overnightStay = payload['overnightStay'] as Map<String, dynamic>? ??
        const {'required': false};
    final tripProtection = payload['tripProtection'] as Map<String, dynamic>?;

    if (tripType == null || durationValue == null || durationValue < 1) {
      return null;
    }

    final pickupAt = _resolvePickupAt(payload);
    final fare = _calculateTripFare(
      settings: settings,
      tripType: tripType,
      durationValue: durationValue,
      durationUnit: durationUnit,
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
    required Map<String, dynamic> overnightStay,
    required DateTime pickupAt,
  }) {
    final isShort = tripType == 'short_trip';
    var baseFare = 0.0;
    var extraTimeCharge = 0.0;
    var stayAllowanceCharge = 0.0;

    if (isShort) {
      baseFare = settings.shortTripBaseHourlyRate;
      if (durationValue > settings.shortTripBaseDurationHrs) {
        extraTimeCharge =
            (durationValue - settings.shortTripBaseDurationHrs) *
            settings.shortTripAdditionalHourlyRate;
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
        extraTimeCharge =
            (durationValue - 12) * settings.longTripAdditionalHourlyRate;
      }
    }

    final subtotal = baseFare + extraTimeCharge + stayAllowanceCharge;
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
      baseFare: baseFare,
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
  final double gstAmount;
  final double totalFare;

  const _FareBreakdown({
    required this.baseFare,
    required this.gstAmount,
    required this.totalFare,
  });
}

final tripFareServiceProvider = Provider<TripFareService>((ref) {
  return TripFareService();
});
