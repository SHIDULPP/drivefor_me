import 'package:flutter/material.dart';

/// Figma design-system colors for DriveFORme (user app).
/// Single source of truth — do not hardcode colors in widgets.
abstract final class AppColors {
  // ── Brand blues ────────────────────────────────────────────────────────────
  static const primaryBlue = Color(0xFF154C8A);
  static const primaryBlueDark = Color(0xFF0F3D6B);
  static const primaryBlueLight = Color(0xFF3A66A1);
  static const secondaryBlue = Color(0xFF165A91);
  static const linkBlue = Color(0xFF2B74E1);

  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const scaffoldBackground = Color(0xFFF5F7FA);
  static const loginScreenBackground = Color(0xFFF9FBF4);
  static const profileScaffoldBackground = Color(0xFFF9FAF9);
  static const tripsScaffoldBackground = Color(0xFFF8FAFC);
  static const createTripScaffoldBackground = Color(0xFFF5F6FA);
  static const cardBackground = Color(0xFFFFFFFF);
  static const chipBackground = Color(0xFFF3F4EE);
  static const searchFieldBackground = Color(0xFFF4F5EF);
  static const inputBackground = Color(0xFFF5F5FA);
  static const tripCreamBackground = Color(0xFFF5F5EF);
  static const segmentTrackCream = Color(0xFFFAF7F2);
  static const segmentActiveBrown = Color(0xFFB37C3E);
  static const tripSelectedTint = Color(0xFFFFFDF9);
  static const tripSecureBannerBackground = Color(0xFFE6F3EA);
  static const tripCloseButtonBackground = Color(0xFFE2EAED);
  static const commentFieldBackground = Color(0xFFF4F5F8);
  static const tripSummaryCardBackground = Color(0xFFF6F7FB);
  static const progressWarningBackground = Color(0xFFF8F9F2);
  static const progressWarningBorder = Color(0xFFE6EADD);
  static const detailDivider = Color(0xFFE8ECF4);
  static const tripSummaryBorder = Color(0xFFE8E8E2);
  static const tripSummaryMutedBorder = Color(0xFFD5D8E0);
  static const searchFieldAltBackground = Color(0xFFF5F5F7);
  static const searchFieldAltText = Color(0xFF121223);
  static const riderSelectedBackground = Color(0xFFF7F8F2);
  static const splashGradientEnd = Color(0xFFF8F9FA);
  static const shimmerBase = Color(0xFFF3F4F6);

  // ── Accent / gold / orange ──────────────────────────────────────────────────
  static const accentOrange = Color(0xFFB87B4B);
  static const accentGold = Color(0xFFC58A38);
  static const tripGold = Color(0xFFC18131);
  static const starGold = Color(0xFFFFB400);
  static const ratingGold = Color(0xFFE8B923);
  static const cardGlowCream = Color(0xFFFFE8C8);
  static const selectedChipGold = Color(0xFFC5A358);
  static const tripHighlightGold = Color(0xFFCD9C3A);
  static const locationBrown = Color(0xFFB77728);
  static const scheduledTextOrange = Color(0xFFE67E22);
  static const warningAlertOrange = Color(0xFFCC7600);
  static const lightGreen = Color(0xFFC0FCC2);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const primaryText = Color(0xFF141414);
  static const secondaryText = Color(0xFF7E7E7E);
  static const mutedText = Color(0xFF7E7E7E);
  static const disabledText = Color(0xFF9C9C9C);
  static const tertiaryText = Color(0xFF6F6F6F);
  static const decorWatermark = Color(0xFFE0E0E0);
  static const onPrimaryText = Color(0xFFFFFFFF);
  static const tripDarkText = Color(0xFF222222);

  // ── Navigation ────────────────────────────────────────────────────────────
  static const navigationBackground = Color(0xFFFFFFFF);
  static const navigationActive = primaryBlue;
  static const navigationInactive = Color(0xFF8E8E93);

