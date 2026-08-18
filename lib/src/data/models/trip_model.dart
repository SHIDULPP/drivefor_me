import 'package:intl/intl.dart';

import 'package:driveforme_user/src/data/models/trip_location_model.dart';

class TripModel {
  /// Shown when the backend does not provide a driver / person full name.
  static const String noNameFound = 'No name found';

  static String resolveDriverName(String? name) {
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return noNameFound;
    return trimmed;
  }

  final String id;
  final String tripNumber;
  final String status;
  final String tripDirection;
  final String tripType;
  final String rideTime;
  final TripLocation pickupLocation;
  final TripLocation? dropoffLocation;
  final TripLocation? driverLocation;
  final double? distanceKm;
  final String? estimatedDurationLabel;
  final int durationValue;
  final String durationUnit;
  final DateTime? pickupAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final double? priceMinimum;
  final double? priceMaximum;
  final String currency;
  final String paymentMethod;
  final String? driverName;
  final double? driverRating;
  final int? driverTrips;
  final String? driverPhone;
  final String? driverPhotoUrl;
  final String vehicleName;
  final String vehicleNumber;
  final String vehicleType;
  final String transmission;
  final String? driverId;
  final bool isRated;
  final int? ratingStars;
  final String? ratingComment;
  final List<String> feedbackTags;

