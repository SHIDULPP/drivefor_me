import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/models/trip_location_model.dart';
import 'package:driveforme_user/src/data/services/directions_service.dart';
import 'package:driveforme_user/src/data/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum TripMapMode {
  /// Route from driver → pickup (en route to collect vehicle owner).
  toPickup,

  /// Route from driver → dropoff (trip in progress).
  toDropoff,

  /// Route from pickup → dropoff (default / searching for driver).
  fullRoute,
}

class TripMapView extends StatefulWidget {
  final TripLocation? pickup;
  final TripLocation? dropoff;
  final TripLocation? driverLocation;
  final TripMapMode mode;
  final bool showDropoff;
  final bool showRoute;

  const TripMapView({
    super.key,
    this.pickup,
    this.dropoff,
    this.driverLocation,
    this.mode = TripMapMode.fullRoute,
    this.showDropoff = true,
    this.showRoute = false,
  });

  @override
  State<TripMapView> createState() => _TripMapViewState();
}

class _TripMapViewState extends State<TripMapView> {
  static const _locationService = LocationService();
  static const _routeRefreshMinInterval = Duration(seconds: 30);
  static const _routeRefreshMinDistanceMeters = 100.0;

  final DirectionsService _directionsService = DirectionsService();

  GoogleMapController? _mapController;
  TripLocation? _resolvedPickup;
  TripLocation? _resolvedDropoff;
  TripLocation? _resolvedDriver;
  List<LatLng> _routePoints = const [];
  bool _isResolving = true;
  int _resolveGeneration = 0;
  DateTime? _lastRouteFetchAt;
  LatLng? _lastRouteOrigin;

  @override
  void initState() {
    super.initState();
    _resolveMapData(forceRouteRefresh: true);
  }

  @override
  void didUpdateWidget(covariant TripMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final driverChanged = oldWidget.driverLocation != widget.driverLocation;
    final otherChanged = oldWidget.pickup != widget.pickup ||
        oldWidget.dropoff != widget.dropoff ||
        oldWidget.mode != widget.mode ||
        oldWidget.showDropoff != widget.showDropoff ||
        oldWidget.showRoute != widget.showRoute;

    if (otherChanged) {
      _resolveMapData(forceRouteRefresh: true);
      return;
    }

    if (driverChanged) {
      _resolveMapData(
        forceRouteRefresh: _shouldRefreshRoute(widget.driverLocation),
      );
    }
  }

  bool _shouldRefreshRoute(TripLocation? driver) {
    if (!widget.showRoute) return false;
    final now = DateTime.now();
    if (_lastRouteFetchAt == null) return true;
    if (now.difference(_lastRouteFetchAt!) >= _routeRefreshMinInterval) {
      return true;
    }

    final driverPoint = driver?.latLng ?? _resolvedDriver?.latLng;
    final lastOrigin = _lastRouteOrigin;
    if (driverPoint == null || lastOrigin == null) return false;

    final moved = Geolocator.distanceBetween(
      driverPoint.latitude,
      driverPoint.longitude,
      lastOrigin.latitude,
      lastOrigin.longitude,
    );
    return moved >= _routeRefreshMinDistanceMeters;
  }

  Future<void> _resolveMapData({required bool forceRouteRefresh}) async {
    final generation = ++_resolveGeneration;

    if (mounted) {
      setState(() => _isResolving = true);
    }

    final pickup = widget.pickup ?? const TripLocation.empty();
    final dropoff = widget.dropoff;
    final driver = widget.driverLocation;

    final resolvedPickup = await _locationService.resolveLocation(pickup);
    TripLocation? resolvedDropoff;
    if (widget.showDropoff && dropoff != null) {
      resolvedDropoff = await _locationService.resolveLocation(dropoff);
    }

    TripLocation? resolvedDriver;
    if (driver != null) {
      resolvedDriver = await _locationService.resolveLocation(driver);
    }

    var routePoints = _routePoints;
    if (widget.showRoute && forceRouteRefresh) {
      routePoints = await _resolveRoute(
        resolvedPickup: resolvedPickup,
        resolvedDropoff: resolvedDropoff,
        resolvedDriver: resolvedDriver,
      );
      _lastRouteFetchAt = DateTime.now();
      _lastRouteOrigin = switch (widget.mode) {
        TripMapMode.toPickup || TripMapMode.toDropoff =>
          resolvedDriver?.latLng,
        TripMapMode.fullRoute => resolvedPickup.latLng,
      };
    }

    if (!mounted || generation != _resolveGeneration) return;

    setState(() {
      _resolvedPickup = resolvedPickup;
      _resolvedDropoff = resolvedDropoff;
      _resolvedDriver = resolvedDriver;
      if (forceRouteRefresh) {
        _routePoints = routePoints;
      }
      _isResolving = false;
    });

    _fitCamera();
  }

