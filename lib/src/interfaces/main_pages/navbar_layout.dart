import 'package:flutter/material.dart';

/// Responsive nav metrics scaled from a 390pt-wide Figma frame.
class NavBarMetrics {
  NavBarMetrics(this.width, this.bottomInset);

  final double width;
  final double bottomInset;

  factory NavBarMetrics.of(BuildContext context) {
    return NavBarMetrics(
      MediaQuery.sizeOf(context).width,
      MediaQuery.paddingOf(context).bottom,
    );
  }

  double _s(double value) => width * (value / 390);

  double get horizontalInset => _s(20);
  double get bottomGap => _s(18);
  double get barHeight => _s(54);
  double get barRadius => barHeight / 2;
  double get barPaddingH => _s(8);
  double get barPaddingV => _s(6);
  double get activePillHeight => _s(42);
  double get activePillRadius => activePillHeight / 2;
  double get activePillPaddingH => _s(14);
  double get activeIconSize => _s(22);
  double get activeIconGap => _s(8);
  double get inactiveIconSize => _s(24);
  double get clearanceExtra => _s(14);

  double get clearance => barHeight + bottomGap + clearanceExtra + bottomInset;
}

/// Bottom scroll padding for tab pages so content clears the floating nav bar.
double floatingNavBarClearance(BuildContext context) {
  return NavBarMetrics.of(context).clearance;
}
