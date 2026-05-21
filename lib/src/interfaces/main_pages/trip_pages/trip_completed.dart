import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:flutter/material.dart';

enum TripCompletedPaymentType { online, offline }

TripCompletedPaymentType parseTripCompletedPaymentType(dynamic value) {
  if (value is TripCompletedPaymentType) return value;
  if (value is bool) {
    return value
        ? TripCompletedPaymentType.online
        : TripCompletedPaymentType.offline;
  }
  if (value is int) {
    return value == 1
        ? TripCompletedPaymentType.online
        : TripCompletedPaymentType.offline;
  }

  final normalized = value?.toString().toLowerCase().trim() ?? '';
  if (normalized == 'online' ||
      normalized == 'pay_online' ||
      normalized == 'prepaid' ||
      normalized == '1') {
    return TripCompletedPaymentType.online;
  }

  return TripCompletedPaymentType.offline;
}

Map<String, dynamic> tripPaymentArguments(TripCompletedPaymentType paymentType) {
  return {
    'paymentType':
        paymentType == TripCompletedPaymentType.online ? 'online' : 'offline',
  };
}

class TripCompletedPage extends StatefulWidget {
  final TripCompletedPaymentType paymentType;
  final String tripTypeLabel;
  final String destinationName;
  final String destinationAddress;
  final String totalFare;
  final String prepaidAmount;
  final String prepaidDuration;
  final String tripFare;
  final String tripDuration;
  final String extraTimeAmount;
  final String extraTimeDuration;
  final String remainingDue;
  final String remainingDuration;
  final String totalAmount;

  const TripCompletedPage({
    super.key,
    this.paymentType = TripCompletedPaymentType.offline,
    this.tripTypeLabel = 'Long Trip',
    this.destinationName = 'Infopark',
    this.destinationAddress =
        'Infoparks Kerala, Infopark Kochi Phase 1, P.O, Infopark, Kochi, Kakkanad, Kerala 682042',
    this.totalFare = '₹ 335',
    this.prepaidAmount = '₹ 255',
    this.prepaidDuration = '2 hrs 30 min',
    this.tripFare = '₹ 335',
    this.tripDuration = '2 hrs 30 min',
    this.extraTimeAmount = '₹ 255',
    this.extraTimeDuration = '30 min',
    this.remainingDue = '₹ 120',
    this.remainingDuration = '30 min',
    this.totalAmount = '₹ 590',
  });

  @override
  State<TripCompletedPage> createState() => _TripCompletedPageState();
}

class _TripCompletedPageState extends State<TripCompletedPage> {
  bool get _isOnline =>
      widget.paymentType == TripCompletedPaymentType.online;

  String get _paidAmount {
    if (_isOnline) {
      return widget.remainingDue.replaceAll(' ', '');
    }
    return widget.totalAmount.replaceAll(' ', '');
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _goToPaymentCompleted);
  }

  void _goToPaymentCompleted() {
    if (!mounted) return;
    NavigationService().pushNamedReplacement(
      'payment_completed',
      arguments: {'paidAmount': _paidAmount},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            children: [
              Image.asset(
                'assets/pngs/tripcompleted.png',
                height: 220,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 28),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: kBookingConfirmedTitleSB,
                  children: [
                    const TextSpan(text: 'Trip '),
                    TextSpan(
                      text: 'Completed!',
                      style: kBookingConfirmedAccentSB,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Thank you for completing the trip. Hope you had a smooth ride.',
                textAlign: TextAlign.center,
                style: kBookingConfirmedSubtitleR,
              ),
              const SizedBox(height: 22),
              _TripTypePill(label: widget.tripTypeLabel),
              const SizedBox(height: 18),
              _DestinationBlock(
                name: widget.destinationName,
                address: widget.destinationAddress,
              ),
              const SizedBox(height: 22),
              _FareBreakdownCard(
                isOnline: _isOnline,
                totalFare: widget.totalFare,
                prepaidAmount: widget.prepaidAmount,
                prepaidDuration: widget.prepaidDuration,
                tripFare: widget.tripFare,
                tripDuration: widget.tripDuration,
                extraTimeAmount: widget.extraTimeAmount,
                extraTimeDuration: widget.extraTimeDuration,
                remainingDue: widget.remainingDue,
                remainingDuration: widget.remainingDuration,
                totalAmount: widget.totalAmount,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isOnline
          ? SafeArea(
              minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: primaryButton(
                label: 'Pay ${widget.remainingDue}',
                onPressed: () {},
                buttonColor: kTripCtaBlue,
                buttonHeight: 58,
                fontSize: 18,
              ),
            )
          : null,
    );
  }
}

class _TripTypePill extends StatelessWidget {
  final String label;

  const _TripTypePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: kTripCreamBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E8E2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.arrow_forward, size: 16, color: kTextColor),
          const SizedBox(width: 6),
          Text(label, style: kTripChipDurationSB),
        ],
      ),
    );
  }
}

