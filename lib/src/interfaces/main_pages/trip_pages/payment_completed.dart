import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/models/trip_model.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:flutter/material.dart';

class PaymentCompletedPage extends StatelessWidget {
  final String paidAmount;
  final String tripMongoId;
  final String driverId;
  final String driverName;
  final double driverRating;
  final int driverTrips;
  final String? driverPhotoUrl;
  final String vehicleTypes;

  const PaymentCompletedPage({
    super.key,
    this.paidAmount = '—',
    this.tripMongoId = '',
    this.driverId = '',
    this.driverName = TripModel.noNameFound,
    this.driverRating = 0,
    this.driverTrips = 0,
    this.driverPhotoUrl,
    this.vehicleTypes = '',
  });

  void _onContinue() {
    NavigationService().pushNamedReplacement(
      'driver_rating',
      arguments: {
        'tripMongoId': tripMongoId,
        'driverId': driverId,
        'driverName': driverName,
        'driverRating': driverRating,
        'driverTrips': driverTrips,
        'driverPhotoUrl': driverPhotoUrl ?? '',
        'vehicleTypes': vehicleTypes,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: kScreenBg,
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, bottomInset + 16),
        child: primaryButton(
          label: 'Continue',
          onPressed: _onContinue,
          buttonColor: kTripCtaBlue,
          buttonHeight: 58,
          fontSize: 18,
        ),
      ),
    );
  }
}
