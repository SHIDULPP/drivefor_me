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

  RouteSummary doubled() {
    final minutes = durationMinutes * 2;
    return RouteSummary(
      distanceKm: double.parse((distanceKm * 2).toStringAsFixed(1)),
      durationMinutes: minutes,
      durationLabel: formatDuration(minutes),
    );
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) return '$minutes min';
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;
    if (remaining == 0) return hours == 1 ? '1 hr' : '$hours hrs';
    return '$hours hr $remaining min';
  }
}
