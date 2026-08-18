import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/models/trip_model.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:flutter/material.dart';

class CancelledTripDetailsPage extends StatelessWidget {
  final String tripTitle;
  final String tripId;
  final String? tripMongoId;
  final bool isLongTrip;
  final String pickup;
  final String dropoff;
  final String metaLine;
  final String amountPaid;
  final String refundAmount;
  final String refundInitiatedAt;
  final String driverName;
  final double driverRating;
  final int driverTrips;
  final String? driverPhotoUrl;
  final String vehicleTypes;
  final bool hasDriver;

  const CancelledTripDetailsPage({
    super.key,
    this.tripTitle = 'One Way Trip',
    this.tripId = '—',
    this.tripMongoId,
    this.isLongTrip = false,
    this.pickup = '—',
    this.dropoff = '—',
    this.metaLine = '—',
    this.amountPaid = '—',
    this.refundAmount = '—',
    this.refundInitiatedAt = '—',
    this.driverName = TripModel.noNameFound,
    this.driverRating = 0,
    this.driverTrips = 0,
    this.driverPhotoUrl,
    this.vehicleTypes = '—',
    this.hasDriver = true,
  });

  bool get _effectiveHasDriver =>
      hasDriver &&
      driverName != TripModel.noNameFound &&
      driverName.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: kScreenBg,
      body: Column(
        children: [
          _CancelledTripHeader(
            tripTitle: tripTitle,
            tripId: tripId,
            onBack: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                NavigationService().resetToNavbar();
              }
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: kBlack.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const _CancelledBadge(),
                        const SizedBox(width: 8),
                        _TripTypeBadge(isLongTrip: isLongTrip),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 18,
                          color: kTripBodyMuted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(metaLine, style: kScheduledTripDateR),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _CancelledRouteSection(
                      pickup: pickup,
                      dropoff: dropoff,
                    ),
                    SizedBox(height: 15,),
                    if (_effectiveHasDriver)
                      _CancelledDriverCard(
                        driverName: driverName,
                        driverRating: driverRating,
                        driverTrips: driverTrips,
                        driverPhotoUrl: driverPhotoUrl,
                        vehicleTypes: vehicleTypes,
                        onChat: () {
                          NavigationService().pushNamed(
                            'chat_screen',
                            arguments: {'participantName': driverName},
                          );
                        },
                      )
                    else
                      const _NoDriverAssignedCard(),
                    const SizedBox(height: 16),
                    _CancelledFareBreakdownCard(
                      amountPaid: amountPaid,
                      refundAmount: refundAmount,
                      refundInitiatedAt: refundInitiatedAt,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: kScreenBg,
            padding: EdgeInsets.fromLTRB(16, 8, 16, bottomInset + 16),
            child: Row(
              children: [
                Expanded(
                  child: _BottomActionButton(
                    label: 'Book again',
                    filled: true,
                    fillColor: AppColors.fillBlueGrey,
                    textColor: kTripCtaBlue,
                    onPressed: () {
                      NavigationService().pushNamed('create_trip');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BottomActionButton(
                    label: 'Raise a ticket',
                    filled: false,
                    textColor: kTripCtaBlue,
                    onPressed: () {
                      NavigationService().pushNamed(
                        'raise_ticket',
                        arguments: {
                          'tripId': tripId,
                          if (tripMongoId != null && tripMongoId!.isNotEmpty)
                            'tripMongoId': tripMongoId,
                          'category': 'Trip Support',
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelledTripHeader extends StatelessWidget {
  final String tripTitle;
  final String tripId;
  final VoidCallback onBack;

  const _CancelledTripHeader({
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
            Material(
              color: kTripCtaBlue,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Text(
                    'Download Invoice',
                    style: kStyle(kSemiBold, kSize12, color: kWhite),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelledBadge extends StatelessWidget {
  static const _cancelledBg = AppColors.cancelledBackground;
  static const _cancelledRed = AppColors.errorRedAlt;

  const _CancelledBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _cancelledBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: _cancelledRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 11, color: kWhite),
          ),
          const SizedBox(width: 6),
          Text(
            'Cancelled',
            style: kStyle(kSemiBold, kSize11, color: _cancelledRed),
          ),
        ],
      ),
    );
  }
}

class _TripTypeBadge extends StatelessWidget {
  final bool isLongTrip;

  const _TripTypeBadge({required this.isLongTrip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: kChipGreyBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_forward_rounded,
            size: 14,
            color: kBlack.withValues(alpha: 0.65),
          ),
          const SizedBox(width: 4),
          Text(
            isLongTrip ? 'LONG TRIP' : 'SHORT TRIP',
            style: kStyle(
              kSemiBold,
              kSize11,
              color: kTextColor,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelledRouteSection extends StatelessWidget {
  final String pickup;
  final String dropoff;

  const _CancelledRouteSection({
    required this.pickup,
    required this.dropoff,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RouteStop(
          iconColor: kActiveGreen,
          title: pickup,
          subtitle: 'Pickup Location',
        ),
        Padding(
          padding: const EdgeInsets.only(left: 11),
          child: SizedBox(
            height: 28,
            width: 1.5,
            child: CustomPaint(
              painter: _DashedLinePainter(color: kLineGrey, vertical: true),
            ),
          ),
        ),
        _RouteStop(
          iconColor: kDropBlue,
          title: dropoff,
          subtitle: 'Drop Location',
        ),
      ],
    );
  }
}

class _RouteStop extends StatelessWidget {
  final Color iconColor;
  final String title;
  final String subtitle;

  const _RouteStop({
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on_rounded, color: iconColor, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: kScheduledTripRouteTitleSB),
              const SizedBox(height: 2),
              Text(subtitle, style: kScheduledTripRouteSubtitleR),
            ],
          ),
        ),
      ],
    );
  }
}

class _CancelledDriverCard extends StatelessWidget {
  final String driverName;
  final double driverRating;
  final int driverTrips;
  final String? driverPhotoUrl;
  final String vehicleTypes;
  final VoidCallback onChat;

  const _CancelledDriverCard({
    required this.driverName,
    required this.driverRating,
    required this.driverTrips,
    this.driverPhotoUrl,
    required this.vehicleTypes,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final photoUrl = driverPhotoUrl?.trim();
    final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

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
            child: hasPhoto
                ? Image.network(
                    photoUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _driverPlaceholder(),
                  )
                : _driverPlaceholder(),
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
            onTap: onChat,
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

  Widget _driverPlaceholder() {
    return Container(
      width: 56,
      height: 56,
      color: kChipGreyBg,
      child: const Icon(Icons.person, color: kMutedText, size: 32),
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
      return Icon(icon, size: 14, color: AppColors.ratingGold);
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

class _CancelledFareBreakdownCard extends StatelessWidget {
  final String amountPaid;
  final String refundAmount;
  final String refundInitiatedAt;

  const _CancelledFareBreakdownCard({
    required this.amountPaid,
    required this.refundAmount,
    required this.refundInitiatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Fare Breakdown', style: kScheduledTripSectionSB),
          const SizedBox(height: 12),
          const _DashedDivider(),
          const SizedBox(height: 12),
          _FareRow(label: 'Amount Paid', value: amountPaid),
          const SizedBox(height: 12),
          const _DashedDivider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Refund Initiated', style: kScheduledTripSectionSB),
              const Spacer(),
              Text(refundAmount, style: kCancelledRefundAmountSB),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Refund will be credited to your wallet within 5-7 business days.',
            style: kStyle(
              kRegular,
              kSize13,
              color: kTripBodyMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: kStyle(kRegular, kSize13, color: kTripBodyMuted),
              children: [
                const TextSpan(text: 'Initiated on '),
                TextSpan(
                  text: refundInitiatedAt,
                  style: kCancelledRefundDateSB,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FareRow extends StatelessWidget {
  final String label;
  final String value;

  const _FareRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: kScheduledTripPaymentLabelR),
        const Spacer(),
        Text(value, style: kScheduledTripPaymentValueSB),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DashedLinePainter(color: kLineGrey),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final bool vertical;

  const _DashedLinePainter({required this.color, this.vertical = false});

  @override
  void paint(Canvas canvas, Size size) {
    const dashLength = 4.0;
    const dashSpace = 3.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    if (vertical) {
      var y = 0.0;
      while (y < size.height) {
        canvas.drawLine(Offset(0, y), Offset(0, y + dashLength), paint);
        y += dashLength + dashSpace;
      }
    } else {
      var x = 0.0;
      while (x < size.width) {
        canvas.drawLine(Offset(x, 0), Offset(x + dashLength, 0), paint);
        x += dashLength + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.vertical != vertical;
}

class _BottomActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final Color? fillColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _BottomActionButton({
    required this.label,
    required this.filled,
    this.fillColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? fillColor : kWhite,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: filled ? null : Border.all(color: kTripCtaBlue, width: 1.5),
          ),
          child: Text(
            label,
            style: kStyle(kSemiBold, kSize15, color: textColor),
          ),
        ),
      ),
    );
  }
}

class _NoDriverAssignedCard extends StatelessWidget {
  const _NoDriverAssignedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kTripCreamBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: kChipGreyBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.person_outline, color: kMutedText, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('No driver assigned', style: kDriverFoundNameSB),
                const SizedBox(height: 4),
                Text(
                  'This trip was cancelled before a driver was assigned.',
                  style: kDriverFoundMetaR,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