  // ── Borders / dividers ────────────────────────────────────────────────────
  static const border = Color(0xFFD8DADC);
  static const cardBorder = Color(0xFFE4E4EA);
  static const divider = Color(0xFFD8D8DE);
  static const inputBorder = Color(0xFFE8E8EF);
  static const tripBorder = Color(0xFFE2E2EC);
  static const stroke = Color(0xFF1E3C72);

  // ── Status ──────────────────────────────────────────────────────────────────
  static const successGreen = Color(0xFF17A34A);
  static const statusBadgeGreen = Color(0xFF27AE60);
  static const successGreenBackground = Color(0xFFE4F3E7);
  static const statusBadgeGreenBackground = Color(0xFFE8F5E9);
  static const chipGreyBackground = Color(0xFFF1F3F5);
  static const tabActiveTan = Color(0xFFC68E5F);
  static const tripPriceBlue = Color(0xFF2D5A96);
  static const errorRed = Color(0xFFE52022);
  static const errorRedDark = Color(0xFFC9300E);
  static const errorRedAlt = Color(0xFFE53935);
  static const warningOrange = Color(0xFFF59E0B);
  static const warningBackground = Color(0xFFFFF4E8);
  static const cancelledBackground = Color(0xFFFFEBEE);
  static const completedBackground = Color(0xFFE8F1FA);
  static const scheduledBackground = Color(0xFFFFF8E8);

  // ── Icons / misc UI ─────────────────────────────────────────────────────────
  static const iconMuted = Color(0xFFBDBDC7);
  static const iconInactive = Color(0xFF8E8E93);
  static const radioMuted = Color(0xFFAFAFB8);
  static const destinationIconBackground = Color(0xFFE7E7EF);
  static const pickerMuted = Color(0xFFC6C6CD);
  static const lineGrey = Color(0xFFD8D8DE);
  static const chevronGrey = Color(0xFF8E8E93);
  static const locationPinGreen = Color(0xFF39463D);

  // ── SOS ─────────────────────────────────────────────────────────────────────
  static const sosRed = Color(0xFFE32626);
  static const sosRedDark = Color(0xFF9B1F1F);
  static const sosCardBackground = Color(0xFFF9E6E6);
  static const sosScreenBackground = Color(0xFFF7F9F2);
  static const sosRefCardBackground = Color(0xFFFCE8E8);
  static const sosSupportIconBackground = Color(0xFFE8F0F8);

  // ── Neutrals ────────────────────────────────────────────────────────────────
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF050505);
  static const black54 = Color(0x8A000000);
  static const grey = Color(0xFFC8C8C8);
  static const greyLight = Color(0xFFCCCCCC);
  static const greyDark = Color(0xFF76797C);
  static const greyDarker = Color(0xFF585858);
  static const tertiarySurface = Color(0xFFE8EAED);

  // ── Overlays / shadows ──────────────────────────────────────────────────────
  static const shadowLight = Color(0x1A000000);
  static const shadowMedium = Color(0x14000000);
  static const notificationBadge = Color(0xFFE52022);
  static const notificationCircleBackground = Color(0x33FFFFFF);

  // ── Chat / misc surfaces ────────────────────────────────────────────────────
  static const chatBubbleMine = primaryBlue;
  static const chatBubbleOther = Color(0xFFF2F3F7);
  static const chatChipBackground = Color(0xFFF2F3F7);
  static const progressTrack = Color(0xFFE1E6EE);
  static const progressInactive = Color(0xFFF2F5FA);
  static const progressBorder = Color(0xFFDDE4F0);
  static const fillBlueGrey = Color(0xFFDDE6F0);

  // ── Refer & Earn (wallet) ───────────────────────────────────────────────────
  static const referBackButtonBackground = Color(0xFFF5F5F5);
  static const referBannerBackground = Color(0xFFFFF9F2);
  static const referBannerBorder = Color(0xFFC5A059);
  static const referCodeFieldBackground = Color(0xFFFFFBF5);
  static const referDashedBorder = Color(0xFFC5A059);
}