  Future<List<LatLng>> _resolveRoute({
    required TripLocation resolvedPickup,
    required TripLocation? resolvedDropoff,
    required TripLocation? resolvedDriver,
  }) async {
    final driver = resolvedDriver?.latLng;
    final pickup = resolvedPickup.latLng;
    final dropoff = resolvedDropoff?.latLng;

    switch (widget.mode) {
      case TripMapMode.toPickup:
        if (driver != null && pickup != null) {
          return _directionsService.routeBetween(driver, pickup);
        }
        return const [];
      case TripMapMode.toDropoff:
        if (driver != null && dropoff != null) {
          return _directionsService.routeBetween(driver, dropoff);
        }
        if (pickup != null && dropoff != null) {
          return _directionsService.routeBetween(pickup, dropoff);
        }
        return const [];
      case TripMapMode.fullRoute:
        if (pickup != null &&
            dropoff != null &&
            (pickup.latitude != dropoff.latitude ||
                pickup.longitude != dropoff.longitude)) {
          return _directionsService.routeBetween(pickup, dropoff);
        }
        return const [];
    }
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};
    final pickup = _resolvedPickup?.latLng;
    final dropoff = _resolvedDropoff?.latLng;
    final driver = _resolvedDriver?.latLng;

    final showPickup = switch (widget.mode) {
      TripMapMode.toPickup || TripMapMode.fullRoute => true,
      TripMapMode.toDropoff => false,
    };
    final showDropoff = widget.showDropoff &&
        dropoff != null &&
        (pickup == null ||
            pickup.latitude != dropoff.latitude ||
            pickup.longitude != dropoff.longitude);

    if (showPickup && pickup != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickup,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }

    if (showDropoff) {
      markers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: dropoff,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    if (driver != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: driver,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    if (_routePoints.length < 2) return const {};

    return {
      Polyline(
        polylineId: const PolylineId('trip_route'),
        points: _routePoints,
        color: kBrandBlue,
        width: 5,
      ),
    };
  }

  LatLng _initialTarget() {
    return _resolvedDriver?.latLng ??
        _resolvedPickup?.latLng ??
        _resolvedDropoff?.latLng ??
        kDefaultMapCenter;
  }

  /// Points that should frame the camera for the current ride phase.
  List<LatLng> _cameraFocusPoints() {
    final pickup = _resolvedPickup?.latLng;
    final dropoff = _resolvedDropoff?.latLng;
    final driver = _resolvedDriver?.latLng;

    switch (widget.mode) {
      case TripMapMode.toPickup:
        return [
          if (driver != null) driver,
          if (pickup != null) pickup,
        ];
      case TripMapMode.toDropoff:
        return [
          if (driver != null) driver,
          if (dropoff != null) dropoff,
          // Keep pickup in frame only when dropoff is missing.
          if (dropoff == null && pickup != null) pickup,
        ];
      case TripMapMode.fullRoute:
        return [
          if (pickup != null) pickup,
          if (dropoff != null) dropoff,
        ];
    }
  }

  void _fitCamera() {
    if (!mounted || _mapController == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final controller = _mapController;
      if (controller == null) return;

      final points = <LatLng>[
        ..._cameraFocusPoints(),
        ..._routePoints,
      ];

      try {
        if (points.isEmpty) {
          controller.animateCamera(
            CameraUpdate.newLatLngZoom(kDefaultMapCenter, 12),
          );
          return;
        }

        if (points.length == 1) {
          controller.animateCamera(
            CameraUpdate.newLatLngZoom(points.first, 14),
          );
          return;
        }

        var bounds = LatLngBounds(
          southwest: points.first,
          northeast: points.first,
        );
        for (final point in points.skip(1)) {
          bounds = _expandBounds(bounds, point);
        }

        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 56));
      } catch (_) {
        // Map was disposed before the camera animation ran.
      }
    });
  }

  LatLngBounds _expandBounds(LatLngBounds bounds, LatLng point) {
    return LatLngBounds(
      southwest: LatLng(
        point.latitude < bounds.southwest.latitude
            ? point.latitude
            : bounds.southwest.latitude,
        point.longitude < bounds.southwest.longitude
            ? point.longitude
            : bounds.southwest.longitude,
      ),
      northeast: LatLng(
        point.latitude > bounds.northeast.latitude
            ? point.latitude
            : bounds.northeast.latitude,
        point.longitude > bounds.northeast.longitude
            ? point.longitude
            : bounds.northeast.longitude,
      ),
    );
  }

  @override
  void dispose() {
    _resolveGeneration++;
    _mapController = null;
    _directionsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialTarget(),
            zoom: 14,
          ),
          markers: _buildMarkers(),
          polylines: _buildPolylines(),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: false,
          rotateGesturesEnabled: false,
          onMapCreated: (controller) {
            _mapController = controller;
            _fitCamera();
          },
        ),
        if (_isResolving)
          const ColoredBox(
            color: kSearchFieldBg,
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          ),
      ],
    );
  }
}