  const TripModel({
    required this.id,
    required this.tripNumber,
    required this.status,
    required this.tripDirection,
    required this.tripType,
    required this.rideTime,
    required this.pickupLocation,
    this.dropoffLocation,
    this.driverLocation,
    this.distanceKm,
    this.estimatedDurationLabel,
    required this.durationValue,
    required this.durationUnit,
    this.pickupAt,
    this.startedAt,
    this.completedAt,
    this.cancelledAt,
    this.priceMinimum,
    this.priceMaximum,
    this.currency = 'INR',
    required this.paymentMethod,
    this.driverName,
    this.driverRating,
    this.driverTrips,
    this.driverPhone,
    this.driverPhotoUrl,
    this.vehicleName = '',
    this.vehicleNumber = '',
    this.vehicleType = '',
    this.transmission = '',
    this.driverId,
    this.isRated = false,
    this.ratingStars,
    this.ratingComment,
    this.feedbackTags = const [],
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    final route = json['route'];
    final routeMap = route is Map ? Map<String, dynamic>.from(route) : null;
    final routeSummary = routeMap != null ? _asMap(routeMap['summary']) : null;
    final tripDetails = json['tripDetails'];
    final timeline = json['timeline'];
    final priceEstimate = tripDetails is Map ? tripDetails['priceEstimate'] : null;
    final vehicleDetails = json['vehicleDetails'];
    final driver = _resolveDriver(json);
    final rating = json['rating'];
    final ratingMap = rating is Map ? Map<String, dynamic>.from(rating) : null;

    return TripModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      tripNumber: json['tripNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      tripDirection: tripDetails is Map
          ? tripDetails['tripDirection']?.toString() ?? 'one_way'
          : 'one_way',
      tripType: tripDetails is Map
          ? tripDetails['tripType']?.toString() ?? 'short_trip'
          : 'short_trip',
      rideTime: tripDetails is Map
          ? tripDetails['rideTime']?.toString() ?? 'now'
          : 'now',
      pickupLocation: routeMap != null
          ? TripLocation.fromDynamic(routeMap['pickupLocation'])
          : const TripLocation.empty(),
      dropoffLocation: routeMap != null
          ? _optionalLocation(routeMap['dropoffLocation'])
          : null,
      driverLocation: _resolveDriverLocation(json, routeMap),
      distanceKm: _toDouble(routeSummary?['distanceKm']),
      estimatedDurationLabel:
          routeSummary?['estimatedDurationLabel']?.toString(),
      durationValue: tripDetails is Map
          ? (tripDetails['durationValue'] as num?)?.toInt() ?? 1
          : 1,
      durationUnit: tripDetails is Map
          ? tripDetails['durationUnit']?.toString() ?? 'hours'
          : 'hours',
      pickupAt: tripDetails is Map ? _parseDate(tripDetails['pickupAt']) : null,
      startedAt: timeline is Map ? _parseDate(timeline['startedAt']) : null,
      completedAt: timeline is Map ? _parseDate(timeline['completedAt']) : null,
      cancelledAt: timeline is Map ? _parseDate(timeline['cancelledAt']) : null,
      priceMinimum: priceEstimate is Map
          ? _toDouble(priceEstimate['minimum'])
          : null,
      priceMaximum: priceEstimate is Map
          ? _toDouble(priceEstimate['maximum'])
          : null,
      currency: priceEstimate is Map
          ? priceEstimate['currency']?.toString() ?? 'INR'
          : 'INR',
      paymentMethod: json['paymentMethod']?.toString() ?? 'cash',
      driverName: _userName(driver),
      driverRating: _userRating(driver),
      driverTrips: _userTotalTrips(driver),
      driverPhone: _userPhone(driver),
      driverPhotoUrl: _driverPhotoUrl(driver),
      vehicleName: vehicleDetails is Map
          ? vehicleDetails['vehicleName']?.toString() ?? ''
          : '',
      vehicleNumber: vehicleDetails is Map
          ? vehicleDetails['vehicleNumber']?.toString() ?? ''
          : '',
      vehicleType: vehicleDetails is Map
          ? vehicleDetails['vehicleType']?.toString() ?? ''
          : '',
      transmission: vehicleDetails is Map
          ? vehicleDetails['transmission']?.toString() ?? ''
          : '',
      driverId: _driverId(driver),
      isRated: json['isRated'] == true ||
          ratingMap?['stars'] != null ||
          json['ratedAt'] != null,
      ratingStars: ratingMap?['stars'] is num
          ? (ratingMap!['stars'] as num).toInt()
          : null,
      ratingComment: ratingMap?['comment']?.toString(),
      feedbackTags: ratingMap?['feedbackTags'] is List
          ? (ratingMap!['feedbackTags'] as List)
              .map((e) => e.toString())
              .toList()
          : const [],
    );
  }

  bool get isLongTrip => tripType == 'long_trip';
  bool get isOneWay => tripDirection == 'one_way';

  String get pickupAddress => pickupLocation.address;

  String? get dropoffAddress {
    final address = dropoffLocation?.address ?? '';
    return address.isEmpty ? null : address;
  }

  bool get hasDriver =>
      driverId != null && driverId!.isNotEmpty && hasDriverName;

  bool get hasDriverName => driverName != null && driverName!.isNotEmpty;

  String get displayDriverName => resolveDriverName(driverName);

  bool get isDriverAssigned =>
      status == 'driver_assigned' && driverId != null && driverId!.isNotEmpty;

  bool get isInProgress => status == 'in_progress';

  bool get isCompleted => status == 'completed';

  bool get isCancelled => status == 'cancelled';

  bool get isWalletPayment => paymentMethod == 'wallet';

  String get displayTripId =>
      tripNumber.isNotEmpty ? '# $tripNumber' : '# ${id.substring(0, 8)}';

  String get tripTitle => isOneWay ? 'One Way Trip' : 'Round Trip';

  String get directionChipLabel => isOneWay ? 'One Way' : 'Round Trip';

  String get tripTypeChipLabel => isLongTrip ? 'LONG TRIP' : 'SHORT TRIP';

  String get displayPrice {
    final amount = priceMinimum ?? priceMaximum;
    if (amount == null) return '—';
    return '₹ ${amount.toStringAsFixed(0)}';
  }

  String get vehicleTypesLabel {
    if (vehicleName.isNotEmpty && vehicleNumber.isNotEmpty) {
      return '$vehicleName • $vehicleNumber';
    }
    if (vehicleName.isNotEmpty) return vehicleName;
    if (vehicleNumber.isNotEmpty) return vehicleNumber;

    final type = _titleCase(vehicleType);
    final trans = _titleCase(transmission);
    if (type.isEmpty && trans.isEmpty) return '—';
    if (type.isEmpty) return trans;
    if (trans.isEmpty) return type;
    return '$trans + $type';
  }

  String get driverFoundSubtitle {
    if (pickupAt != null && rideTime != 'now') {
      return 'Pickup ${formatScheduleLine(pickupAt)}';
    }
    return 'Share the OTP below with your driver to start the trip';
  }

  String get durationLabel {
    if (estimatedDurationLabel != null && estimatedDurationLabel!.isNotEmpty) {
      return estimatedDurationLabel!;
    }
    if (durationUnit == 'days') {
      return durationValue == 1 ? '1 day' : '$durationValue days';
    }
    return durationValue == 1 ? '1 hr' : '$durationValue hrs';
  }

  String get distanceLabel {
    if (distanceKm == null) return '';
    final value = distanceKm!;
    final formatted = value % 1 == 0
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);
    return '$formatted km';
  }

