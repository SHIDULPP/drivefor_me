import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:flutter/material.dart';

// Clash Grotesk (Figma: Regular 400 / Medium 500 / Semibold 600 / Bold 700).
// Line-height is 120%. This app currently paints headings as Medium — legacy
// weight names alias so existing `kStyle(kSemiBold, …)` call sites are unchanged.

const String kFontFamily = 'ClashGrotesk';

const kRegular = FontWeight.w400;
const kMedium = FontWeight.w500;

const kLight = kRegular;
const kUltraLight = kRegular;
const kExtraLight = kRegular;
const kSemiBold = kMedium;
const kBold = kMedium;
const kExtraBold = kMedium;
const kBlackFont = kMedium;

const double kShortClose = -1.2;
const double kShort = -0.3;

// Figma type scale: Clash Grotesk/{size}/{weight}
// 10 · 12 · 14 · 16 · 18 · 20 · 24 · 30 · 36
const double kDisplay = 36;
const double kExtraLarge = 30;
const double kLarge = 24;
const double kHeading = 20;
const double kSubHeading = 18;
const double kBody = 16;

const double kSize10 = 10;
const double kSize11 = 11;
const double kSize12 = 12;
const double kSize13 = 13;
const double kSize14 = 14;
const double kSize15 = 15;
const double kSize16 = 16;
const double kSize17 = 17;
const double kSize18 = 18;
const double kSize20 = 20;
const double kSize22 = 22;
const double kSize24 = 24;
const double kSize25 = 25;
const double kSize26 = 26;
const double kSize28 = 28;
const double kSize30 = 30;
const double kSize32 = 32;
const double kSize36 = 36;

// Layout tokens (Figma iPhone 16 / 390pt frame)
const double kCardRadiusLg = 24;
const double kCardRadiusMd = 20;
const double kCardRadiusSm = 16;
const double kPillRadius = 30;
const double kScreenPaddingH = 16;
const double kReferEarnPaddingH = 20;

TextStyle kStyle(
  FontWeight weight,
  double size, {
  Color? color,
  double? letterSpacing,
  double? height,
}) {
  return TextStyle(
    fontFamily: kFontFamily,
    fontWeight: weight,
    color: color ?? kTextColor,
    fontSize: size,
    letterSpacing: letterSpacing,
    height: height ?? 1.2,
  );
}

// ================= SCALE (Figma sizes × Regular / Medium) =================

final kDisplayTitleR = kStyle(kRegular, kDisplay);
final kDisplayTitleM = kStyle(kMedium, kDisplay);
final kDisplayTitleSB = kDisplayTitleM;
final kDisplayTitleB = kDisplayTitleM;
final kDisplayTitleEB = kDisplayTitleM;

final kExtraLargeTitleM = kStyle(kMedium, kExtraLarge);
final kExtraLargeTitleR = kStyle(kRegular, kExtraLarge);
final kExtraLargeTitleSB = kExtraLargeTitleM;
final kExtraLargeTitleB = kExtraLargeTitleM;

final kLargeTitleR = kStyle(kRegular, kLarge);
final kLargeTitleM = kStyle(kMedium, kLarge);
final kLargeTitleSB = kLargeTitleM;
final kLargeTitleB = kLargeTitleM;
final kLargeTitleEB = kLargeTitleM;

final kHeadTitleM = kStyle(kMedium, kHeading);
final kHeadTitleSB = kHeadTitleM;
final kHeadTitleB = kHeadTitleM;
final kHeadTitleEB = kHeadTitleM;
// Login titles keep the existing 36 Regular call site (`kHeadTitleR`).
final kHeadTitleR = kDisplayTitleR;

final kSubHeadingR = kStyle(kRegular, kSubHeading);
final kSubHeadingM = kStyle(kMedium, kSubHeading);
final kSubHeadingL = kSubHeadingR;
final kSubHeadingSB = kSubHeadingM;
final kSubHeadingB = kSubHeadingM;
final kSubHeadingEB = kSubHeadingM;

final kBodyTitleR = kStyle(kRegular, kBody);
final kBodyTitleM = kStyle(kMedium, kBody);
final kBodyTitleL = kStyle(kRegular, kSize32);
final kBodyTitleSB = kBodyTitleM;
final kBodyTitleB = kBodyTitleM;
final kBodyTitleEB = kBodyTitleM;

final kSmallTitleR = kStyle(kRegular, kSize14);
final kSmallTitleM = kStyle(kMedium, kSize14);
final kSmallTitleL = kSmallTitleR;
final kSmallTitleUL = kSmallTitleR;
final kSmallTitleSB = kSmallTitleM;
final kSmallTitleB = kSmallTitleM;
final kSmallTitleEB = kSmallTitleM;

