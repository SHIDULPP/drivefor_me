import 'dart:async';

import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/trip_completed.dart';
import 'package:flutter/material.dart';

class TripProgressPage extends StatefulWidget {
  final String tripTitle;
  final String tripId;
  final String headingTo;
  final String driverName;
  final double driverRating;
  final int driverTrips;
  final String vehicleTypes;
  final int completedStops;
  final bool showTimeLimitReached;
  final String pickup;
  final String dropoff;
  final String price;
  final String distance;
  final String duration;
  final TripCompletedPaymentType paymentType;

  const TripProgressPage({
    super.key,
    this.tripTitle = 'One Way Trip',
    this.tripId = '# ID2562',
    this.headingTo = 'Infopark',
    this.driverName = 'Ajith Kumar',
    this.driverRating = 4.8,
    this.driverTrips = 120,
    this.vehicleTypes = 'Manual + Auto',
    this.completedStops = 3,
    this.showTimeLimitReached = true,
    this.pickup = 'Edappally',
    this.dropoff = 'Infopark',
    this.price = '₹ 235',
    this.distance = '12 km',
    this.duration = '2 hrs 30 min',
    this.paymentType = TripCompletedPaymentType.offline,
  });

  @override
  State<TripProgressPage> createState() => _TripProgressPageState();
}

class _TripProgressPageState extends State<TripProgressPage> {
  static const _policyTimerBlue = Color(0xFF165A91);
  Duration _cancelRemaining = const Duration(minutes: 58, seconds: 32);
  Timer? _cancelTimer;

