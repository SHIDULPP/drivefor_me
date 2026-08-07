import 'package:driveforme_user/src/data/constants/app_colors.dart';
import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/providers/current_location_provider.dart';
import 'package:driveforme_user/src/data/providers/user_provider.dart';
import 'package:driveforme_user/src/data/providers/notification_provider.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:driveforme_user/src/data/utils/phone_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _kHomeSupportPhoneDisplay = '+91 75929 33933';
const _kHomeSupportPhoneDial = '+917592933933';

/// Nav bar body clearance: bar (64) + floating lift (32) + safe padding.
double _navBarClearance(BuildContext context) =>
    64 + 32 + MediaQuery.paddingOf(context).bottom + 12;

/// Responsive layout tokens scaled from a 390pt-wide Figma frame.
class _HomeLayout {
  _HomeLayout(double screenWidth)
    : horizontalPadding = screenWidth * (24 / 390),
      cardGap = screenWidth * (16 / 390),
      supportFooterGap = screenWidth * (52 / 390);

  final double horizontalPadding;
  final double cardGap;
  final double supportFooterGap;

  static _HomeLayout of(BuildContext context) =>
      _HomeLayout(MediaQuery.sizeOf(context).width);
}

class _SupportCardLayout {
  _SupportCardLayout(this.cardWidth);

  final double cardWidth;

  static const _figmaW = 342.0;

  double _s(double value) => cardWidth * (value / _figmaW);

  /// Figma card is 342 × 148.
  static const _figmaH = 158.0;

  double get aspectRatio => _figmaW / _figmaH;

  double get radius => _s(24);
  double get imageWidth => _s(110);
  double get imageRight => _s(4);
  double get imageVerticalInset => _s(0);
  double get contentPadTop => _s(16);
  double get contentPadLeft => _s(20);
  double get titleGap => _s(4);
  double get textPadRight => _s(80);
  double get pillBottomInset => 0;

  double get phonePadLeft => _s(14);
  double get phoneIconSize => _s(38);
  double get phoneIconGap => _s(10);
}

class _PhoneStripLayout {
  _PhoneStripLayout(this.cardWidth, this.cardLayout);

  final double cardWidth;
  final _SupportCardLayout cardLayout;

  double _s(double value) => cardWidth * (value / _SupportCardLayout._figmaW);

  double get padLeft => cardLayout.phonePadLeft;
  double get padRight => _s(20);
  double get padTop => _s(10);
  double get padBottom => _s(10);
  double get iconSize => cardLayout.phoneIconSize;
  double get iconGap => cardLayout.phoneIconGap;
  double get labelGap => _s(1);
  double get pillRadius => _s(50);
  double get borderWidth => _s(1.2);
}

class _DecorativeLayout {
  _DecorativeLayout(double screenWidth)
    : fontSize = (screenWidth * (36 / 390)).clamp(28.0, 42.0),
      letterSpacing = (screenWidth * (-0.8 / 390)).clamp(-1.2, -0.5),
      footerFontSize = (screenWidth * (12 / 390)).clamp(11.0, 14.0),
      horizontalPadding = screenWidth * (24 / 390),
      topPadding = screenWidth * (8 / 390);

  final double fontSize;
  final double letterSpacing;
  final double footerFontSize;
  final double horizontalPadding;
  final double topPadding;

