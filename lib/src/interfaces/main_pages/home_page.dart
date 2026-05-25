import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:flutter/material.dart';

/// Nav bar body clearance: bar (68) + floating lift (26) + safe padding.
double _navBarClearance(BuildContext context) =>
    68 + 26 + MediaQuery.paddingOf(context).bottom + 20;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScreenBg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: _navBarClearance(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _HeaderWithBookingCard(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: _SupportCard(),
              ),
              const SizedBox(height: 80),
              const _DecorativeFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderWithBookingCard extends StatelessWidget {
  const _HeaderWithBookingCard();

  static const _headerHeight = 220.0;
  static const _cardTop = 120.0;
  static const _stackHeight = 262.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _stackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: _headerHeight,
            decoration: const BoxDecoration(
              color: kBrandBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hii Catherine!', style: kLabel22White),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: kWhite,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Edappally, Lulu Mall',
                              style: kCaption14R.copyWith(
                                color: kWhite.withValues(alpha: 0.95),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: kWhite.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kBlack.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: kWhite,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 24,
            right: 24,
            top: _cardTop,
            child: _BookingCard(),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kBlack.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book Your',
                    style: kLabel17B.copyWith(color: kTextColor),
                  ),
                  Text('Personal Driver', style: kLabel17BGold),
                ],
              ),
              Expanded(
                child: Image.asset(
                  'assets/pngs/car_driving.png',
                  height: 72,
                  fit: BoxFit.contain,
                  alignment: Alignment.centerRight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              NavigationService().pushNamed('create_trip');
            },
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: kSearchFieldBg,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: kGoldAccent, width: 1.1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: kBlack.withValues(alpha: 0.45),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Where to go?',
                    style: kCaption14R.copyWith(
                      color: kBlack.withValues(alpha: 0.45),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard();

  static const _cardRadius = 24.0;

  @override
  Widget build(BuildContext context) {
    final responsiveHeight = MediaQuery.sizeOf(context).height * 0.25;

    return Container(
      constraints: BoxConstraints(minHeight: responsiveHeight),
      decoration: BoxDecoration(
        color: kBrandBlue,
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 24, 96, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Need help booking a driver?', style: kSupportTitleB),
                    const SizedBox(height: 6),
                    Text(
                      'Call our team and get instant assistance.',
                      style: kSupportSubtitleR.copyWith(
                        color: kWhite.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.bottomLeft,
                child: _PhoneStrip(),
              ),
            ],
          ),
          Positioned(
            right: 8,
            top: 8,
            bottom: 4,
            child: Image.asset(
              'assets/pngs/support_headphone.png',
              width: 92,
              fit: BoxFit.contain,
              alignment: Alignment.centerRight,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneStrip extends StatelessWidget {
  const _PhoneStrip();

  static const _pillRadius = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 9, 22, 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(_pillRadius),
          bottomRight: Radius.circular(_pillRadius),
        ),
        border: const Border(
          top: BorderSide(color: kGoldAccent, width: 1.2),
          right: BorderSide(color: kGoldAccent, width: 1.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: const BoxDecoration(
              color: kGoldAccent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.call, color: kWhite, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('+91 75929 33933', style: kPhoneNumberB),
              Text(
                '24/7 Support',
                style: kPhoneSupportR.copyWith(
                  color: kBlack.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DecorativeFooter extends StatelessWidget {
  const _DecorativeFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('YOUR TRUSTED\nDRIVER,\nJUST A TAP AWAY!', style: kDecorTitleEB),
          const SizedBox(height: 14),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: kFooterCaptionR.copyWith(
                  color: kBlack.withValues(alpha: 0.8),
                ),
                children: [
                  const TextSpan(text: 'Powered by '),
                  TextSpan(text: 'Skybertech', style: kFooterBrandB),
                  const TextSpan(text: ' & Developed by '),
                  TextSpan(text: 'Xyvin Technologies', style: kFooterBrandB),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