  String get metaRest {
    final parts = <String>[durationLabel];
    if (distanceLabel.isNotEmpty) parts.add(distanceLabel);
    return ' • ${parts.join(' • ')}';
  }

  String formatMetaPrimary(DateTime? date) {
    if (date == null) return '—';
    if (isLongTrip && durationUnit == 'days' && durationValue > 1) {
      final end = date.add(Duration(days: durationValue - 1));
      return '${DateFormat('d MMMM').format(date)} to ${DateFormat('d MMMM').format(end)}';
    }
    return DateFormat('d MMMM').format(date);
  }

  String formatScheduleLine(DateTime? date) {
    if (date == null) return metaRest.trim();
    final dayLabel = _relativeDayLabel(date);
    final time = DateFormat('hh:mm a').format(date);
    return '$dayLabel, $time$metaRest';
  }

  String upcomingStatusLabel() {
    switch (status) {
      case 'scheduled':
        return 'Scheduled';
      case 'driver_assigned':
        return 'Driver Assigned';
      case 'pending_assignment':
        return 'Pending';
      default:
        return 'Upcoming';
    }
  }

  DateTime? get referenceDate {
    switch (status) {
      case 'completed':
        return completedAt ?? pickupAt;
      case 'cancelled':
        return cancelledAt ?? pickupAt;
      case 'in_progress':
        return startedAt ?? pickupAt;
      default:
        return pickupAt ?? startedAt;
    }
  }

  String get paymentTypeKey =>
      paymentMethod == 'pay_online' || paymentMethod == 'upi' ? 'online' : 'offline';

  String get paymentTypeLabel =>
      paymentTypeKey == 'online' ? 'Online(Prepaid)' : 'Cash';

  Map<String, dynamic> toDriverFoundArguments() {
    return {
      'tripMongoId': id,
      'tripTitle': tripTitle,
      'tripId': displayTripId,
      'pickup': pickupAddress,
      'dropoff': dropoffAddress ?? pickupAddress,
      'price': displayPrice,
      'distance': distanceLabel.isEmpty ? '—' : distanceLabel,
      'duration': durationLabel,
      'driverId': driverId ?? '',
      'driverName': displayDriverName,
      'driverPhone': driverPhone ?? '',
      'driverPhotoUrl': driverPhotoUrl ?? '',
      'driverRating': driverRating ?? 5.0,
      'driverTrips': driverTrips ?? 0,
      'vehicleName': vehicleName,
      'vehicleNumber': vehicleNumber,
      'vehicleTypes': vehicleTypesLabel,
      'paymentType': paymentTypeKey,
    };
  }

  Map<String, dynamic> toProgressArguments() {
    return {
      'tripMongoId': id,
      'tripTitle': tripTitle,
      'tripId': displayTripId,
      'headingTo': dropoffAddress ?? pickupAddress,
      'pickup': pickupAddress,
      'dropoff': dropoffAddress ?? pickupAddress,
      'driverId': driverId ?? '',
      'driverName': displayDriverName,
      'driverPhone': driverPhone ?? '',
      'driverPhotoUrl': driverPhotoUrl ?? '',
      'driverRating': driverRating ?? 5.0,
      'driverTrips': driverTrips ?? 0,
      'vehicleName': vehicleName,
      'vehicleNumber': vehicleNumber,
      'vehicleTypes': vehicleTypesLabel,
      'price': displayPrice,
      'distance': distanceLabel.isEmpty ? '—' : distanceLabel,
      'duration': durationLabel,
      'paymentType': paymentTypeKey,
      'paymentMethod': paymentMethod,
    };
  }

