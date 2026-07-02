class RouteSummary {
  final double distanceKm;
  final int durationMinutes;
  final String durationLabel;

  const RouteSummary({
    required this.distanceKm,
    required this.durationMinutes,
    required this.durationLabel,
  });

  Map<String, dynamic> toJson() => {
        'distanceKm': distanceKm,
        'estimatedDurationMinutes': durationMinutes,
        'estimatedDurationLabel': durationLabel,
      };

  String get distanceLabel => '${distanceKm.toStringAsFixed(1)} km';
}