final kSmallerTitleR = kStyle(kRegular, kSize12);
final kSmallerTitleM = kStyle(kMedium, kSize12);
final kSmallerTitleL = kSmallerTitleR;
final kSmallerTitleEL = kSmallerTitleR;
final kSmallerTitleUL = kSmallerTitleR;
final kSmallerTitleSB = kSmallerTitleM;
final kSmallerTitleB = kSmallerTitleM;
final kSmallerTitleEB = kSmallerTitleM;

// ================= COMPACT UI =================

final kCaption11R = kStyle(kRegular, kSize11);
final kCaption12R = kStyle(kRegular, kSize12, color: kMutedText);
final kCaption13R = kStyle(kRegular, kSize13, color: kMutedText);
final kCaption13SB = kStyle(kMedium, kSize13);
final kCaption14R = kSmallTitleR;
final kCaption14M = kSmallTitleM;
final kCaption14B = kSmallTitleM;
final kCaption15M = kStyle(kMedium, kSize15, color: kMutedText);

final kLabel15M = kStyle(kMedium, kSize15, height: 1.25);
final kLabel17B = kStyle(kMedium, kSize17, height: 1.1);
final kLabel17BGold = kStyle(kMedium, kSize17, color: kGold, height: 1.1);
final kLabel22B = kStyle(kMedium, kSize22, color: kBrandBlue, height: 1.1);
final kLabel22White = kStyle(kMedium, kSize22, color: kWhite, height: 1.15);

final kTabLabelR = kCaption14R;
final kTabLabelM = kStyle(kMedium, kSize14, color: kGoldAccent);

final kNavLabelR = kCaption12R;
final kNavLabelM = kStyle(kMedium, kSize12, color: kBrandBlue);

final kEmptyStateM = kCaption15M;
final kVersionR = kCaption12R;
final kSectionLabelR = kCaption13R;
final kMenuItemM = kBodyTitleM;
final kMenuItemDangerM = kStyle(kMedium, kSize16, color: kRed);

// Watermark on Home — the only place that uses real Bold (700).
final kDecorTitleEB = kStyle(
  FontWeight.w700,
  kSize36,
  color: kDecorText,
  height: 1.02,
  letterSpacing: -0.8,
);

// ================= SCREEN ALIASES (existing call sites, same paint) =================

// Home / nav / trips list
final kTripBadgeSB = kStyle(kMedium, kSize13, color: kActiveGreen);
final kTripChipR = kStyle(kRegular, kSize13);
final kTrackTripSB = kStyle(kMedium, kSize14, color: kWhite, height: 1.1);
final kSupportTitleB = kStyle(kMedium, kSize17, color: kWhite);
final kSupportSubtitleR = kStyle(
  kRegular,
  kSize13,
  color: kWhite,
  height: 1.35,
);
final kPhoneNumberB = kStyle(kMedium, kSize14, height: 1.0);
final kPhoneSupportR = kStyle(kRegular, kSize11, height: 1.0);
final kFooterCaptionR = kStyle(kRegular, kSize13, height: 1.35);
final kFooterBrandB = kStyle(kMedium, kSize13, color: kBrandBlue);

// Profile
final kProfileNameB = kStyle(kMedium, kSize16, height: 1.15);
final kProfilePhoneR = kCaption13R;
final kQuickActionM = kCaption13SB;
final kEditProfileM = kStyle(kMedium, kSize14, color: kBrandBlue);
final kTripNotificationBodyR = kStyle(
  kRegular,
  kSize14,
  color: kTripBodyMuted,
  height: 1.45,
);
final kTripNotificationTimeM = kNavLabelM;

// Login
final kLoginSubtitleR = kStyle(
  kMedium,
  kSize14,
  color: kMutedText,
  height: 1.5,
);
final kLoginSubtitleAccentSB = kStyle(
  kMedium,
  kSize14,
  color: kBrandBlue,
  height: 1.5,
);
final kLoginPhoneFieldR = kStyle(kRegular, kSize25, color: kGreyDark);
final kLoginResendPromptM = kStyle(kMedium, kSize14, color: kMutedText);
final kLoginResendTimerSB = kEditProfileM;
final kLoginResendActionSB = kEditProfileM;