class _DestinationBlock extends StatelessWidget {
  final String name;
  final String address;

  const _DestinationBlock({required this.name, required this.address});

  static const _locationBrown = Color(0xFFB77728);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, size: 18, color: _locationBrown),
            const SizedBox(width: 4),
            Text(
              name,
              style: kStyle(kSemiBold, kSize16, color: _locationBrown),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          address,
          textAlign: TextAlign.center,
          style: kStyle(kRegular, kSize12, color: kTripMutedLabel, height: 1.45),
        ),
      ],
    );
  }
}

class _FareBreakdownCard extends StatelessWidget {
  final bool isOnline;
  final String totalFare;
  final String prepaidAmount;
  final String prepaidDuration;
  final String tripFare;
  final String tripDuration;
  final String extraTimeAmount;
  final String extraTimeDuration;
  final String remainingDue;
  final String remainingDuration;
  final String totalAmount;

  const _FareBreakdownCard({
    required this.isOnline,
    required this.totalFare,
    required this.prepaidAmount,
    required this.prepaidDuration,
    required this.tripFare,
    required this.tripDuration,
    required this.extraTimeAmount,
    required this.extraTimeDuration,
    required this.remainingDue,
    required this.remainingDuration,
    required this.totalAmount,
  });

  static const _cardBg = Color(0xFFF6F7FB);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Fare Breakdown', style: kTripSectionTitleSB),
          const SizedBox(height: 14),
          if (isOnline) ...[
            _FareRow(
              label: 'Total Fare',
              amount: totalFare,
            ),
            const SizedBox(height: 12),
            const _DashedDivider(),
            const SizedBox(height: 12),
            _FareRow(
              label: 'Prepaid Amount',
              amount: prepaidAmount,
              trailingNote: '($prepaidDuration)',
            ),
            const SizedBox(height: 12),
            const _DashedDivider(),
            const SizedBox(height: 12),
            _FareRow(
              label: 'Remaining Due',
              amount: remainingDue,
              trailingNote: '($remainingDuration)',
              highlight: true,
            ),
          ] else ...[
            _FareRow(
              label: 'Trip Fare',
              amount: tripFare,
              trailingNote: '($tripDuration)',
            ),
            const SizedBox(height: 12),
            const _DashedDivider(),
            const SizedBox(height: 12),
            _FareRow(
              label: 'Extra Time',
              amount: extraTimeAmount,
              trailingNote: '($extraTimeDuration)',
              labelBold: true,
            ),
            const SizedBox(height: 12),
            const _DashedDivider(),
            const SizedBox(height: 12),
            _FareRow(
              label: 'Total Amount',
              amount: totalAmount,
              highlightBlue: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _FareRow extends StatelessWidget {
  final String label;
  final String amount;
  final String? trailingNote;
  final bool highlight;
  final bool highlightBlue;
  final bool labelBold;

  const _FareRow({
    required this.label,
    required this.amount,
    this.trailingNote,
    this.highlight = false,
    this.highlightBlue = false,
    this.labelBold = false,
  });

  static const _dueBrown = Color(0xFFB77728);

  @override
  Widget build(BuildContext context) {
    final labelStyle = highlightBlue
        ? kStyle(kSemiBold, kSize15, color: kTripCtaBlue)
        : highlight
            ? kStyle(kSemiBold, kSize15, color: _dueBrown)
            : labelBold
                ? kStyle(kSemiBold, kSize14, color: kTextColor)
                : kStyle(kRegular, kSize14, color: kTextColor);

    final noteStyle = kStyle(kRegular, kSize14, color: kTripMutedLabel);
    final amountStyle = highlightBlue
        ? kStyle(kSemiBold, kSize16, color: kTripCtaBlue)
        : highlight
            ? kStyle(kSemiBold, kSize16, color: _dueBrown)
            : kStyle(kSemiBold, kSize16, color: kTextColor);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: labelStyle,
              children: [
                TextSpan(text: label),
                if (trailingNote != null)
                  TextSpan(text: ' $trailingNote', style: noteStyle),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(amount, style: amountStyle),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 5.0;
        const dashSpace = 4.0;
        final dashCount =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor().clamp(1, 200);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: 1,
              color: const Color(0xFFD5D8E0),
            );
          }),
        );
      },
    );
  }
}
