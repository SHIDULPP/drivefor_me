import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/trip_completed.dart';
import 'package:flutter/material.dart';

class BookingConfirmedPage extends StatefulWidget {
  final TripCompletedPaymentType paymentType;

  const BookingConfirmedPage({
    super.key,
    this.paymentType = TripCompletedPaymentType.offline,
  });

  @override
  State<BookingConfirmedPage> createState() => _BookingConfirmedPageState();
}

class _BookingConfirmedPageState extends State<BookingConfirmedPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _goToWaitingDriver);
  }

  void _goToWaitingDriver() {
    if (!mounted) return;
    NavigationService().pushNamedReplacement(
      'waiting_driver',
      arguments: {
        'tripTitle': 'One Way Trip',
        'tripId': '#ID2562',
        ...tripPaymentArguments(widget.paymentType),
      },
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
