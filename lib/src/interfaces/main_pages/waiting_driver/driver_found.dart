import 'dart:async';
import 'dart:math';

import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Temporary OTP until backend generation is wired.
String generateTripOtp() {
  final random = Random();
  return List.generate(4, (_) => random.nextInt(10).toString()).join();
}

class DriverFoundPage extends StatefulWidget {
  final String tripTitle;
  final String tripId;
  final String pickup;
  final String dropoff;
  final String price;
  final String distance;
  final String duration;
  final String driverName;
  final double driverRating;
  final int driverTrips;
  final String vehicleTypes;

  const DriverFoundPage({
    super.key,
    this.tripTitle = 'One Way Trip',
    this.tripId = '# ID2562',
    this.pickup = 'Edappally',
    this.dropoff = 'Infopark',
    this.price = '₹ 235',
    this.distance = '12 km',
    this.duration = '2 hrs',
    this.driverName = 'Ajith Kumar',
    this.driverRating = 4.8,
    this.driverTrips = 120,
    this.vehicleTypes = 'Manual + Auto',
  });

  @override
  State<DriverFoundPage> createState() => _DriverFoundPageState();
}

class _DriverFoundPageState extends State<DriverFoundPage> {
  static const _otpBorderColor = Color(0xFFC5A358);
  static const _policyTimerBlue = Color(0xFF165A91);

  late final String _otp;
  Timer? _cancelTimer;
  Duration _cancelRemaining = const Duration(minutes: 58, seconds: 32);

  @override
  void initState() {
    super.initState();
    _otp = generateTripOtp();
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
  }

  @override
  void dispose() {
    _cancelTimer?.cancel();
    super.dispose();
  }

