import 'dart:async';
import 'dart:developer';

import 'package:driveforme_user/src/data/models/trip_model.dart';
import 'package:driveforme_user/src/data/models/trip_price_estimate_model.dart';
import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/apis/onboarding_api.dart';
import 'package:driveforme_user/src/data/apis/trip_api.dart';
import 'package:driveforme_user/src/data/apis/vehicle_api.dart';
import 'package:driveforme_user/src/data/models/api_response.dart';
import 'package:driveforme_user/src/data/models/vehicle_model.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:driveforme_user/src/interfaces/components/add_vehicle_sheet.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:driveforme_user/src/interfaces/components/schedule_sheet.dart';
import 'package:driveforme_user/src/interfaces/components/select_rider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateTripPage extends ConsumerStatefulWidget {
  const CreateTripPage({super.key});

  @override
  ConsumerState<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends ConsumerState<CreateTripPage> {
  int selectedHour = 1;
  int selectedNight = 1;
  int customDays = 1;
  int customHours = 1;
  int customNights = 3;
  bool? isOvernightStay;

  bool isTripProtectionEnabled = true;

  bool isOneWay = true;

  bool isShortTrip = true;
  bool isRideNow = true;
  DateTime? scheduledRideAt;
  int? selectedPaymentIndex;
  bool _isSubmitting = false;
  String _pickupAddress = 'Edappally, Lulu mall';
  String? _dropoffAddress;
  List<VehicleModel> _vehicles = [];
  VehicleModel? _selectedVehicle;
  bool _isLoadingVehicles = true;
  TripPriceEstimateModel? _priceEstimate;
  bool _isLoadingEstimate = false;
  Timer? _estimateDebounce;

  static const _tripProtectionFee = 19;
  static const _estimateDebounceDuration = Duration(milliseconds: 350);

  static final _scheduleDisplayFormat = DateFormat('EEE, dd MMM • hh:mm a');
  static final _apiDateFormat = DateFormat('yyyy-MM-dd');
  static final _apiTimeFormat = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadVehicles();
      _schedulePriceEstimate();
    });
  }

  @override
  void dispose() {
    _estimateDebounce?.cancel();
    super.dispose();
  }

  void _mutateTripForm(VoidCallback fn) {
    setState(fn);
    _schedulePriceEstimate();
  }

  void _schedulePriceEstimate() {
    _estimateDebounce?.cancel();
    _estimateDebounce = Timer(_estimateDebounceDuration, _fetchPriceEstimate);
  }

  Future<void> _fetchPriceEstimate() async {
    final duration = _resolveDuration();
    if (!duration.success || duration.data == null) {
      if (!mounted) return;
      setState(() {
        _isLoadingEstimate = false;
        _priceEstimate = null;
      });
      return;
    }

    final overnight = _resolveOvernightStay(duration.data!);
    if (!overnight.success || overnight.data == null) {
      if (!mounted) return;
      setState(() {
        _isLoadingEstimate = false;
        _priceEstimate = null;
      });
      return;
    }

    if (!mounted) return;
    setState(() => _isLoadingEstimate = true);

    final response = await ref.read(tripApiProvider).estimateTripPrice({
      'tripType': isShortTrip ? 'short_trip' : 'long_trip',
      'durationValue': duration.data!['durationValue'],
      'durationUnit': duration.data!['durationUnit'],
      'tripProtection': {
        'enabled': isTripProtectionEnabled,
        'fee': isTripProtectionEnabled ? _tripProtectionFee : 0,
      },
      'overnightStay': overnight.data,
      'rideTime': isRideNow ? 'now' : 'scheduled',
      if (!isRideNow && scheduledRideAt != null)
        'pickupTime': _apiTimeFormat.format(scheduledRideAt!),
    });

    if (!mounted) return;
    setState(() {
      _isLoadingEstimate = false;
      _priceEstimate =
          response.success && response.data != null ? response.data : null;
    });
  }

  String get _durationPriceLabel {
    if (_isLoadingEstimate) return '...';
    return _priceEstimate?.displayAmount ?? '—';
  }

  String get _selectedPaymentTotalLabel {
    if (_isLoadingEstimate) return '...';
    if (_priceEstimate == null) return '—';
    return _priceEstimate!.totalForPaymentMethod(
      selectedPaymentIndex == 1 ? 'pay_online' : 'cash',
    );
  }

  String get _onlinePaymentTotalLabel {
    if (_isLoadingEstimate) return '...';
    return _priceEstimate?.totalForPaymentMethod('pay_online') ?? '—';
  }

  String get _durationUsageLabel {
    if (!isShortTrip && selectedHour == -1) {
      return '$customDays Day • $customHours Hour';
    }
    return '${isShortTrip ? selectedHour : selectedHour} hrs';
  }

  Future<void> _loadVehicles({VehicleModel? selectVehicle}) async {
    final response = await ref.read(vehicleApiProvider).getMyVehicles();
    if (!mounted) return;

    if (!response.success || response.data == null) {
      setState(() => _isLoadingVehicles = false);
      return;
    }

    final vehicles = response.data!;
    setState(() {
      _vehicles = vehicles;
      _isLoadingVehicles = false;

      if (selectVehicle != null) {
        _selectedVehicle = vehicles.firstWhere(
          (vehicle) => vehicle.id == selectVehicle.id,
          orElse: () => selectVehicle,
        );
        return;
      }

      if (_selectedVehicle != null &&
          vehicles.any((vehicle) => vehicle.id == _selectedVehicle!.id)) {
        return;
      }

      _selectedVehicle = vehicles.isNotEmpty ? vehicles.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScreenBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// ================= HEADER =================
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: const BoxDecoration(
                        color: kWhite,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, size: 24),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: Text('Where to go?', style: kTripPageTitleSB),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: kTripCreamBg,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: GestureDetector(
                      onTap: () => showSelectRiderBottomSheet(context),
                      child: Row(
                        children: [
                          Text('For: My Self', style: kTripForPillM),
                          SizedBox(width: 10),
                          Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// ================= LOCATION CARD =================
              _buildLocationCard(),

              const SizedBox(height: 18),

              /// ================= VEHICLE CARD =================
              _buildVehicleCard(),

              const SizedBox(height: 18),

              /// ================= RIDE TIME =================
              _buildRideTimeCard(),

              const SizedBox(height: 18),

              /// ================= TRIP DETAILS =================
              _buildTripDetailsCard(),

              const SizedBox(height: 18),

              /// ================= TRIP PROTECTION =================
              _buildProtectionCard(),

              const SizedBox(height: 18),

              /// ================= PAYMENT =================
              _buildPaymentCard(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: selectedPaymentIndex == null
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: const BoxDecoration(
                color: kWhite,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total', style: kTripTotalLabelR),
                        Text(
                          _selectedPaymentTotalLabel,
                          style: kTripTotalPriceB,
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: primaryButton(
                        label: _isSubmitting
                            ? 'Creating trip...'
                            : selectedPaymentIndex == 1
                            ? 'Pay Online & find driver'
                            : 'Confirm Cash on Pay',
                        onPressed: _isSubmitting
                            ? null
                            : () => _submitTripCreation(),
                        buttonHeight: 64,
                        fontSize: 18,
                        buttonColor: kTripCtaBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// ============================================================
  /// LOCATION CARD
  /// ============================================================

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          /// top switch
          Container(
            height: 68,
            decoration: BoxDecoration(
              color: kTripCreamBg,
              borderRadius: BorderRadius.circular(34),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isOneWay = true;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isOneWay ? kTripGold : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_right_alt,
                            color: isOneWay ? kWhite : kTextColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'One Way',
                            style: isOneWay
                                ? kTripSegmentActiveM
                                : kTripSegmentInactiveM,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isOneWay = false;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: !isOneWay ? kTripGold : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sync_alt,
                            color: !isOneWay ? kWhite : kTextColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Round Trip',
                            style: !isOneWay
                                ? kTripSegmentActiveM
                                : kTripSegmentInactiveM,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// left icons
              Column(
                children: [
                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: kActiveGreen,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.star, size: 18, color: kWhite),
                  ),

                  Container(width: 2, height: 60, color: kLineGrey),

                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: kTripDestIconBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.star,
                      size: 18,
                      color: kTripIconMuted,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  children: [
                    /// from
                    GestureDetector(
                      onTap: _pickPickupLocation,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('From', style: kTripLocationLabelR),
                                const SizedBox(height: 4),
                                Text(
                                  _pickupAddress,
                                  style: kTripLocationValueM,
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: kTripCreamBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 24),
                                const SizedBox(width: 10),
                                Text('Now', style: kTripTimePillM),
                                SizedBox(width: 6),
                                Icon(Icons.keyboard_arrow_down),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Divider(color: Colors.grey.shade300),

                    GestureDetector(
                      onTap: _pickDropoffLocation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('To', style: kTripLocationLabelR),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _dropoffAddress ?? 'Enter destination',
                            style: kTripLocationValueM.copyWith(
                              color: _dropoffAddress == null
                                  ? kTripMutedLabel
                                  : kTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade300),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ============================================================
  /// VEHICLE CARD
  /// ============================================================

  Widget _buildVehicleCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Choose your Vehicle', style: kTripSectionTitleSB),
              ),
              GestureDetector(
                onTap: _openAddVehicleSheet,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Change', style: kTripChipCustomM),
                    Icon(Icons.chevron_right, size: 20, color: kBrandBlue),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_isLoadingVehicles)
            const SizedBox(
              height: 168,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_vehicles.isEmpty)
            GestureDetector(
              onTap: _openAddVehicleSheet,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: kTripBorder),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, size: 28, color: kTripIconMuted),
                    const SizedBox(height: 8),
                    Text('Add your vehicle', style: kTripVehicleAddM),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 168,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _vehicles.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final vehicle = _vehicles[index];
                  final isSelected = _selectedVehicle?.id == vehicle.id;
                  return _buildVehicleOptionCard(
                    vehicle: vehicle,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedVehicle = vehicle);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVehicleOptionCard({
    required VehicleModel vehicle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 132,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kTripGold : kTripBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/pngs/car_image.png',
              height: 52,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              _vehicleTypeLabel(vehicle.vehicleType),
              style: kStyle(kSemiBold, kSize14, color: kTextColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              vehicle.vehicleNumber,
              style: kTripDurationPriceB.copyWith(fontSize: kSize13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              _vehicleSeaterLabel(vehicle.vehicleType),
              style: kTripDurationMetaR,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _vehicleTypeLabel(String vehicleType) {
    if (vehicleType.trim().isEmpty) return 'Vehicle';
    return vehicleType
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String _vehicleSeaterLabel(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'suv':
        return '6 Seater';
      case 'premium':
        return '4 Seater';
      default:
        return '4 Seater';
    }
  }

  /// ============================================================
  /// RIDE TIME
  /// ============================================================

  static const _rideScheduleBg = Color(0xFFDDE6F0);

  Widget _buildRideTimeCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: kTripCtaBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  color: kWhite,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ride Time', style: kTripSubSectionSB),
                    const SizedBox(height: 4),
                    Text(
                      'Book a ride now or schedule for later',
                      style: kTripProtectionDescR,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _rideTimeOption(
                  label: 'Now',
                  selected: isRideNow,
                  onTap: () => _mutateTripForm(() {
                    isRideNow = true;
                    scheduledRideAt = null;
                  }),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _rideTimeOption(
                  label: 'Schedule',
                  selected: !isRideNow,
                  onTap: _onScheduleTap,
                ),
              ),
            ],
          ),
          if (!isRideNow && scheduledRideAt != null) ...[
            const SizedBox(height: 12),
            Text(
              'Scheduled: ${_scheduleDisplayFormat.format(scheduledRideAt!)}',
              style: kStyle(kMedium, kSize13, color: kBrandBlue),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openScheduleSheet({bool openOnScheduleTab = false}) async {
    final result = await showScheduleBottomSheet(
      context,
      initialDateTime: scheduledRideAt,
      initialIsNow: openOnScheduleTab ? false : isRideNow,
    );

    if (!mounted) return;

    if (result == null) {
      if (openOnScheduleTab) {
        _mutateTripForm(() => isRideNow = scheduledRideAt == null);
      }
      return;
    }

    _mutateTripForm(() {
      isRideNow = result.isNow;
      scheduledRideAt = result.scheduledAt;
    });
  }

  Future<void> _onScheduleTap() async {
    _mutateTripForm(() => isRideNow = false);
    await _openScheduleSheet(openOnScheduleTab: true);
  }

  Widget _rideTimeOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? kTripCtaBlue : _rideScheduleBg,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Text(
          label,
          style: kStyle(
            kSemiBold,
            kSize16,
            color: selected ? kWhite : kTripCtaBlue,
          ),
        ),
      ),
    );
  }

  /// ============================================================
  /// TRIP DETAILS
  /// ============================================================

  Widget _buildTripDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trip Details', style: kTripSectionTitleSB),

          const SizedBox(height: 28),

          Text('Trip type', style: kTripSubSectionSB),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _tripTypeButton(
                  title: 'Short Trip',
                  selected: isShortTrip,
                  onTap: () {
                    _mutateTripForm(() {
                      isShortTrip = true;
                      if (selectedHour > 7 || selectedHour == -1) {
                        selectedHour = 1;
                      }
                    });
                  },
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: _tripTypeButton(
                  title: 'Long Trip',
                  selected: !isShortTrip,
                  onTap: () {
                    _mutateTripForm(() {
                      isShortTrip = false;
                      if (selectedHour < 9 && selectedHour != -1) {
                        selectedHour = 9;
                      }
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Text('Trip Duration', style: kTripSubSectionSB),

          const SizedBox(height: 12),

          RichText(
            text: TextSpan(
              style: kTripDurationMetaR.copyWith(color: kTextColor),
              children: [
                TextSpan(text: '$_durationPriceLabel ', style: kTripDurationPriceB),
                TextSpan(
                  text: 'Based on $_durationUsageLabel usage',
                  style: kTripDurationMetaR,
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (!isShortTrip && selectedHour == -1) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: _showCustomDurationBottomSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: kTripGold),
                          color: kTripSelectedTint,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$customDays Day • $customHours Hour',
                              style: kTripChipDurationSB,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: _showCustomDurationBottomSheet,
                      child: Container(
                        width: 74,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: kTripBorder),
                          color: kWhite,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 24,
                              width: 24,
                              decoration: const BoxDecoration(
                                color: kTripCreamBg,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 16,
                                color: kTripIconMuted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text('Custom', style: kTripChipCustomM),
                          ],
                        ),
                      ),
                    );
                  }
                }

                final isCustomOption = !isShortTrip && index == 6;
                final hour = isShortTrip ? (index + 1) : (index + 9);

                if (isCustomOption) {
                  final selected = selectedHour == -1;
                  return GestureDetector(
                    onTap: () {
                      _showCustomDurationBottomSheet();
                    },
                    child: Container(
                      width: 74,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected ? kTripGold : kTripBorder,
                        ),
                        color: kWhite,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 24,
                            width: 24,
                            decoration: const BoxDecoration(
                              color: kTripCreamBg,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: kTripIconMuted,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('Custom', style: kTripChipCustomM),
                        ],
                      ),
                    ),
                  );
                }

                final selected = selectedHour == hour;

                return GestureDetector(
                  onTap: () {
                    _mutateTripForm(() {
                      selectedHour = hour;
                    });
                  },
                  child: Container(
                    width: 74,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? kTripGold : kTripBorder,
                      ),
                      color: kWhite,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$hour',
                          style: selected
                              ? kTripChipHourB
                              : kTripChipHourMutedB,
                        ),
                        const SizedBox(height: 6),
                        Text('Hrs', style: kTripChipUnitM),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemCount: (!isShortTrip && selectedHour == -1) ? 2 : 7,
            ),
          ),

          if (!isShortTrip) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _overnightOptionCard(
                    title: 'No Overnight Stay',
                    subtitle: 'Driver will not stay overnight',
                    isSelected: isOvernightStay == false,
                    onTap: () {
                      _mutateTripForm(() {
                        isOvernightStay = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _overnightOptionCard(
                    title: 'Driver Night stay required',
                    subtitle: 'Include driver\'s accommodation allowance',
                    isSelected: isOvernightStay == true,
                    onTap: () {
                      _mutateTripForm(() {
                        isOvernightStay = true;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (isOvernightStay == true) ...[
              const SizedBox(height: 24),
              Text('Stay Duration', style: kTripSubSectionSB),
              const SizedBox(height: 16),
              SizedBox(
                height: 74,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if (selectedNight == -1) {
                      if (index == 0) {
                        return GestureDetector(
                          onTap: _showCustomStayDurationBottomSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: kTripGold),
                              color: const Color(
                                0xFFFFFDF9,
                              ), // Very light golden tint
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$customNights Night',
                                  style: kTripChipDurationSB,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: _showCustomStayDurationBottomSheet,
                          child: Container(
                            width: 74,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: kTripBorder),
                              color: kWhite,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 24,
                                  width: 24,
                                  decoration: const BoxDecoration(
                                    color: kTripCreamBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 16,
                                    color: kTripIconMuted,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text('Custom', style: kTripChipCustomM),
                              ],
                            ),
                          ),
                        );
                      }
                    }

                    if (index == 3) {
                      return GestureDetector(
                        onTap: _showCustomStayDurationBottomSheet,
                        child: Container(
                          width: 74,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: kTripBorder),
                            color: kWhite,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 24,
                                width: 24,
                                decoration: const BoxDecoration(
                                  color: kTripCreamBg,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  size: 16,
                                  color: kTripIconMuted,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text('Custom', style: kTripChipCustomM),
                            ],
                          ),
                        ),
                      );
                    }

                    final night = index + 1;
                    final selected = selectedNight == night;

                    return GestureDetector(
                      onTap: () {
                        _mutateTripForm(() {
                          selectedNight = night;
                        });
                      },
                      child: Container(
                        width: 74,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected ? kTripGold : kTripBorder,
                          ),
                          color: kWhite,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$night Night',
                              style: selected
                                  ? kTripChipDurationSB
                                  : kTripChipHourMutedB,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemCount: selectedNight == -1 ? 2 : 4,
                ),
              ),
            ],
          ] else ...[
            const SizedBox(height: 10),
            Text('Includes waiting time', style: kTripWaitingNoteM),
          ],
        ],
      ),
    );
  }

  Widget _overnightOptionCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 85,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? kTripGold : kTripBorder),
          color: kWhite,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 2),
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? kTripGold : kTripRadioMuted,
                  width: isSelected ? 4 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: kTripOvernightTitleSB),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: kTripOvernightSubR,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tripTypeButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? kTripGold : kTripBorder),
        ),
        child: Center(child: Text(title, style: kTripTypeChipM)),
      ),
    );
  }

  /// ============================================================
  /// PROTECTION CARD
  /// ============================================================

  Widget _buildProtectionCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Trip Protection', style: kTripProtectionTitleSB),

                    const SizedBox(width: 10),

                    Text(
                      '+ ₹$_tripProtectionFee',
                      style: kTripProtectionAddonB,
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Covers accidents & emergencies during your ride',
                        style: kTripProtectionDescR,
                      ),
                    ),

                    Container(
                      height: 18,
                      width: 18,
                      decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'i',
                          style: kCaption12R.copyWith(color: kWhite),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          Switch(
            value: isTripProtectionEnabled,
            activeColor: kWhite,
            activeTrackColor: kBrandBlue,
            onChanged: (value) {
              _mutateTripForm(() {
                isTripProtectionEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  /// ============================================================
  /// PAYMENT CARD
  /// ============================================================

  Widget _buildPaymentCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose Payment Option', style: kTripSectionTitleSB),

          const SizedBox(height: 26),

          _paymentTile(
            title: 'Cash on Pay',
            subtitle: 'Pay the driver after your trip is completed.',
            trailingText: 'Pay after trip',
            isSelected: selectedPaymentIndex == 0,
            onTap: () {
              setState(() {
                selectedPaymentIndex = 0;
              });
            },
          ),

          const SizedBox(height: 18),

          _paymentTile(
            title: 'Pay Online Now',
            subtitle: 'Pay now and we will start searching driver for you.',
            isSelected: selectedPaymentIndex == 1,
            onTap: () {
              setState(() {
                selectedPaymentIndex = 1;
              });
            },
            trailingWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_onlinePaymentTotalLabel, style: kTripPaymentPriceB),
                const SizedBox(width: 10),
                Icon(
                  selectedPaymentIndex == 1
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: kBrandBlue,
                ),
              ],
            ),
          ),
          if (selectedPaymentIndex == 1) ...[
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kTripSecureBannerBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_outlined, color: kActiveGreen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: kTripSecureBannerR,
                        children: [
                          TextSpan(
                            text: 'Secure payment. 100% safe & encrypted. ',
                            style: kTripSecureBannerB,
                          ),
                          const TextSpan(
                            text: 'UPI, Cards, Wallets & Net Banking accepted.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _paymentTile({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    String? trailingText,
    Widget? trailingWidget,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isSelected ? kTripGold : kTripBorder),
          color: kWhite,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? kTripGold : kTripRadioMuted,
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: kTripPaymentTitleSB),

                  const SizedBox(height: 10),

                  Text(subtitle, style: kTripPaymentSubtitleR),
                ],
              ),
            ),

            if (trailingText != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(trailingText, style: kTripPaymentTrailingR),
              ),

            if (trailingWidget != null) trailingWidget,
          ],
        ),
      ),
    );
  }

  void _showCustomDurationBottomSheet() async {
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) {
        return Dialog(
          alignment: Alignment.bottomCenter,
          backgroundColor: kWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          child: _CustomDurationSheet(
            initialDays: customDays,
            initialHours: customHours,
          ),
        );
      },
    );

    if (result != null) {
      _mutateTripForm(() {
        selectedHour = -1; // -1 means custom
        customDays = result['days']!;
        customHours = result['hours']!;
      });
    }
  }

  void _showCustomStayDurationBottomSheet() async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return Dialog(
          alignment: Alignment.bottomCenter,
          backgroundColor: kWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          child: _CustomStayDurationSheet(initialNights: customNights),
        );
      },
    );

    if (result != null) {
      _mutateTripForm(() {
        selectedNight = -1; // -1 means custom
        customNights = result;
      });
    }
  }

  Future<void> _submitTripCreation() async {
    final userResponse = await ref.read(onboardingApiProvider).getMe();
    if (!userResponse.success || userResponse.data == null) {
      _showError(userResponse.message ?? 'Unable to load your profile.');
      return;
    }

    final payloadResult = _buildTripPayload(userResponse.data!.userId);
    if (!payloadResult.success || payloadResult.data == null) {
      _showError(payloadResult.message ?? 'Please review trip details.');
      return;
    }

    await _fetchPriceEstimate();
    if (!mounted) return;

    final refreshedPayloadResult = _buildTripPayload(userResponse.data!.userId);
    if (!refreshedPayloadResult.success || refreshedPayloadResult.data == null) {
      _showError(refreshedPayloadResult.message ?? 'Please review trip details.');
      return;
    }

    setState(() => _isSubmitting = true);

    log('Create Trip Request Body: ${refreshedPayloadResult.data}');

    final createResponse = await ref
        .read(tripApiProvider)
        .createManualTrip(refreshedPayloadResult.data!);

    log('Create Trip Response Message: ${createResponse.message}');

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (!createResponse.success) {
      _showError(createResponse.message ?? 'Trip creation failed.');
      return;
    }

    final tripData = nestedData(createResponse.data) ?? createResponse.data;
    if (tripData == null) {
      _showError('Trip created but response was invalid.');
      return;
    }

    final trip = TripModel.fromJson(Map<String, dynamic>.from(tripData));

    if (!isRideNow && scheduledRideAt != null) {
      NavigationService().pushNamed(
        'trip_scheduled',
        arguments: {
          ...trip.toWaitingDriverArguments(),
          'scheduledAt': scheduledRideAt,
        },
      );
      return;
    }

    NavigationService().pushNamed(
      'booking_confirmed',
      arguments: trip.toWaitingDriverArguments(),
    );
  }

  ApiResponse<Map<String, dynamic>> _buildTripPayload(String userId) {
    if (_pickupAddress.trim().isEmpty) {
      return ApiResponse.error('Please select pickup location.');
    }

    if (isOneWay &&
        (_dropoffAddress == null || _dropoffAddress!.trim().isEmpty)) {
      return ApiResponse.error('Please select destination for one-way trip.');
    }

    if (_selectedVehicle == null || _selectedVehicle!.id.isEmpty) {
      return ApiResponse.error('Please add a vehicle before booking.');
    }

    if (!isRideNow && scheduledRideAt == null) {
      return ApiResponse.error('Select a schedule time for this trip.');
    }

    final duration = _resolveDuration();
    if (!duration.success || duration.data == null) {
      return ApiResponse.error(duration.message ?? 'Invalid trip duration.');
    }

    final overnight = _resolveOvernightStay(duration.data!);
    if (!overnight.success || overnight.data == null) {
      return ApiResponse.error(
        overnight.message ?? 'Invalid overnight stay details.',
      );
    }

    final payload = <String, dynamic>{
      'userId': userId,
      'tripDirection': isOneWay ? 'one_way' : 'round_trip',
      'pickupLocation': {'address': _pickupAddress},
      if (isOneWay) 'dropoffLocation': {'address': _dropoffAddress},
      'tripType': isShortTrip ? 'short_trip' : 'long_trip',
      'rideTime': isRideNow ? 'now' : 'scheduled',
      'durationValue': duration.data!['durationValue'],
      'durationUnit': duration.data!['durationUnit'],
      'vehicleId': _selectedVehicle!.id,
      'assignmentType': 'auto_assign',
      'tripProtection': {
        'enabled': isTripProtectionEnabled,
        'fee': isTripProtectionEnabled ? _tripProtectionFee : 0,
      },
      'paymentMethod': selectedPaymentIndex == 1 ? 'pay_online' : 'cash',
      if (_priceEstimate != null)
        'priceEstimate': _priceEstimate!.toPriceEstimatePayload()
      else
        'priceEstimate': {'currency': 'INR', 'includesWaitingTime': isShortTrip},
      'overnightStay': overnight.data,
    };

    if (!isRideNow && scheduledRideAt != null) {
      payload['pickupDate'] = _apiDateFormat.format(scheduledRideAt!);
      payload['pickupTime'] = _apiTimeFormat.format(scheduledRideAt!);
    }

    return ApiResponse.success(payload);
  }

  ApiResponse<Map<String, dynamic>> _resolveDuration() {
    if (isShortTrip) {
      if (selectedHour < 1 || selectedHour > 7) {
        return ApiResponse.error('Short trips must be between 1 and 7 hours.');
      }
      return ApiResponse.success({
        'durationValue': selectedHour,
        'durationUnit': 'hours',
      });
    }

    if (selectedHour == -1) {
      if (customDays > 0) {
        return ApiResponse.success({
          'durationValue': customDays,
          'durationUnit': 'days',
        });
      }
      if (customHours >= 8) {
        return ApiResponse.success({
          'durationValue': customHours,
          'durationUnit': 'hours',
        });
      }
      return ApiResponse.error(
        'Long custom trip must be at least 8 hours or 1 day.',
      );
    }

    if (selectedHour < 8) {
      return ApiResponse.error('Long trips must be 8+ hours.');
    }

    return ApiResponse.success({
      'durationValue': selectedHour,
      'durationUnit': 'hours',
    });
  }

  ApiResponse<Map<String, dynamic>> _resolveOvernightStay(
    Map<String, dynamic> resolvedDuration,
  ) {
    final isDayBasedLongTrip =
        !isShortTrip && resolvedDuration['durationUnit'] == 'days';
    final overnightRequired = isDayBasedLongTrip && isOvernightStay == true;

    if (!overnightRequired) {
      return ApiResponse.success({'required': false, 'nights': null});
    }

    final nights = selectedNight == -1 ? customNights : selectedNight;
    if (nights < 1) {
      return ApiResponse.error('Overnight stay requires at least 1 night.');
    }

    return ApiResponse.success({'required': true, 'nights': nights});
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickPickupLocation() async {
    final result = await NavigationService().pushNamed(
      'search_location',
      arguments: {
        'title': 'Where are you leaving from?',
        'showCurrentLocation': true,
      },
    );

    final selectedAddress = _extractAddressFromSelection(result);
    if (selectedAddress == null || selectedAddress.isEmpty || !mounted) return;

    setState(() {
      _pickupAddress = selectedAddress;
    });
  }

  Future<void> _pickDropoffLocation() async {
    final result = await NavigationService().pushNamed(
      'search_location',
      arguments: {
        'title': 'Where are you heading?',
        'showCurrentLocation': false,
      },
    );

    final selectedAddress = _extractAddressFromSelection(result);
    if (selectedAddress == null || selectedAddress.isEmpty || !mounted) return;

    setState(() {
      _dropoffAddress = selectedAddress;
    });
  }

  String? _extractAddressFromSelection(dynamic result) {
    if (result is String) return result.trim();
    if (result is Map && result['address'] is String) {
      return (result['address'] as String).trim();
    }
    return null;
  }

  Future<void> _openAddVehicleSheet() async {
    final addedVehicle = await showAddVehicleBottomSheet(context);
    if (!mounted) return;

    await _loadVehicles(selectVehicle: addedVehicle);
  }
}

