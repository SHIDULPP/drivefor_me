import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/providers/nav_provider.dart';
import 'package:driveforme_user/src/data/services/haptic_helper.dart';
import 'package:driveforme_user/src/interfaces/main_pages/home_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/profile_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ── Nav item model ────────────────────────────────────────────────────────────

class _NavItem {
  final String label;
  final String activeIcon;
  final String inactiveIcon;

  const _NavItem({
    required this.label,
    required this.activeIcon,
    required this.inactiveIcon,
  });
}

const _navItems = [
  _NavItem(
    label: 'Home',
    activeIcon: 'assets/svg/active_home_.svg',
    inactiveIcon: 'assets/svg/inactive_home.svg',
  ),
  _NavItem(
    label: 'Trips',
    activeIcon: 'assets/svg/active_trip.svg',
    inactiveIcon: 'assets/svg/inactive_trip.svg',
  ),
  _NavItem(
    label: 'Profile',
    activeIcon: 'assets/svg/active_profile.svg',
    inactiveIcon: 'assets/svg/inactive_profile.svg',
  ),
];

// ── NavBar widget ─────────────────────────────────────────────────────────────

class NavBar extends ConsumerStatefulWidget {
  const NavBar({super.key});

  @override
  ConsumerState<NavBar> createState() => _NavBarState();
}

class _NavBarState extends ConsumerState<NavBar> {
  final List<Widget> _pages = const [HomePage(), TripsPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    return PopScope(
      canPop: selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && selectedIndex != 0) {
          ref.read(selectedIndexProvider.notifier).updateIndex(0);
        }
      },
      child: Scaffold(
        backgroundColor: kWhite,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: KeyedSubtree(
            key: ValueKey(selectedIndex),
            child: _pages[selectedIndex],
          ),
        ),
        bottomNavigationBar: _FloatingNavBar(
          selectedIndex: selectedIndex,
          onTap: (i) {
            if (i != selectedIndex) {
              HapticHelper.impact(HapticImpact.light);
              ref.read(selectedIndexProvider.notifier).updateIndex(i);
            }
          },
        ),
      ),
    );
  }
}

// ── Floating nav bar with notch ───────────────────────────────────────────────

class _FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const _FloatingNavBar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Total bar height (visible white area) + extra for the floating circle
    const double barHeight = 72;
    const double circleRadius = 34;
    const double circleElevation = 28; // how far the circle floats above bar

    return SizedBox(
      height:
          barHeight + circleElevation + MediaQuery.of(context).padding.bottom,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── White bar with notch ──────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              painter: _NotchBarPainter(
                selectedIndex: selectedIndex,
                itemCount: _navItems.length,
                circleRadius: circleRadius + 6, // notch slightly wider
                bottomPadding: MediaQuery.of(context).padding.bottom,
              ),
              child: SizedBox(
                height: barHeight + MediaQuery.of(context).padding.bottom,
              ),
            ),
          ),

          // ── Inactive tap targets ──────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom,
            child: SizedBox(
              height: barHeight,
              child: Row(
                children: List.generate(_navItems.length, (i) {
                  final item = _navItems[i];
                  final isSelected = i == selectedIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(i),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Reserve space for the floating circle on active
                          SizedBox(height: isSelected ? circleElevation : 0),
                          if (!isSelected) ...[
                            SvgPicture.asset(
                              item.inactiveIcon,
                              width: 26,
                              height: 26,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF9CA3AF),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              style: const TextStyle(
                                fontFamily: 'ClashGrotesk',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ] else ...[
                            // Label below the floating circle
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              style: const TextStyle(
                                fontFamily: 'ClashGrotesk',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // ── Floating active circle ────────────────────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            bottom:
                MediaQuery.of(context).padding.bottom +
                barHeight -
                circleRadius -
                circleElevation +
                8,
            left: _circleLeft(context, selectedIndex, circleRadius),
            child: _ActiveCircle(
              radius: circleRadius,
              icon: _navItems[selectedIndex].activeIcon,
            ),
          ),
        ],
      ),
    );
  }

  double _circleLeft(BuildContext context, int index, double radius) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / _navItems.length;
    return itemWidth * index + itemWidth / 2 - radius;
  }
}

// ── Active floating circle ────────────────────────────────────────────────────

class _ActiveCircle extends StatelessWidget {
  final double radius;
  final String icon;

  const _ActiveCircle({required this.radius, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D2A4D).withValues(alpha: 0.55),
            blurRadius: 14,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: SvgPicture.asset(
          icon,
          width: radius * 0.9,
          height: radius * 0.9,
          colorFilter: const ColorFilter.mode(kWhite, BlendMode.srcIn),
        ),
      ),
    );
  }
}

// ── Custom painter for the notched white bar ──────────────────────────────────

class _NotchBarPainter extends CustomPainter {
  final int selectedIndex;
  final int itemCount;
  final double circleRadius;
  final double bottomPadding;

  const _NotchBarPainter({
    required this.selectedIndex,
    required this.itemCount,
    required this.circleRadius,
    required this.bottomPadding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kWhite
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final itemWidth = size.width / itemCount;
    final centerX = itemWidth * selectedIndex + itemWidth / 2;

    // Notch geometry
    const double notchDepth = 28.0;
    final double notchWidth = circleRadius * 2 + 16;
    final double notchLeft = centerX - notchWidth / 2;
    final double notchRight = centerX + notchWidth / 2;
    const double curveControl = 18.0;

    final path = Path();

    // Start top-left
    path.moveTo(0, 0);

    // Line to notch left approach
    path.lineTo(notchLeft - curveControl, 0);

    // Smooth curve down into notch
    path.cubicTo(notchLeft, 0, notchLeft, notchDepth, centerX, notchDepth);

    // Smooth curve back up from notch
    path.cubicTo(
      notchRight,
      notchDepth,
      notchRight,
      0,
      notchRight + curveControl,
      0,
    );

    // Line to top-right
    path.lineTo(size.width, 0);

    // Down the right side, bottom, left side
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw shadow first
    canvas.drawPath(path, shadowPaint);
    // Draw white fill
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_NotchBarPainter old) =>
      old.selectedIndex != selectedIndex;
}