  String get _cancelTimerLabel {
    final minutes = _cancelRemaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = (_cancelRemaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds remaining';
  }

  @override
  Widget build(BuildContext context) {
    final mapHeight = MediaQuery.sizeOf(context).height * 0.26;

    return Scaffold(
      backgroundColor: kWhite,
      body: Column(
        children: [
          _DriverFoundHeader(
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
                const Positioned(right: 20, bottom: 12, child: _HelpButton()),
              ],
            ),
          ),
          Expanded(
            child: _DriverFoundSheet(
              otp: _otp,
              otpBorderColor: _otpBorderColor,
              policyTimerBlue: _policyTimerBlue,
              cancelTimerLabel: _cancelTimerLabel,
              pickup: widget.pickup,
              dropoff: widget.dropoff,
              price: widget.price,
              distance: widget.distance,
              duration: widget.duration,
              driverName: widget.driverName,
              driverRating: widget.driverRating,
              driverTrips: widget.driverTrips,
              vehicleTypes: widget.vehicleTypes,
              onCancel: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverFoundHeader extends StatelessWidget {
  final String tripTitle;
  final String tripId;
  final VoidCallback onBack;

  const _DriverFoundHeader({
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
        padding: EdgeInsets.fromLTRB(8, topInset + 4, 12, 12),
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

class _HelpButton extends StatelessWidget {
  const _HelpButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kWhite,
      elevation: 4,
      shadowColor: kBlack.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/svg/Help_image.svg',
                width: 22,
                height: 22,
              ),
              const SizedBox(width: 8),
              Text('Help', style: kWaitingDriverHelpM),
            ],
          ),
        ),
      ),
    );
  }
}

class _DriverFoundSheet extends StatelessWidget {
  final String otp;
  final Color otpBorderColor;
  final Color policyTimerBlue;
  final String cancelTimerLabel;
  final String pickup;
  final String dropoff;
  final String price;
  final String distance;
  final String duration;
  final String driverName;
  final double driverRating;
  final int driverTrips;
  final String vehicleTypes;
  final VoidCallback onCancel;

  const _DriverFoundSheet({
    required this.otp,
    required this.otpBorderColor,
    required this.policyTimerBlue,
    required this.cancelTimerLabel,
    required this.pickup,
    required this.dropoff,
    required this.price,
    required this.distance,
    required this.duration,
    required this.driverName,
    required this.driverRating,
    required this.driverTrips,
    required this.vehicleTypes,
    required this.onCancel,
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
        padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Driver Found',
              textAlign: TextAlign.center,
              style: kDriverFoundTitleSB,
            ),
            const SizedBox(height: 6),
            Text(
              '200 meters away • Arriving in 10 minutes...',
              textAlign: TextAlign.center,
              style: kDriverFoundSubtitleR,
            ),
            const SizedBox(height: 18),
            _DriverInfoCard(
              driverName: driverName,
              driverRating: driverRating,
              driverTrips: driverTrips,
              vehicleTypes: vehicleTypes,
            ),
            const SizedBox(height: 14),
            _OtpCard(otp: otp, borderColor: otpBorderColor),
            const SizedBox(height: 14),
            _TripSummaryCard(
              pickup: pickup,
              dropoff: dropoff,
              price: price,
              distance: distance,
              duration: duration,
            ),
            const SizedBox(height: 18),
            Text('Cancelation Policy', style: kDriverFoundSectionTitleSB),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: kDriverFoundPolicyR,
                children: [
                  const TextSpan(
                    text: 'Free cancellation until 60 mins before pickup. ',
                  ),
                  TextSpan(
                    text: cancelTimerLabel,
                    style: kDriverFoundPolicyTimerSB.copyWith(
                      color: policyTimerBlue,
                    ),
                  ),
                  const TextSpan(text: ' Charges may apply after that'),
                ],
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Learn More',
                style: kDriverFoundLearnMoreM.copyWith(
                  color: policyTimerBlue,
                  decoration: TextDecoration.underline,
                  decorationColor: policyTimerBlue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            primaryButton(
              label: 'Cancel Ride',
              onPressed: onCancel,
              buttonColor: kWhite,
              sideColor: kRed,
              labelColor: kRed,
              fontSize: 16,
              buttonHeight: 54,
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverInfoCard extends StatelessWidget {
  final String driverName;
  final double driverRating;
  final int driverTrips;
  final String vehicleTypes;

  const _DriverInfoCard({
    required this.driverName,
    required this.driverRating,
    required this.driverTrips,
    required this.vehicleTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCardBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://i.pravatar.cc/128?u=ajith_kumar_driver',
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 56,
                height: 56,
                color: kChipGreyBg,
                child: const Icon(Icons.person, color: kMutedText, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(driverName, style: kDriverFoundNameSB),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      driverRating.toStringAsFixed(1),
                      style: kDriverFoundRatingM,
                    ),
                    const SizedBox(width: 4),
                    ..._buildStars(driverRating),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '• $driverTrips trips',
                        style: kDriverFoundMetaR,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(vehicleTypes, style: kDriverFoundMetaR),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _DriverActionButton(
            color: kActiveGreen,
            icon: Icons.chat_bubble_outline_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _DriverActionButton(
            color: kBlue,
            icon: Icons.phone_in_talk_rounded,
            onTap: () {},
          ),
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
      return Icon(icon, size: 14, color: const Color(0xFFE8B923));
    });
  }
}

class _DriverActionButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _DriverActionButton({
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
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

class _OtpCard extends StatelessWidget {
  final String otp;
  final Color borderColor;

  const _OtpCard({required this.otp, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    final digits = otp.padRight(4, '0').substring(0, 4).split('');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCardBorder),
      ),
      child: Column(
        children: [
          Text('Start your trip', style: kDriverFoundOtpTitleSB),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 4; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                _OtpDigitBox(digit: digits[i], borderColor: borderColor),
              ],
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Share this code with your driver to begin',
            textAlign: TextAlign.center,
            style: kDriverFoundOtpHintR,
          ),
        ],
      ),
    );
  }
}

class _OtpDigitBox extends StatelessWidget {
  final String digit;
  final Color borderColor;

  const _OtpDigitBox({required this.digit, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Text(digit, style: kDriverFoundOtpDigitSB),
    );
  }
}

class _TripSummaryCard extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String price;
  final String distance;
  final String duration;

  const _TripSummaryCard({
    required this.pickup,
    required this.dropoff,
    required this.price,
    required this.distance,
    required this.duration,
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: kActiveGreenBg,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          pickup,
                          style: kDriverFoundRouteSB,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: kActiveGreen,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          dropoff,
                          style: kDriverFoundRouteSB,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(price, style: kDriverFoundPriceSB),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(
              children: [
                _TripMetaRow(
                  icon: Icons.location_on_outlined,
                  label: 'Distance: $distance',
                ),
                const SizedBox(height: 6),
                _TripMetaRow(
                  icon: Icons.access_time_rounded,
                  label: 'Time Duration: $duration',
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
        Icon(icon, size: 16, color: kTripIconMuted),
        const SizedBox(width: 6),
        Text(label, style: kDriverFoundTripMetaR),
      ],
    );
  }
}