class _CustomDurationSheet extends StatefulWidget {
  final int initialDays;
  final int initialHours;

  const _CustomDurationSheet({
    required this.initialDays,
    required this.initialHours,
  });

  @override
  State<_CustomDurationSheet> createState() => _CustomDurationSheetState();
}

class _CustomDurationSheetState extends State<_CustomDurationSheet> {
  late int selectedDays;
  late int selectedHours;
  late FixedExtentScrollController _daysController;
  late FixedExtentScrollController _hoursController;

  @override
  void initState() {
    super.initState();
    selectedDays = widget.initialDays;
    selectedHours = widget.initialHours;
    _daysController = FixedExtentScrollController(initialItem: selectedDays);
    _hoursController = FixedExtentScrollController(initialItem: selectedHours);
  }

  @override
  void dispose() {
    _daysController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 28, bottom: 24),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select Custom Duration', style: kTripModalTitleSB),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: kTripCloseBtnBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: RichText(
              text: TextSpan(
                style: kTripModalSummaryR,
                children: [
                  const TextSpan(text: 'Trip Duration:  '),
                  TextSpan(
                    text: '$selectedDays Day • $selectedHours Hour',
                    style: kTripModalSummaryB,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: CupertinoPicker.builder(
                    scrollController: _daysController,
                    itemExtent: 54,
                    selectionOverlay: Container(
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(color: kBrandBlue, width: 1.5),
                        ),
                      ),
                    ),
                    childCount: 30, // 0 to 29 days
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedDays = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final isSelected = index == selectedDays;
                      return Center(
                        child: Text(
                          '$index Day',
                          style: isSelected
                              ? kTripPickerSelectedM
                              : kTripPickerUnselectedM,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 32),
                SizedBox(
                  width: 120,
                  child: CupertinoPicker.builder(
                    scrollController: _hoursController,
                    itemExtent: 54,
                    selectionOverlay: Container(
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          horizontal: BorderSide(color: kBrandBlue, width: 1.5),
                        ),
                      ),
                    ),
                    childCount: 24, // 0 to 23 hours
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedHours = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final isSelected = index == selectedHours;
                      final hrStr = index == 0
                          ? '0'
                          : index.toString().padLeft(2, '0');
                      return Center(
                        child: Text(
                          '$hrStr hrs',
                          style: isSelected
                              ? kTripPickerSelectedM
                              : kTripPickerUnselectedM,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () {
              Navigator.pop(context, {
                'days': selectedDays,
                'hours': selectedHours,
              });
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: kTripCtaBlue,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Center(
                child: Text('Apply Duration', style: kTripModalButtonM),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomStayDurationSheet extends StatefulWidget {
  final int initialNights;

  const _CustomStayDurationSheet({required this.initialNights});

  @override
  State<_CustomStayDurationSheet> createState() =>
      _CustomStayDurationSheetState();
}

class _CustomStayDurationSheetState extends State<_CustomStayDurationSheet> {
  late int selectedNights;

  @override
  void initState() {
    super.initState();
    selectedNights = widget.initialNights;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 28, bottom: 24),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Stay Duration', style: kTripStaySheetTitleSB),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: kTripCloseBtnBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (selectedNights > 1) {
                    setState(() {
                      selectedNights--;
                    });
                  }
                },
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: kScreenBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.remove, size: 28, color: kTextColor),
                ),
              ),
              Text(
                '$selectedNights Night${selectedNights > 1 ? 's' : ''}',
                style: kTripStayCounterB,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedNights++;
                  });
                },
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: kScreenBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.add, size: 28, color: kTextColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: () {
              Navigator.pop(context, selectedNights);
            },
            child: Container(
              height: 58,
              decoration: BoxDecoration(
                color: kTripCtaBlue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Text('Confirm Stay Duration', style: kTripModalButtonM),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
