import 'package:flutter/material.dart';

const _kScreenBg = Color(0xFFF2F4F7);
const _kBrandBlue = Color(0xFF04599C);
const _kGold = Color(0xFFB77728);
const _kGoldBorder = Color(0xFFC58A38);
const _kCallGold = Color(0xFFC58A38);
const _kDecorText = Color(0xFFD8D8DD);

/// Nav bar body clearance: bar (68) + floating lift (26) + safe padding.
double _navBarClearance(BuildContext context) =>
    68 + 26 + MediaQuery.paddingOf(context).bottom + 20;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kScreenBg,
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
  // cardTop + booking card (~158) + small buffer
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
              color: _kBrandBlue,
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
                      Text(
                        'Hii Catherine!',
                        style: TextStyle(
                          fontFamily: 'ClashGrotesk',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Edappally, Lulu Mall',
                              style: TextStyle(
                                fontFamily: 'ClashGrotesk',
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withValues(alpha: 0.95),
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
                    color: Colors.white.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
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
                    style: TextStyle(
                      fontFamily: 'ClashGrotesk',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'Personal Driver',
                    style: TextStyle(
                      fontFamily: 'ClashGrotesk',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: _kGold,
                      height: 1.1,
                    ),
                  ),
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
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5EF),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: _kGoldBorder, width: 1.1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: Colors.black.withValues(alpha: 0.45),
                ),
                const SizedBox(width: 10),
                Text(
                  'Where to go?',
                  style: TextStyle(
                    fontFamily: 'ClashGrotesk',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withValues(alpha: 0.45),
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

class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: _kBrandBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 96, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Need help booking a driver?',
                  style: TextStyle(
                    fontFamily: 'ClashGrotesk',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Call our team and get instant assistance.',
                  style: TextStyle(
                    fontFamily: 'ClashGrotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.88),
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 24),
                _PhonePill(),
              ],
            ),
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

class _PhonePill extends StatelessWidget {
  const _PhonePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 7, 14, 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 34,
            width: 34,
            decoration: const BoxDecoration(
              color: _kCallGold,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.call, color: Colors.white, size: 17),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '+91 75929 33933',
                style: TextStyle(
                  fontFamily: 'ClashGrotesk',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Colors.black,
                  height: 1.15,
                ),
              ),
              Text(
                '24/7 Support',
                style: TextStyle(
                  fontFamily: 'ClashGrotesk',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withValues(alpha: 0.55),
                  height: 1.15,
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'YOUR TRUSTED\nDRIVER,\nJUST A TAP AWAY!',
            style: TextStyle(
              fontFamily: 'ClashGrotesk',
              fontSize: 36,
              height: 1.05,
              fontWeight: FontWeight.w900,
              color: _kDecorText,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'ClashGrotesk',
                  color: Colors.black.withValues(alpha: 0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                ),
                children: const [
                  TextSpan(text: 'Powered by '),
                  TextSpan(
                    text: 'Skybertech',
                    style: TextStyle(
                      color: _kBrandBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: ' & Developed by '),
                  TextSpan(
                    text: 'Xyvin Technologies',
                    style: TextStyle(
                      color: _kBrandBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
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