  static _DecorativeLayout of(BuildContext context) =>
      _DecorativeLayout(MediaQuery.sizeOf(context).width);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: kScreenBg,
        body: SafeArea(
          bottom: false,
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: _navBarClearance(context)),
            child: Builder(
              builder: (context) {
                final layout = _HomeLayout.of(context);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _HeaderWithBookingCard(),
                    SizedBox(height: layout.cardGap),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: layout.horizontalPadding,
                      ),
                      child: const _SupportCard(),
                    ),
                    SizedBox(height: layout.supportFooterGap),
                    const _DecorativeFooter(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderWithBookingCard extends ConsumerWidget {
  const _HeaderWithBookingCard();

  static const _headerHeight = 208.0;
  static const _cardTop = 108.0;
  static const _stackHeight = 250.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topInset = MediaQuery.paddingOf(context).top;
    final layout = _HomeLayout.of(context);
    final cardTop = topInset + _cardTop;
    final userAsync = ref.watch(userProvider);
    final greeting = userAsync.when(
      data: (user) => 'Hii ${greetingFirstName(user)}!',
      loading: () => 'Hii there!',
      error: (_, _) => 'Hii there!',
    );

    final locationLabel = ref
        .watch(currentLocationProvider)
        .when(
          data: (location) => location?.displayLabel ?? 'Location unavailable',
          loading: () => 'Getting location...',
          error: (_, _) => 'Location unavailable',
        );

    return SizedBox(
      height: _stackHeight + topInset,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: _headerHeight + topInset,
            decoration: const BoxDecoration(
              color: kBrandBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              layout.horizontalPadding,
              topInset + 12,
              layout.horizontalPadding,
              0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(greeting, style: kLabel22White),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: kWhite,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              locationLabel,
                              style: kCaption14R.copyWith(
                                color: kWhite.withValues(alpha: 0.92),
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _NotificationBellButton(
                  unreadCount: ref.watch(unreadNotificationCountProvider),
                ),
              ],
            ),
          ),
          Positioned(
            left: layout.horizontalPadding,
            right: layout.horizontalPadding,
            top: cardTop,
            child: const _BookingCard(),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final radius = cardWidth * (20 / 342);
        final padH = cardWidth * (18 / 342);
        final padTop = cardWidth * (18 / 342);
        final padBottom = cardWidth * (16 / 342);
        final carHeight = cardWidth * (88 / 342);
        final searchHeight = cardWidth * (44 / 342);

        return Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: kBlack.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -cardWidth * (8 / 342),
                right: -cardWidth * (4 / 342),
                child: Container(
                  width: cardWidth * (140 / 342),
                  height: cardWidth * (140 / 342),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.cardGlowCream.withValues(alpha: 0.55),
                        kWhite.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  padH,
                  padTop,
                  cardWidth * (12 / 342),
                  padBottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        SizedBox(width: cardWidth * (72 / 342)),
                      ],
                    ),
                    SizedBox(height: cardWidth * (14 / 342)),
                    GestureDetector(
                      onTap: () {
                        NavigationService().pushNamed('create_trip');
                      },
                      child: Container(
                        height: searchHeight,
                        padding: EdgeInsets.symmetric(
                          horizontal: cardWidth * (16 / 342),
                        ),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: kGoldAccent, width: 1.2),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search_rounded,
                              size: cardWidth * (18 / 342),
                              color: kBlack.withValues(alpha: 0.65),
                            ),
                            SizedBox(width: cardWidth * (10 / 342)),
                            Text(
                              'Where to go?',
                              style: kCaption14R.copyWith(
                                color: kBlack.withValues(alpha: 0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: cardWidth * (4 / 342),
                top: cardWidth * (2 / 342),
                child: Image.asset(
                  'assets/pngs/car_driving.png',
                  height: carHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = _SupportCardLayout(constraints.maxWidth);

        return AspectRatio(
          aspectRatio: metrics.aspectRatio,
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: kBrandBlue,
              borderRadius: BorderRadius.circular(metrics.radius),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withValues(alpha: 0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        metrics.contentPadLeft,
                        metrics.contentPadTop,
                        metrics.textPadRight,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need help booking a driver?',
                            style: kSupportTitleB,
                          ),
                          SizedBox(height: metrics.titleGap),
                          Text(
                            'Call our team and get instant assistance.',
                            style: kSupportSubtitleR.copyWith(
                              color: kWhite.withValues(alpha: 0.95),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: _PhoneStrip(
                        cardWidth: constraints.maxWidth,
                        cardLayout: metrics,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                Positioned(
                  right: metrics.imageRight,
                  top: metrics.imageVerticalInset,
                  bottom: metrics.imageVerticalInset,
                  child: Image.asset(
                    'assets/pngs/support_headphone.png',
                    width: metrics.imageWidth,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PhoneStrip extends StatelessWidget {
  final double cardWidth;
  final _SupportCardLayout cardLayout;

  const _PhoneStrip({required this.cardWidth, required this.cardLayout});

  @override
  Widget build(BuildContext context) {
    final metrics = _PhoneStripLayout(cardWidth, cardLayout);
    final iconSize = metrics.iconSize;
    final borderWidth = metrics.borderWidth;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => launchPhoneCall(_kHomeSupportPhoneDial),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(metrics.pillRadius),
          bottomRight: Radius.circular(metrics.pillRadius),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            metrics.padLeft,
            metrics.padTop,
            metrics.padRight,
            metrics.padBottom,
          ),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(metrics.pillRadius),
              bottomRight: Radius.circular(metrics.pillRadius),
            ),
            border: Border(
              top: BorderSide(color: kGoldAccent, width: borderWidth),
              right: BorderSide(color: kGoldAccent, width: borderWidth),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: iconSize,
                width: iconSize,
                decoration: const BoxDecoration(
                  color: kGoldAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.call, color: kWhite, size: iconSize * 0.5),
              ),
              SizedBox(width: metrics.iconGap),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _kHomeSupportPhoneDisplay,
                    style: kPhoneNumberB,
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                  ),
                  SizedBox(height: metrics.labelGap),
                  Text(
                    '24/7 Support',
                    style: kPhoneSupportR.copyWith(
                      color: kBlack.withValues(alpha: 0.5),
                    ),
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecorativeFooter extends StatelessWidget {
  const _DecorativeFooter();

  @override
  Widget build(BuildContext context) {
    final metrics = _DecorativeLayout.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        metrics.horizontalPadding,
        metrics.topPadding,
        metrics.horizontalPadding,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'YOUR TRUSTED\nDRIVER,\nJUST A TAP AWAY!',
            textAlign: TextAlign.left,
            style: kDecorTitleEB.copyWith(
              fontSize: metrics.fontSize,
              letterSpacing: metrics.letterSpacing,
              height: 1.02,
              color: kDecorText,
            ),
          ),
          SizedBox(height: metrics.horizontalPadding * 0.5),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              style: kFooterCaptionR.copyWith(
                fontSize: metrics.footerFontSize,
                color: kBlack.withValues(alpha: 0.5),
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'Powered by '),
                TextSpan(
                  text: 'Skybertech',
                  style: kFooterBrandB.copyWith(
                    fontSize: metrics.footerFontSize,
                  ),
                ),
                const TextSpan(text: ' & Developed by '),
                TextSpan(
                  text: 'Xyvin Technologies',
                  style: kFooterBrandB.copyWith(
                    fontSize: metrics.footerFontSize,
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

class _NotificationBellButton extends StatelessWidget {
  final int unreadCount;

  const _NotificationBellButton({required this.unreadCount});

  static const _gif = 'assets/gifs/notification.gif';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => NavigationService().pushNamed('notifications'),
        customBorder: const CircleBorder(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: kNotificationCircleBg,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset(
                _gif,
                width: 22,
                height: 22,
                fit: BoxFit.contain,
                gaplessPlayback: true,
              ),
            ),
            if (unreadCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: const BoxDecoration(
                    color: kRed,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    unreadCount > 9 ? '9+' : '$unreadCount',
                    textAlign: TextAlign.center,
                    style: kStyle(kSemiBold, kSize10, color: kWhite),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
