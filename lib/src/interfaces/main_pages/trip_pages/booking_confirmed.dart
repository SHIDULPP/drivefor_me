import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/providers/active_trip_provider.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingConfirmedPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> waitingArgs;

  const BookingConfirmedPage({
    super.key,
    this.waitingArgs = const {},
  });

  String get tripMongoId => waitingArgs['tripMongoId'] as String? ?? '';

  @override
  ConsumerState<BookingConfirmedPage> createState() =>
      _BookingConfirmedPageState();
}

class _BookingConfirmedPageState extends ConsumerState<BookingConfirmedPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _goToWaitingDriver);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.tripMongoId.isNotEmpty) {
        ref
            .read(activeTripProvider.notifier)
            .setActiveTrip(widget.tripMongoId);
      }
    });
  }

  void _goToWaitingDriver() {
    if (!mounted) return;
    NavigationService().pushNamedReplacement(
      'waiting_driver',
      arguments: widget.waitingArgs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              Image.asset(
                'assets/pngs/booking_confirmed-removebg-preview.png',
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: kBookingConfirmedTitleSB,
                  children: [
                    const TextSpan(text: 'Booking '),
                    TextSpan(
                      text: 'Confirmed',
                      style: kBookingConfirmedAccentSB,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Your ride is confirmed and we’re getting the best driver for you.',
                textAlign: TextAlign.center,
                style: kBookingConfirmedSubtitleR,
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