// Create trip
final kTripForPillM = kSmallTitleM;
final kTripSectionTitleSB = kSubHeadingM;
final kTripSubSectionSB = kSmallTitleM;
final kTripLocationLabelR = kStyle(kRegular, kSize12, color: kTripMutedLabel);
final kTripLocationValueM = kBodyTitleM;
final kTripTimePillM = kSmallTitleM;
final kTripSegmentActiveM = kStyle(kMedium, kSize14, color: kWhite);
final kTripSegmentInactiveM = kSmallTitleM;
final kTripVehicleAddM = kBodyTitleM;
final kTripDurationPriceB = kStyle(kMedium, kSize16, color: kBrandBlue);
final kTripDurationMetaR = kStyle(kRegular, kSize13, color: kTripBodyMuted);
final kTripChipDurationSB = kSmallTitleM;
final kTripChipHourB = kBodyTitleM;
final kTripChipHourMutedB = kStyle(kMedium, kSize16, color: kTripDarkText);
final kTripChipUnitM = kNavLabelM;
final kTripChipCustomM = kNavLabelM;
final kTripOvernightTitleSB = kStyle(kMedium, kSize13, height: 1.1);
final kTripOvernightSubR = kStyle(kRegular, kSize11, color: kTripMutedLabel);
final kTripWaitingNoteM = kStyle(kMedium, kSize12, color: kTripGold);
final kTripProtectionTitleSB = kSubHeadingM;
final kTripProtectionAddonB = kEditProfileM;
final kTripProtectionDescR = kStyle(kRegular, kSize13, color: kTripMutedLabel);
final kTripPaymentTitleSB = kBodyTitleM;
final kTripPaymentSubtitleR = kTripProtectionDescR;
final kTripPaymentPriceB = kStyle(kMedium, kSize18, color: kBrandBlue);
final kTripPaymentTrailingR = kTripProtectionDescR;
final kTripSecureBannerR = kStyle(kRegular, kSize12, color: kActiveGreen);
final kTripSecureBannerB = kStyle(kMedium, kSize12, color: kActiveGreen);
final kTripTotalLabelR = kTripProtectionDescR;
final kTripTotalPriceB = kStyle(
  kMedium,
  kSize26,
  color: kBrandBlue,
  height: 1.1,
);
final kTripModalTitleSB = kStyle(kMedium, kSize22);
final kTripModalSummaryR = kSmallTitleR;
final kTripModalSummaryB = kSmallTitleM;
final kTripPickerSelectedM = kTripPaymentPriceB;
final kTripPickerUnselectedM = kStyle(
  kMedium,
  kSize18,
  color: kTripPickerMuted,
);
final kTripModalButtonM = kStyle(kMedium, kSize16, color: kWhite);
final kTripStaySheetTitleSB = kSubHeadingM;
final kTripStayCounterB = kStyle(
  kMedium,
  kSize28,
  color: kTripStayCounter,
  height: 1.1,
);

// Booking confirmed / scheduled
final kBookingConfirmedTitleSB = kStyle(kMedium, kSize30, height: 1.15);
final kBookingConfirmedAccentSB = kStyle(
  kMedium,
  kSize30,
  color: kBrandBlue,
  height: 1.15,
);
final kBookingConfirmedSubtitleR = kStyle(
  kRegular,
  kSize16,
  color: kTripMutedLabel,
  height: 1.4,
);
final kTripScheduledAccentSB = kBookingConfirmedAccentSB;
final kTripScheduledDateB = kTripDurationPriceB;
final kTripScheduledBodyR = kStyle(
  kRegular,
  kSize15,
  color: kTripBodyMuted,
  height: 1.45,
);
final kTripScheduledLinkSB = kStyle(
  kMedium,
  kSize16,
  color: kBrandBlue,
  height: 1.1,
);

// Scheduled / completed / cancelled trip details
final kScheduledTripDateR = kStyle(kRegular, kSize14, color: kTripBodyMuted);
final kScheduledTripCountdownSB = kStyle(kMedium, kSize15, color: kActiveGreen);
final kScheduledTripStatLabelR = kStyle(
  kRegular,
  kSize12,
  color: kTripMutedLabel,
  height: 1.1,
);
final kScheduledTripStatValueSB = kStyle(kMedium, kSize16, height: 1.1);
final kScheduledTripRouteTitleSB = kStyle(kMedium, kSize15);
final kScheduledTripRouteSubtitleR = kStyle(
  kRegular,
  kSize12,
  color: kTripMutedLabel,
  height: 1.15,
);
final kScheduledTripSectionSB = kProfileNameB;
final kScheduledTripPaymentLabelR = kScheduledTripDateR;
final kScheduledTripPaymentValueSB = kSmallTitleM;
final kScheduledTripPaidSB = kStyle(kMedium, kSize14, color: kActiveGreen);
final kCompletedTripTotalLabelSB = kStyle(kMedium, kSize15, color: kBrandBlue);
final kCompletedTripTotalValueSB = kTripDurationPriceB;
final kCancelledRefundAmountSB = kStyle(kMedium, kSize16, color: kActiveGreen);
final kCancelledRefundDateSB = kTripBadgeSB;

