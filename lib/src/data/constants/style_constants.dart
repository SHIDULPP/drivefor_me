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
