import 'package:driveforme_user/src/data/providers/nav_provider.dart';
import 'package:driveforme_user/src/data/services/haptic_helper.dart';
import 'package:driveforme_user/src/interfaces/main_pages/home_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/profile_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _kBrandBlue = Color(0xFF04599C);
const _kInactiveGrey = Color(0xFF888888);

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
        backgroundColor: const Color(0xFFF2F4F7),
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

class _FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const _FloatingNavBar({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const double barHeight = 68;
    const double circleDiameter = 72;
    const double circleRadius = circleDiameter / 2;
    const double circleLift = 36;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: barHeight + circleLift + bottomInset,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              painter: _NotchBarPainter(
                selectedIndex: selectedIndex,
                itemCount: _navItems.length,
                notchRadius: circleRadius + 10,
                bottomPadding: bottomInset,
              ),
              child: SizedBox(height: barHeight + bottomInset),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomInset,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: isSelected ? circleLift + 6 : 8),
                        if (!isSelected) ...[
                          SvgPicture.asset(
                            item.inactiveIcon,
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontFamily: 'ClashGrotesk',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _kInactiveGrey,
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: circleDiameter - 8),
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontFamily: 'ClashGrotesk',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _kBrandBlue,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            bottom: bottomInset + barHeight - circleRadius - 6,
            left: _circleLeft(context, selectedIndex, circleRadius),
            child: GestureDetector(
              onTap: () => onTap(selectedIndex),
              child: _ActiveCircle(
                diameter: circleDiameter,
                icon: _navItems[selectedIndex].activeIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _circleLeft(BuildContext context, int index, double radius) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final itemWidth = screenWidth / _navItems.length;
    return itemWidth * index + itemWidth / 2 - radius;
  }
}

class _ActiveCircle extends StatelessWidget {
  final double diameter;
  final String icon;

  const _ActiveCircle({required this.diameter, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _kBrandBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(icon, width: 26, height: 26),
    );
  }
}

class _NotchBarPainter extends CustomPainter {
  final int selectedIndex;
  final int itemCount;
  final double notchRadius;
  final double bottomPadding;

  const _NotchBarPainter({
    required this.selectedIndex,
    required this.itemCount,
    required this.notchRadius,
    required this.bottomPadding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const bgColor = Colors.white;

    final paint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;

    final path = Path();

    final itemWidth = size.width / itemCount;
    final centerX = itemWidth * selectedIndex + itemWidth / 2;

    const cornerRadius = 34.0;

    final notchWidth = notchRadius * 2.4;
    const notchDepth = 50.0;

    path.moveTo(0, cornerRadius);

    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // LEFT SIDE BEFORE NOTCH
    path.lineTo(centerX - notchWidth, 0);

    // LEFT CURVE DOWN
    path.cubicTo(
      centerX - notchWidth + 25,
      0,
      centerX - notchWidth + 35,
      notchDepth,
      centerX,
      notchDepth,
    );

    // RIGHT CURVE UP
    path.cubicTo(
      centerX + notchWidth - 35,
      notchDepth,
      centerX + notchWidth - 25,
      0,
      centerX + notchWidth,
      0,
    );

    // TOP RIGHT
    path.lineTo(size.width - cornerRadius, 0);

    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // RIGHT SIDE
    path.lineTo(size.width, size.height);

    // BOTTOM
    path.lineTo(0, size.height);

    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.12), 16, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NotchBarPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}
