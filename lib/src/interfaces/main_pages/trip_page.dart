import 'package:flutter/material.dart';

const _kScreenBg = Color(0xFFF2F4F7);
const _kBrandBlue = Color(0xFF04599C);
const _kTabGold = Color(0xFFC58A38);
const _kActiveGreen = Color(0xFF17A34A);
const _kActiveGreenBg = Color(0xFFE4F3E7);
const _kDropBlue = Color(0xFF0B5EA8);
const _kChipGreyBg = Color(0xFFF3F4EE);
const _kMutedText = Color(0xFF888888);
const _kLineGrey = Color(0xFFD8D8DE);

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  static const _tabs = ['Ongoing', 'Upcoming', 'Completed', 'Cancelled'];
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: _kScreenBg,
      body: Column(
        children: [
          ColoredBox(
            color: _kBrandBlue,
            child: SizedBox(height: topInset),
          ),
          _TripsTabBar(
            tabs: _tabs,
            selectedIndex: _selectedTab,
            onSelected: (i) => setState(() => _selectedTab = i),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                20,
                _navBarClearance(context),
              ),
              children: [
                if (_selectedTab == 0)
                  const _OngoingTripCard()
                else
                  _EmptyTripsMessage(tab: _tabs[_selectedTab]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _navBarClearance(BuildContext context) =>
      68 + 26 + MediaQuery.paddingOf(context).bottom + 16;
}

class _TripsTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _TripsTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 4, bottom: 0),
      child: Row(
        children: List.generate(tabs.length, (i) {
          return Expanded(
            child: _TabItem(
              label: tabs[i],
              selected: i == selectedIndex,
              onTap: () => onSelected(i),
            ),
          );
        }),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 14),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'ClashGrotesk',
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? _kTabGold : Colors.black,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: selected ? 52 : 0,
            decoration: BoxDecoration(
              color: _kTabGold,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _OngoingTripCard extends StatelessWidget {
  const _OngoingTripCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusChip(
                background: _kActiveGreenBg,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: _kActiveGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Active Trip',
                      style: TextStyle(
                        fontFamily: 'ClashGrotesk',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _kActiveGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(
                background: _kChipGreyBg,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_right_alt_rounded,
                      size: 18,
                      color: Colors.black.withValues(alpha: 0.65),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'One Way',
                      style: TextStyle(
                        fontFamily: 'ClashGrotesk',
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                size: 26,
                color: Colors.black.withValues(alpha: 0.85),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: _RouteStops()),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '₹ 235',
                  style: TextStyle(
                    fontFamily: 'ClashGrotesk',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _kBrandBlue,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _DashedDivider(),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 18,
                color: Colors.black.withValues(alpha: 0.45),
              ),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'ClashGrotesk',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: _kMutedText,
                    height: 1.3,
                  ),
                  children: const [
                    TextSpan(text: 'Estimated arrival in '),
                    TextSpan(
                      text: '10 min',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: Colors.black.withValues(alpha: 0.45),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'ClashGrotesk',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: _kMutedText,
                      height: 1.35,
                    ),
                    children: const [
                      TextSpan(text: 'Today, '),
                      TextSpan(
                        text: '01:15 PM',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(text: ' • 1 hrs 15 min • 12 km'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _TrackTripButton(onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final Color background;
  final Widget child;

  const _StatusChip({required this.background, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}

class _RouteStops extends StatelessWidget {
  const _RouteStops();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RouteRow(
          icon: Icons.location_on_rounded,
          iconColor: _kActiveGreen,
          label: 'Edappally, Lulu Mall',
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            width: 1.5,
            height: 22,
            margin: const EdgeInsets.symmetric(vertical: 2),
            color: _kLineGrey,
          ),
        ),
        _RouteRow(
          icon: Icons.location_on_rounded,
          iconColor: _kDropBlue,
          label: 'Infopark, Kakkanad',
        ),
      ],
    );
  }
}

class _RouteRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;

  const _RouteRow({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'ClashGrotesk',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black.withValues(alpha: 0.9),
                height: 1.25,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 1),
      painter: _DashedLinePainter(color: _kLineGrey),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EmptyTripsMessage extends StatelessWidget {
  final String tab;

  const _EmptyTripsMessage({required this.tab});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Center(
        child: Text(
          'No $tab trips',
          style: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: _kMutedText,
          ),
        ),
      ),
    );
  }
}

class _TrackTripButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _TrackTripButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _kBrandBlue,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Track Trip',
            style: TextStyle(
              fontFamily: 'ClashGrotesk',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
