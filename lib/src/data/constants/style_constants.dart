import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:flutter/material.dart';

// ================= FONT WEIGHTS =================

// Clash Grotesk works best with these mappings

const kExtraLight = FontWeight.w200;
const kUltraLight = FontWeight.w300;
const kLight = FontWeight.w400;
const kRegular = FontWeight.w500;
const kMedium = FontWeight.w600;
const kSemiBold = FontWeight.w700;
const kBold = FontWeight.w800;
const kExtraBold = FontWeight.w900;
const kBlackFont = FontWeight.w900;

// ================= LETTER SPACING =================

const double kShortClose = -1.2;
const double kShort = -0.3;

// ================= FONT SIZES =================

const double kDisplay = 44;
const double kExtraLarge = 40;
const double kLarge = 38;
const double kHeading = 36;
const double kSubHeading = 18;
const double kBody = 32;
const double kSize30 = 30;
const double kSize28 = 28;
const double kSize11 = 11;
const double kSize12 = 12;
const double kSize13 = 13;
const double kSize14 = 14;
const double kSize15 = 15;
const double kSize17 = 17;
const double kSize22 = 22;
const double kSize34 = 34;
const double kSize36 = 36;

// ================= BASE STYLE =================

TextStyle kStyle(
  FontWeight weight,
  double size, {
  Color? color,
  double? letterSpacing,
  double? height,
}) {
  return TextStyle(
    fontFamily: 'ClashGrotesk',
    fontWeight: weight,
    color: color ?? kTextColor,
    fontSize: size,
    letterSpacing: letterSpacing,
    height: height ?? 1.2,
  );
}

// ================= DISPLAY =================

final kDisplayTitleR = kStyle(kRegular, kDisplay);
final kDisplayTitleM = kStyle(kMedium, kDisplay);
final kDisplayTitleSB = kStyle(kSemiBold, kDisplay);
final kDisplayTitleB = kStyle(kBold, kDisplay);
final kDisplayTitleEB = kStyle(kExtraBold, kDisplay);

// ================= LARGE =================

final kLargeTitleR = kStyle(kRegular, kLarge);
final kLargeTitleM = kStyle(kMedium, kLarge);
final kExtraLargeTitleM = kStyle(kMedium, kExtraLarge);
final kLargeTitleSB = kStyle(kSemiBold, kLarge);
final kLargeTitleB = kStyle(kBold, kLarge);
final kLargeTitleEB = kStyle(kExtraBold, kLarge);

// ================= HEADING =================

final kHeadTitleR = kStyle(kRegular, kHeading);
final kHeadTitleM = kStyle(kMedium, kHeading);
final kHeadTitleSB = kStyle(kSemiBold, kHeading);
final kHeadTitleB = kStyle(kBold, kHeading);
final kHeadTitleEB = kStyle(kExtraBold, kHeading);

// ================= SUBHEADING =================

final kSubHeadingL = kStyle(kLight, kSubHeading);
final kSubHeadingR = kStyle(kRegular, kSubHeading);
final kSubHeadingM = kStyle(kMedium, kSubHeading);
final kSubHeadingSB = kStyle(kSemiBold, kSubHeading);
final kSubHeadingB = kStyle(kBold, kSubHeading);
final kSubHeadingEB = kStyle(kExtraBold, kSubHeading);

// ================= BODY =================

final kBodyTitleL = kStyle(kLight, kBody);
final kBodyTitleR = kStyle(kRegular, kBody);
final kBodyTitleM = kStyle(kMedium, kBody);
final kBodyTitleSB = kStyle(kSemiBold, kBody);
final kBodyTitleB = kStyle(kBold, kBody);
final kBodyTitleEB = kStyle(kExtraBold, kBody);

// ================= SMALL =================

final kSmallTitleUL = kStyle(kUltraLight, kSize30);
final kSmallTitleL = kStyle(kLight, kSize30);
final kSmallTitleR = kStyle(kRegular, kSize30);
final kSmallTitleM = kStyle(kMedium, kSize30);
final kSmallTitleSB = kStyle(kSemiBold, kSize30);
final kSmallTitleB = kStyle(kBold, kSize30);
final kSmallTitleEB = kStyle(kExtraBold, kSize30);

// ================= SMALLER =================

final kSmallerTitleEL = kStyle(kExtraLight, kSize28);
final kSmallerTitleUL = kStyle(kUltraLight, kSize28);
final kSmallerTitleL = kStyle(kLight, kSize28);
final kSmallerTitleR = kStyle(kRegular, kSize28);
final kSmallerTitleRWithGradient = kStyle(kRegular, kSize28);
final kSmallerTitleM = kStyle(kMedium, kSize28);
final kSmallerTitleSB = kStyle(kSemiBold, kSize28);
final kSmallerTitleB = kStyle(kBold, kSize28);
final kSmallerTitleEB = kStyle(kExtraBold, kSize28);

// ── Compact UI (home, trips, bottom nav) ──────────────────────────────────────

final kCaption11R = kStyle(kRegular, kSize11);
final kCaption12R = kStyle(kRegular, kSize12, color: kMutedText);
final kCaption13R = kStyle(kRegular, kSize13, color: kMutedText);
final kCaption13SB = kStyle(kSemiBold, kSize13, color: kTextColor);
final kCaption14R = kStyle(kRegular, kSize14);
final kCaption14M = kStyle(kMedium, kSize14);
final kCaption14B = kStyle(kSemiBold, kSize14, color: kTextColor);
final kCaption15M = kStyle(kMedium, kSize15, color: kMutedText);

final kLabel15M = kStyle(kMedium, kSize15, color: kTextColor, height: 1.25);
final kLabel17B = kStyle(kSemiBold, kSize17, height: 1.1);
final kLabel17BGold = kStyle(kSemiBold, kSize17, color: kGold, height: 1.1);
final kLabel22B = kStyle(kSemiBold, kSize22, color: kBrandBlue, height: 1.1);
final kLabel22White = kStyle(kSemiBold, kSize22, color: kWhite, height: 1.15);

final kTabLabelR = kStyle(kRegular, kSize14, color: kTextColor);
final kTabLabelM = kStyle(kMedium, kSize14, color: kGoldAccent);

final kNavLabelR = kStyle(kRegular, kSize12, color: kMutedText);
final kNavLabelM = kStyle(kMedium, kSize12, color: kBrandBlue);

final kTripBadgeSB = kStyle(kSemiBold, kSize13, color: kActiveGreen);
final kTripChipR = kStyle(kRegular, kSize13);
final kTrackTripSB = kStyle(kSemiBold, kSize14, color: kWhite, height: 1.1);

final kSupportTitleB = kStyle(kSemiBold, kSize17, color: kWhite, height: 1.2);
final kSupportSubtitleR = kStyle(kRegular, kSize12, color: kWhite, height: 1.3);
final kPhoneNumberB = kStyle(
  kSemiBold,
  kSize14,
  color: kTextColor,
  height: 1.15,
);
final kPhoneSupportR = kStyle(kRegular, kSize11, height: 1.15);

final kDecorTitleEB = kStyle(
  kExtraBold,
  kSize36,
  color: kDecorText,
  height: 1.05,
  letterSpacing: -0.3,
);
final kFooterCaptionR = kStyle(kRegular, kSize13, height: 1.35);
final kFooterBrandB = kStyle(kSemiBold, kSize13, color: kBrandBlue);

final kEmptyStateM = kStyle(kMedium, kSize15, color: kMutedText);
