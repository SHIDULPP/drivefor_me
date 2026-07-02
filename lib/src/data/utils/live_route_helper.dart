import 'package:driveforme_user/src/data/models/route_summary_model.dart';
import 'package:driveforme_user/src/data/models/trip_location_model.dart';
import 'package:driveforme_user/src/data/services/directions_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveRouteHelper {
  LiveRouteHelper({DirectionsService? directionsService})
      : _directionsService = directionsService ?? DirectionsService();

  static const _refreshMinInterval = Duration(seconds: 30);
  static const _refreshMinDistanceMeters = 100.0;

  final DirectionsService _directionsService;
  DateTime? _lastFetchAt;
  double? _lastOriginLat;
  double? _lastOriginLng;
  RouteSummary? _cachedSummary;

  RouteSummary? get cachedSummary => _cachedSummary;

  Future<RouteSummary?> fetchIfNeeded({
    required TripLocation? origin,
    required TripLocation? destination,
  }) async {
    if (origin == null || destination == null) return _cachedSummary;
    if (!origin.hasCoordinates && !origin.hasAddress) return _cachedSummary;
    if (!destination.hasCoordinates && !destination.hasAddress) {
      return _cachedSummary;
    }

    final originPoint = origin.latLng;
    if (originPoint != null && !_shouldRefresh(originPoint)) {
      return _cachedSummary;
    }

    final summary = await _directionsService.routeSummaryBetween(
      origin: origin,
      destination: destination,
    );

    if (summary != null) {
      _cachedSummary = summary;
      _lastFetchAt = DateTime.now();
      final resolvedOrigin = origin.latLng;
      if (resolvedOrigin != null) {
        _lastOriginLat = resolvedOrigin.latitude;
        _lastOriginLng = resolvedOrigin.longitude;
      }
    }

    return summary ?? _cachedSummary;
  }

  bool _shouldRefresh(LatLng origin) {
    if (_lastFetchAt == null) return true;
    if (DateTime.now().difference(_lastFetchAt!) >= _refreshMinInterval) {
      return true;
    }
    if (_lastOriginLat == null || _lastOriginLng == null) return true;

    final moved = Geolocator.distanceBetween(
      origin.latitude,
      origin.longitude,
      _lastOriginLat!,
      _lastOriginLng!,
    );
    return moved >= _refreshMinDistanceMeters;
  }

  void dispose() => _directionsService.dispose();
}