// Waiting for driver
final kWaitingDriverTripTitleSB = kStyle(kMedium, kSize18, height: 1.15);
final kWaitingDriverTripIdR = kStyle(
  kRegular,
  kSize14,
  color: kTripMutedLabel,
  height: 1.15,
);
final kWaitingDriverHelpM = kStyle(kMedium, kSize15, height: 1.1);
final kWaitingDriverHeadlineSB = kStyle(kMedium, kSize22, height: 1.25);
final kWaitingDriverHeadlineAccentSB = kStyle(
  kMedium,
  kSize22,
  color: kBrandBlue,
  height: 1.25,
);
final kWaitingDriverStatusBlueSB = kStyle(kMedium, kSize20, color: kBrandBlue);
final kWaitingDriverStatusBlackSB = kStyle(kMedium, kSize24, height: 1.15);
final kWaitingDriverDescriptionR = kStyle(kRegular, kSize15, height: 1.4);

// Driver found
final kDriverFoundTitleSB = kWaitingDriverStatusBlackSB;
final kDriverFoundSubtitleR = kStyle(
  kRegular,
  kSize14,
  color: kMutedText,
  height: 1.3,
);
final kDriverFoundNameSB = kProfileNameB;
final kDriverFoundRatingM = kTripOvernightTitleSB;
final kDriverFoundMetaR = kCaption12R;
final kDriverFoundOtpTitleSB = kProfileNameB;
final kDriverFoundOtpDigitSB = kStyle(kMedium, kSize22, height: 1.0);
final kDriverFoundOtpHintR = kStyle(
  kRegular,
  kSize12,
  color: kMutedText,
  height: 1.3,
);
final kDriverFoundRouteSB = kStyle(kMedium, kSize14, height: 1.15);
final kDriverFoundPriceSB = kStyle(
  kMedium,
  kSize18,
  color: kBrandBlue,
  height: 1.1,
);
final kDriverFoundTripMetaR = kTripDurationMetaR;
final kDriverFoundSectionTitleSB = kScheduledTripRouteTitleSB;
final kDriverFoundPolicyR = kStyle(
  kRegular,
  kSize13,
  color: kMutedText,
  height: 1.45,
);
final kDriverFoundPolicyTimerSB = kStyle(
  kMedium,
  kSize13,
  color: kBrandBlue,
  height: 1.45,
);
final kDriverFoundLearnMoreM = kFooterBrandB;

// Driver rating
final kDriverRatingAppBarSB = kStyle(kMedium, kSize20, height: 1.15);
final kDriverRatingNameSB = kStyle(kMedium, kSize24, height: 1.1);
final kDriverRatingQuestionSB = kHeadTitleM;
final kDriverRatingStatR = kStyle(kRegular, kSize14, height: 1.15);
final kDriverRatingStatMutedR = kStyle(
  kRegular,
  kSize14,
  color: kMutedText,
  height: 1.15,
);
final kDriverRatingVehicleR = kCaption13R;
final kDriverRatingChipR = kStyle(kRegular, kSize15, height: 1.1);
final kDriverRatingCommentR = kStyle(kRegular, kSize15);
final kDriverRatingCommentHintR = kStyle(
  kRegular,
  kSize15,
  color: kTripMutedLabel,
);

// Refer & Earn / Wallet / Support call
final kReferEarnAppBarSB = kWaitingDriverTripTitleSB;
final kReferBannerTitleSB = kStyle(kMedium, kSize22, height: 1.15);
final kReferBannerTitleAccentSB = kStyle(
  kMedium,
  kSize22,
  color: kBlue,
  height: 1.15,
);
final kReferBannerSubtitleR = kDriverFoundPolicyR;
final kReferCodeLabelR = kCaption13R;
final kReferCodeValueM = kStyle(
  kMedium,
  kSize18,
  letterSpacing: 7,
  height: 1.0,
);
final kReferInviteButtonM = kStyle(
  kMedium,
  kSize16,
  color: kWhite,
  height: 1.1,
);
final kWalletAppBarSB = kWaitingDriverTripTitleSB;
final kWalletBalanceLabelR = kCaption13R;
final kWalletBalanceAmountSB = kStyle(
  kMedium,
  kSize32,
  color: kWalletBalanceGold,
  height: 1.05,
);
final kWalletSectionTitleSB = kProfileNameB;
final kWalletDateHeaderR = kCaption13R;
final kWalletTxTitleSB = kScheduledTripRouteTitleSB;
final kWalletTxSubtitleR = kStyle(
  kRegular,
  kSize12,
  color: kMutedText,
  height: 1.25,
);
final kWalletTxCreditSB = kStyle(
  kMedium,
  kSize15,
  color: kWalletCreditGreen,
  height: 1.1,
);
final kWalletTxDebitSB = kStyle(
  kMedium,
  kSize15,
  color: kWalletDebitRed,
  height: 1.1,
);
final kSupportCallTitleSB = kStyle(kMedium, kSize20, height: 1.25);
final kSupportCallSubtitleR = kStyle(
  kRegular,
  kSize14,
  color: kMutedText,
  height: 1.45,
);
final kSupportCallFooterR = kDriverFoundOtpHintR;
