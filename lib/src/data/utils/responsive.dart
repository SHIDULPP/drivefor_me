import 'package:flutter/material.dart';

/// Design reference width (logical px) used across the app.
const double kDesignWidth = 375;

/// Width scale factor clamped so layouts stay stable on very small/large phones.
double responsiveScale(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return (width / kDesignWidth).clamp(0.88, 1.12);
}

/// Scales a layout dimension (padding, height, icon size, etc.) to the screen width.
double responsiveSize(BuildContext context, double value) =>
    value * responsiveScale(context);

extension ResponsiveContext on BuildContext {
  double get scale => responsiveScale(this);

  double rs(double value) => responsiveSize(this, value);
}
