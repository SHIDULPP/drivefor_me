import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:flutter/material.dart';

class PaymentCompletedPage extends StatelessWidget {
  final String paidAmount;

  const PaymentCompletedPage({
    super.key,
    this.paidAmount = '₹590',
  });

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
                'assets/pngs/payment_complet.png',
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: kBookingConfirmedTitleSB,
                  children: [
                    const TextSpan(text: 'Payment '),
                    TextSpan(
                      text: 'Completed!',
                      style: kBookingConfirmedAccentSB,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: kBookingConfirmedSubtitleR,
                  children: [
                    const TextSpan(text: 'Your payment '),
                    TextSpan(
                      text: paidAmount,
                      style: kStyle(kSemiBold, kSize16, color: kTextColor),
                    ),
                    const TextSpan(
                      text: ' has been received successfully.',
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