  Map<String, dynamic> toTripCompletedArguments() {
    return {
      'tripMongoId': id,
      'paymentType': paymentTypeKey,
      'paymentMethod': paymentMethod,
      'tripTypeLabel': isLongTrip ? 'Long Trip' : 'Short Trip',
      'destinationName': dropoffAddress ?? pickupAddress,
      'destinationAddress': dropoffAddress ?? pickupAddress,
      'totalFare': displayPrice,
      'prepaidAmount': displayPrice,
      'prepaidDuration': durationLabel,
      'tripFare': displayPrice,
      'tripDuration': durationLabel,
      'extraTimeAmount': '—',
      'extraTimeDuration': '—',
      'remainingDue': displayPrice,
      'remainingDuration': '—',
      'totalAmount': displayPrice,
      'driverId': driverId ?? '',
      'driverName': displayDriverName,
      'driverPhone': driverPhone ?? '',
      'driverPhotoUrl': driverPhotoUrl ?? '',
      'driverRating': driverRating ?? 5.0,
      'driverTrips': driverTrips ?? 0,
      'vehicleName': vehicleName,
      'vehicleNumber': vehicleNumber,
      'vehicleTypes': vehicleTypesLabel,
      'isRated': isRated,
    };
  }

  Map<String, dynamic> toRatingArguments() {
    return {
      'tripMongoId': id,
      'driverId': driverId ?? '',
      'driverName': displayDriverName,
      'driverPhone': driverPhone ?? '',
      'driverPhotoUrl': driverPhotoUrl ?? '',
      'driverRating': driverRating ?? 5.0,
      'driverTrips': driverTrips ?? 0,
      'vehicleName': vehicleName,
      'vehicleNumber': vehicleNumber,
      'vehicleTypes': vehicleTypesLabel,
    };
  }

  Map<String, dynamic> toWaitingDriverArguments() {
    return {
      'tripMongoId': id,
      'tripTitle': tripTitle,
      'tripId': displayTripId,
      'paymentType': paymentTypeKey,
      'pickup': pickupAddress,
      'dropoff': dropoffAddress ?? pickupAddress,
      'price': displayPrice,
      'distance': distanceLabel.isEmpty ? '—' : distanceLabel,
      'duration': durationLabel,
    };
  }

  Map<String, dynamic> toScheduledDetailsArguments() {
    return {
      'tripMongoId': id,
      'tripTitle': tripTitle,
      'tripId': displayTripId,
      'scheduledAt': pickupAt ?? DateTime.now(),
      'pickup': pickupAddress,
      'dropoff': dropoffAddress ?? pickupAddress,
      'distance': distanceLabel.isEmpty ? '—' : distanceLabel,
      'duration': durationLabel,
      'vehicleType': _titleCase(vehicleType),
      'tripFare': displayPrice,
      'paymentTypeLabel': paymentTypeLabel,
      'paymentType': paymentTypeKey,
      'hasDriver': hasDriver,
      'isLongTrip': isLongTrip,
      if (hasDriver) ...{
        'driverName': displayDriverName,
        'driverRating': driverRating ?? 5.0,
        'driverTrips': driverTrips ?? 0,
        'driverPhotoUrl': driverPhotoUrl ?? '',
      },
      'vehicleTypes': vehicleTypesLabel,
    };
  }

  Map<String, dynamic> toCompletedDetailsArguments() {
    return {
      'tripTitle': tripTitle,
      'tripId': displayTripId,
      'tripMongoId': id,
      'isLongTrip': isLongTrip,
      'pickup': pickupAddress,
      'dropoff': dropoffAddress ?? pickupAddress,
      'metaLine':
          '${formatMetaPrimary(referenceDate)}$metaRest',
      'tripFare': displayPrice,
      'tripFareDurationLabel': durationLabel,
      'extraTimeFare': '—',
      'extraTimeDurationLabel': '—',
      'totalPaid': displayPrice,
      'driverName': displayDriverName,
      'driverRating': driverRating ?? 5.0,
      'driverTrips': driverTrips ?? 0,
      'driverPhotoUrl': driverPhotoUrl ?? '',
      'vehicleTypes': vehicleTypesLabel,
    };
  }

