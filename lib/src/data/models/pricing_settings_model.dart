class PricingSettingsModel {
  final double shortTripBaseDurationHrs;
  final double shortTripBaseHourlyRate;
  final double shortTripAdditionalHourlyRate;
  final double longTripPerDayRate;
  final double longTripAdditionalHourlyRate;
  final double longTripStayAllowance;
  final bool oddHoursEnabled;
  final double oddHoursExtraChargePct;
  final double gstPct;

  const PricingSettingsModel({
    required this.shortTripBaseDurationHrs,
    required this.shortTripBaseHourlyRate,
    required this.shortTripAdditionalHourlyRate,
    required this.longTripPerDayRate,
    required this.longTripAdditionalHourlyRate,
    required this.longTripStayAllowance,
    required this.oddHoursEnabled,
    required this.oddHoursExtraChargePct,
    required this.gstPct,
  });

  factory PricingSettingsModel.fromJson(Map<String, dynamic> json) {
    final rules = _asMap(json['pricingRules']) ?? json;
    final shortTrip = _asMap(rules['shortTrip']) ?? const {};
    final longTrip = _asMap(rules['longTrip']) ?? const {};
    final timeBased = _asMap(rules['timeBasedCharges']) ?? const {};
    final taxAndFee = _asMap(rules['taxAndFee']) ?? const {};

    return PricingSettingsModel(
      shortTripBaseDurationHrs:
          _toDouble(shortTrip['baseDurationHrs']) ?? 4,
      shortTripBaseHourlyRate: _toDouble(shortTrip['baseHourlyRate']) ?? 500,
      shortTripAdditionalHourlyRate:
          _toDouble(shortTrip['additionalHourlyRate']) ?? 150,
      longTripPerDayRate: _toDouble(longTrip['perDayRate']) ?? 1500,
      longTripAdditionalHourlyRate:
          _toDouble(longTrip['additionalHourlyRate']) ?? 150,
      longTripStayAllowance: _toDouble(longTrip['stayAllowance']) ?? 150,
      oddHoursEnabled: timeBased['oddHoursEnabled'] != false,
      oddHoursExtraChargePct: _toDouble(timeBased['extraChargePct']) ?? 25,
      gstPct: _toDouble(taxAndFee['gstPct']) ?? 18,
    );
  }

  static const defaults = PricingSettingsModel(
    shortTripBaseDurationHrs: 4,
    shortTripBaseHourlyRate: 500,
    shortTripAdditionalHourlyRate: 150,
    longTripPerDayRate: 1500,
    longTripAdditionalHourlyRate: 150,
    longTripStayAllowance: 150,
    oddHoursEnabled: true,
    oddHoursExtraChargePct: 25,
    gstPct: 18,
  );

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