  @override
  void initState() {
    super.initState();
    _cancelTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_cancelRemaining.inSeconds <= 0) {
        _cancelTimer?.cancel();
        return;
      }
      setState(() {
        _cancelRemaining -= const Duration(seconds: 1);
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TripCompletedPage(
              paymentType: widget.paymentType,
              tripTypeLabel:
                  widget.paymentType == TripCompletedPaymentType.online
                  ? 'Short Trip'
                  : 'Long Trip',
              destinationName: widget.dropoff,
              totalFare: widget.price,
              tripFare: widget.price,
              tripDuration: widget.duration,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _cancelTimer?.cancel();
    super.dispose();
  }

  String get _cancelTimerLabel {
    final minutes = _cancelRemaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = (_cancelRemaining.inSeconds % 60).toString().padLeft(
      2,
      '0',
    );
    return '$minutes:$seconds remaining';
  }

  @override
  Widget build(BuildContext context) {
    final mapHeight = MediaQuery.sizeOf(context).height * 0.29;

    return Scaffold(
      backgroundColor: kWhite,
      body: Column(
        children: [
          _TripProgressHeader(
            tripTitle: widget.tripTitle,
            tripId: widget.tripId,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          SizedBox(
            height: mapHeight,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/pngs/waiting_map.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                const Positioned(
                  right: 14,
                  bottom: 18,
                  child: _EmergencyButton(),
                ),
              ],
            ),
          ),
          Expanded(
            child: _TripProgressSheet(
              headingTo: widget.headingTo,
              driverName: widget.driverName,
              driverRating: widget.driverRating,
              driverTrips: widget.driverTrips,
              vehicleTypes: widget.vehicleTypes,
              completedStops: widget.completedStops,
              showTimeLimitReached: widget.showTimeLimitReached,
              pickup: widget.pickup,
              dropoff: widget.dropoff,
              price: widget.price,
              distance: widget.distance,
              duration: widget.duration,
              timerLabel: _cancelTimerLabel,
              policyTimerBlue: _policyTimerBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _TripProgressHeader extends StatelessWidget {
  final String tripTitle;
  final String tripId;
  final VoidCallback onBack;

  const _TripProgressHeader({
    required this.tripTitle,
    required this.tripId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return ColoredBox(
      color: kWhite,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, topInset + 4, 12, 10),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 22,
                color: kTextColor,
              ),
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    tripTitle,
                    textAlign: TextAlign.center,
                    style: kWaitingDriverTripTitleSB,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tripId,
                    textAlign: TextAlign.center,
                    style: kWaitingDriverTripIdR,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.ios_share_outlined,
                size: 24,
                color: kTextColor,
              ),
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyButton extends StatelessWidget {
  const _EmergencyButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 93,
      height: 56,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kRed, width: 1.1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'SOS',
                style: TextStyle(fontSize: 18, color: kRed, height: 0.9),
              ),
              SizedBox(height: 2),
              Text('Emergency', style: TextStyle(fontSize: 12, color: kRed)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripProgressSheet extends StatelessWidget {
  final String headingTo;
  final String driverName;
  final double driverRating;
  final int driverTrips;
  final String vehicleTypes;
  final int completedStops;
  final bool showTimeLimitReached;
  final String pickup;
  final String dropoff;
  final String price;
  final String distance;
  final String duration;
  final String timerLabel;
  final Color policyTimerBlue;

  const _TripProgressSheet({
    required this.headingTo,
    required this.driverName,
    required this.driverRating,
    required this.driverTrips,
    required this.vehicleTypes,
    required this.completedStops,
    required this.showTimeLimitReached,
    required this.pickup,
    required this.dropoff,
    required this.price,
    required this.distance,
    required this.duration,
    required this.timerLabel,
    required this.policyTimerBlue,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 24,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Trip in Progress',
              style: kDriverFoundTitleSB.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 2),
            RichText(
              text: TextSpan(
                style: kDriverFoundSubtitleR,
                children: [
                  const TextSpan(text: 'Heading to '),
                  TextSpan(
                    text: headingTo,
                    style: kDriverFoundPolicyTimerSB.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _DriverProgressCard(
              driverName: driverName,
              driverRating: driverRating,
              driverTrips: driverTrips,
              vehicleTypes: vehicleTypes,
              completedStops: completedStops,
              showTimeLimitReached: showTimeLimitReached,
            ),
            const SizedBox(height: 12),
            _TripSummaryCard(
              pickup: pickup,
              dropoff: dropoff,
              price: price,
              distance: distance,
              duration: duration,
              showUpdatingTag: showTimeLimitReached,
            ),
            const SizedBox(height: 18),
            const Divider(height: 1, color: kCardBorder),
            const SizedBox(height: 16),
            Text(
              'Cancelation Policy',
              style: kDriverFoundSectionTitleSB.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: kDriverFoundPolicyR.copyWith(height: 1.25),
                children: [
                  const TextSpan(
                    text: 'Free cancellation until 60 mins before pickup. ',
                  ),
                  TextSpan(
                    text: timerLabel,
                    style: kDriverFoundPolicyTimerSB.copyWith(
                      color: policyTimerBlue,
                    ),
                  ),
                  const TextSpan(text: ' Charges may apply after that'),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Learn More',
              style: kDriverFoundLearnMoreM.copyWith(
                color: policyTimerBlue,
                decoration: TextDecoration.underline,
                decorationColor: policyTimerBlue,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverProgressCard extends StatelessWidget {
  final String driverName;
  final double driverRating;
  final int driverTrips;
  final String vehicleTypes;
  final int completedStops;
  final bool showTimeLimitReached;

  const _DriverProgressCard({
    required this.driverName,
    required this.driverRating,
    required this.driverTrips,
    required this.vehicleTypes,
    required this.completedStops,
    required this.showTimeLimitReached,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://i.pravatar.cc/128?u=ajith_kumar_trip_progress',
                  width: 78,
                  height: 78,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 78,
                    height: 78,
                    color: kChipGreyBg,
                    child: const Icon(
                      Icons.person,
                      color: kMutedText,
                      size: 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: kDriverFoundNameSB.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          driverRating.toStringAsFixed(1),
                          style: kDriverFoundRatingM.copyWith(fontSize: 13),
                        ),
                        const SizedBox(width: 4),
                        ..._buildStars(driverRating),
                        const SizedBox(width: 4),
                        Text(
                          '• $driverTrips trips',
                          style: kDriverFoundMetaR.copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vehicleTypes,
                      style: kDriverFoundMetaR.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              _ActionCircle(color: kActiveGreen, icon: Icons.chat_rounded),
              const SizedBox(width: 8),
              _ActionCircle(color: kBlue, icon: Icons.phone_in_talk_rounded),
            ],
          ),
          const SizedBox(height: 16),
          _JourneyProgress(completedStops: completedStops),
          const SizedBox(height: 14),
          if (showTimeLimitReached)
            const _TimeLimitReachedBanner()
          else
            const _EtaRow(),
        ],
      ),
    );
  }

  List<Widget> _buildStars(double rating) {
    final fullStars = rating.floor();
    final hasHalf = rating - fullStars >= 0.25;

    return List.generate(5, (index) {
      IconData icon;
      if (index < fullStars) {
        icon = Icons.star_rounded;
      } else if (index == fullStars && hasHalf) {
        icon = Icons.star_half_rounded;
      } else {
        icon = Icons.star_outline_rounded;
      }
      return Icon(icon, size: 16, color: const Color(0xFFE8B923));
    });
  }
}

class _ActionCircle extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _ActionCircle({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () {},
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: kWhite, size: 20),
        ),
      ),
    );
  }
}

class _JourneyProgress extends StatelessWidget {
  final int completedStops;

  const _JourneyProgress({required this.completedStops});

  @override
  Widget build(BuildContext context) {
    final labels = ['Pickup', 'Drop', 'Drop', 'Destination'];
    final activeColor = kTripCtaBlue;

    return Column(
      children: [
        SizedBox(
          height: 14,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                top: 6,
                child: Row(
                  children: List.generate(3, (index) {
                    final isDone = index < completedStops - 1;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 2.4,
                        color: isDone ? activeColor : const Color(0xFFE1E6EE),
                      ),
                    );
                  }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  final isDone = index < completedStops;
                  return Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: isDone ? kWhite : const Color(0xFFF2F5FA),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDone ? activeColor : const Color(0xFFDDE4F0),
                        width: 2.5,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels
              .map(
                (label) => SizedBox(
                  width: 70,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: kDriverFoundMetaR.copyWith(
                      fontSize: 14,
                      color: kTextColor,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _TimeLimitReachedBanner extends StatelessWidget {
  const _TimeLimitReachedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9F2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE6EADD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.error, color: Color(0xFFCC7600), size: 16),
              const SizedBox(width: 8),
              Text(
                'Time Limit Reached',
                style: kDriverFoundNameSB.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              "You've exceeded your 2 hr ride duration\nExtra charges are now applied",
              style: kDriverFoundMetaR.copyWith(fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _EtaRow extends StatelessWidget {
  const _EtaRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1, color: kCardBorder),
        const SizedBox(height: 10),
        Text(
          'ETA: 25 minutes remaining',
          style: kDriverFoundMetaR.copyWith(fontSize: 13.5, color: kGreyDark),
        ),
      ],
    );
  }
}

class _TripSummaryCard extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String price;
  final String distance;
  final String duration;
  final bool showUpdatingTag;

  const _TripSummaryCard({
    required this.pickup,
    required this.dropoff,
    required this.price,
    required this.distance,
    required this.duration,
    required this.showUpdatingTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            color: kActiveGreenBg.withValues(alpha: 0.35),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          pickup,
                          style: kDriverFoundRouteSB.copyWith(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: kActiveGreen,
                          size: 20,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          dropoff,
                          style: kDriverFoundRouteSB.copyWith(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      price,
                      style: kDriverFoundPriceSB.copyWith(fontSize: 20),
                    ),
                    if (showUpdatingTag)
                      Text(
                        '(Updating...)',
                        style: kDriverFoundMetaR.copyWith(
                          fontSize: 11.5,
                          color: const Color(0xFFCD9C3A),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(
              children: [
                _TripMetaRow(
                  icon: Icons.route_rounded,
                  label: 'Distance:  $distance',
                ),
                const SizedBox(height: 6),
                _TripMetaRow(
                  icon: Icons.access_time_filled,
                  label: 'Time Duration:  $duration',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripMetaRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TripMetaRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: kTripIconMuted),
        const SizedBox(width: 8),
        Text(label, style: kDriverFoundTripMetaR.copyWith(fontSize: 15)),
      ],
    );
  }
}