  Map<String, dynamic> toCancelledDetailsArguments() {
    return {
      'tripTitle': tripTitle,
      'tripId': displayTripId,
      'tripMongoId': id,
      'isLongTrip': isLongTrip,
      'pickup': pickupAddress,
      'dropoff': dropoffAddress ?? pickupAddress,
      'metaLine':
          '${formatMetaPrimary(referenceDate)}$metaRest',
      'amountPaid': displayPrice,
      'refundAmount': '—',
      'refundInitiatedAt': cancelledAt != null
          ? DateFormat('d MMMM yyyy, hh:mm a').format(cancelledAt!)
          : '—',
      'driverName': displayDriverName,
      'driverRating': driverRating ?? 5.0,
      'driverTrips': driverTrips ?? 0,
      'driverPhotoUrl': driverPhotoUrl ?? '',
      'vehicleTypes': vehicleTypesLabel,
      'hasDriver': hasDriver,
    };
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static dynamic _resolveDriver(Map<String, dynamic> json) {
    final topLevel = json['driver'];
    if (topLevel is Map && topLevel.isNotEmpty) return topLevel;

    final assignment = json['driverAssignment'];
    if (assignment is Map) return assignment['assignedDriver'];
    return null;
  }

  static TripLocation? _optionalLocation(dynamic location) {
    final parsed = TripLocation.fromDynamic(location);
    if (!parsed.hasAddress && !parsed.hasCoordinates) return null;
    return parsed;
  }

  static TripLocation? _resolveDriverLocation(
    Map<String, dynamic> json,
    Map<String, dynamic>? routeMap,
  ) {
    final candidates = <dynamic>[
      json['driverLocation'],
      routeMap?['driverLocation'],
      routeMap?['liveDriverLocation'],
    ];

    final driver = _resolveDriver(json);
    if (driver is Map) {
      candidates.addAll([
        driver['currentLocation'],
        driver['location'],
        driver['liveLocation'],
      ]);
    }

    final assignment = json['driverAssignment'];
    if (assignment is Map) {
      candidates.addAll([
        assignment['currentLocation'],
        assignment['driverLocation'],
        assignment['liveLocation'],
      ]);
    }

    for (final candidate in candidates) {
      final location = TripLocation.fromDynamic(candidate);
      if (location.hasCoordinates) return location;
    }

    return null;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toLocal();
    return DateTime.tryParse(value.toString())?.toLocal();
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static String? _driverId(dynamic user) {
    if (user is Map) {
      final id = user['_id'] ?? user['id'];
      if (id != null) return id.toString();
    }
    return null;
  }

  static String? _userName(dynamic user) {
    if (user is Map) {
      final profile = user['profile'];
      if (profile is Map && profile['fullName'] != null) {
        final name = profile['fullName'].toString().trim();
        if (name.isNotEmpty) return name;
      }
    }
    return null;
  }

  static double? _userRating(dynamic user) {
    if (user is Map && user['rating'] != null) {
      return (user['rating'] as num).toDouble();
    }
    return null;
  }

  static int? _userTotalTrips(dynamic user) {
    if (user is Map && user['totalTrips'] != null) {
      return (user['totalTrips'] as num).toInt();
    }
    return null;
  }

  static String? _userPhone(dynamic user) {
    if (user is Map) {
      final phone = user['phoneNumber']?.toString().trim();
      if (phone != null && phone.isNotEmpty) return phone;
    }
    return null;
  }

  static String? _driverPhotoUrl(dynamic user) {
    if (user is! Map) return null;

    final candidates = <dynamic>[
      if (user['driverVerification'] is Map)
        (user['driverVerification'] as Map)['livePhotoUrl'],
      if (user['profile'] is Map) (user['profile'] as Map)['livePhotoUrl'],
      if (user['profile'] is Map) (user['profile'] as Map)['avatarUrl'],
      user['livePhotoUrl'],
      user['photoUrl'],
      user['avatar'],
      user['avatarUrl'],
      user['profilePhotoUrl'],
    ];

    for (final candidate in candidates) {
      final url = candidate?.toString().trim();
      if (url != null && url.isNotEmpty) return url;
    }
    return null;
  }

  static String _titleCase(String value) {
    if (value.isEmpty) return value;
    return value
        .split('_')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part[0].toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
  }

  static String _relativeDayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    return DateFormat('EEE, dd MMM').format(date);
  }
}
