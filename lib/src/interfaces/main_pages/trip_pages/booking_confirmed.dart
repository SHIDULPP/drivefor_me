import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:flutter/material.dart';

class BookingConfirmedPage extends StatelessWidget {
  const BookingConfirmedPage({super.key});

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
