import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/providers/nav_provider.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/trip_completed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TripScheduledPage extends ConsumerWidget {
  final DateTime scheduledAt;
  final String tripId;
  final String pickup;
  final String dropoff;
  final TripCompletedPaymentType paymentType;

  const TripScheduledPage({
    super.key,
    required this.scheduledAt,
    this.tripId = '#ID2562',
    this.pickup = 'Edappally, Lulu mall',
    this.dropoff = 'Infopark',
    this.paymentType = TripCompletedPaymentType.offline,
  });

  static final _scheduledDateTimeFormat = DateFormat('d MMMM • hh:mm a');

  void _goHome() {
    NavigationService().pushNamedAndRemoveUntil('navbar');
  }

  void _viewBooking(WidgetRef ref) {
    ref.read(selectedIndexProvider.notifier).updateIndex(1);
    NavigationService().pushNamedAndRemoveUntil('navbar');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduledLabel = _scheduledDateTimeFormat.format(scheduledAt);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Image.asset(
                'assets/pngs/trip_scheduled.png',
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: kBookingConfirmedTitleSB,
                  children: [
                    const TextSpan(text: 'Your Ride is '),
                    TextSpan(text: 'Scheduled!', style: kTripScheduledAccentSB),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Your booking has been confirmed for',
                textAlign: TextAlign.center,
                style: kTripScheduledBodyR,
              ),
              const SizedBox(height: 8),
              Text(
                scheduledLabel,
                textAlign: TextAlign.center,
                style: kTripScheduledDateB,
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "We'll assign your driver before pickup time and notify you once confirmed.",
                  textAlign: TextAlign.center,
                  style: kTripScheduledBodyR,
                ),
              ),
              const Spacer(flex: 3),
              primaryButton(
                label: 'View Booking',
                onPressed: () => _viewBooking(ref),
                buttonHeight: 56,
                fontSize: 16,
                buttonColor: kTripCtaBlue,
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _goHome,
                style: TextButton.styleFrom(
                  foregroundColor: kTripCtaBlue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('Back to Home', style: kTripScheduledLinkSB),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
