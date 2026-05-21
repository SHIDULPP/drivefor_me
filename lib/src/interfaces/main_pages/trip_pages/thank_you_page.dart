import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:flutter/material.dart';

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

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
                'assets/pngs/thank_you.png',
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),
              Text(
                'Thank You!',
                textAlign: TextAlign.center,
                style: kBookingConfirmedTitleSB,
              ),
              const SizedBox(height: 16),
              Text(
                'Your rating helps us match you with better\ndrivers every time.',
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
