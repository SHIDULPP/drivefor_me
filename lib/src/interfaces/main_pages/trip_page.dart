import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: kScreenBg,
      body: Column(
        children: [
          ColoredBox(
            color: kBrandBlue,
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
                else if (_selectedTab == 1)
                  const _UpcomingTripCard()
                else if (_selectedTab == 2)
                  const _CompletedTripsList()
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
      color: kWhite,
      padding: const EdgeInsets.only(top: 4),
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
          Text(label, style: selected ? kTabLabelM : kTabLabelR),
          const SizedBox(height: 14),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: selected ? 52 : 0,
            decoration: BoxDecoration(
              color: kGoldAccent,
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
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kBlack.withValues(alpha: 0.06),
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
                background: kActiveGreenBg,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: kActiveGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text('Active Trip', style: kTripBadgeSB),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(
                background: kChipGreyBg,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_right_alt_rounded,
                      size: 18,
                      color: kBlack.withValues(alpha: 0.65),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'One Way',
                      style: kTripChipR.copyWith(
                        color: kBlack.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                size: 26,
                color: kBlack.withValues(alpha: 0.85),
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
                child: Text('₹ 235', style: kLabel22B),
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
                color: kBlack.withValues(alpha: 0.45),
              ),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  style: kCaption13R.copyWith(height: 1.3),
                  children: [
                    const TextSpan(text: 'Estimated arrival in '),
                    TextSpan(text: '10 min', style: kCaption13SB),
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
                color: kBlack.withValues(alpha: 0.45),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: kCaption12R.copyWith(height: 1.35),
                    children: [
                      const TextSpan(text: 'Today, '),
                      TextSpan(text: '01:15 PM', style: kCaption13SB),
                      const TextSpan(text: ' • 1 hrs 15 min • 12 km'),
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

class _CompletedTripsList extends StatelessWidget {
  const _CompletedTripsList();

  static Map<String, dynamic> _detailsArgs({required bool isLongTrip}) {
    if (isLongTrip) {
      return {
        'isLongTrip': true,
        'tripId': '# ID2562',
        'metaLine': '25 April to 28 April • 48 hrs 15 min • 122 km',
        'tripFare': '₹ 2,350',
        'tripFareDurationLabel': '48 hrs',
        'extraTimeFare': '₹ 320',
        'extraTimeDurationLabel': '2 hrs',
        'totalPaid': '₹ 2,670',
      };
    }
    return {
      'isLongTrip': false,
      'tripId': '# ID2562',
      'metaLine': '25 April • 1 hrs 15 min • 12 km',
      'tripFare': '₹ 235',
      'tripFareDurationLabel': '2 hrs',
      'extraTimeFare': '₹ 120',
      'extraTimeDurationLabel': '30 min',
      'totalPaid': '₹ 355',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CompletedTripCard(
          isLongTrip: false,
          price: '₹ 235',
          metaPrimary: '25 April',
          metaRest: ' • 1 hrs 15 min • 12 km',
          onViewDetails: () {
            NavigationService().pushNamed(
              'completed_trip_details',
              arguments: _detailsArgs(isLongTrip: false),
            );
          },
        ),
        const SizedBox(height: 16),
        _CompletedTripCard(
          isLongTrip: true,
          price: '₹ 2,350',
          metaPrimary: '25 April to 28 April',
          metaRest: ' • 48 hrs 15 min • 122 km',
          onViewDetails: () {
            NavigationService().pushNamed(
              'completed_trip_details',
              arguments: _detailsArgs(isLongTrip: true),
            );
          },
        ),
      ],
    );
  }
}

class _CompletedTripCard extends StatelessWidget {
  final bool isLongTrip;
  final String price;
  final String metaPrimary;
  final String metaRest;
  final VoidCallback onViewDetails;

  const _CompletedTripCard({
    required this.isLongTrip,
    required this.price,
    required this.metaPrimary,
    required this.metaRest,
    required this.onViewDetails,
  });

  static const _completedBg = Color(0xFFE8F1FA);
  static const _completedBlue = Color(0xFF165A91);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kBlack.withValues(alpha: 0.06),
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
                background: _completedBg,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: _completedBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 11, color: kWhite),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Completed',
                      style: kStyle(kSemiBold, kSize13, color: _completedBlue),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(
                background: kChipGreyBg,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: kBlack.withValues(alpha: 0.65),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isLongTrip ? 'LONG TRIP' : 'SHORT TRIP',
                      style: kTripChipR.copyWith(
                        color: kBlack.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                size: 26,
                color: kBlack.withValues(alpha: 0.85),
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
                child: Text(price, style: kLabel22B),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _DashedDivider(),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: kBlack.withValues(alpha: 0.45),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: kCaption13R.copyWith(height: 1.35),
                    children: [
                      TextSpan(text: metaPrimary, style: kCaption13SB),
                      TextSpan(text: metaRest),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _OutlinedTripAction(
                  label: 'View Details',
                  onTap: onViewDetails,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _OutlinedTripAction(
                  label: 'Download Invoice',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OutlinedTripAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _OutlinedTripAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kWhite,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kTripBorder),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kLabel15M.copyWith(color: kTextColor.withValues(alpha: 0.9)),
          ),
        ),
      ),
    );
  }
}

class _UpcomingTripCard extends StatelessWidget {
  const _UpcomingTripCard();

  static const _scheduledBg = Color(0xFFFFF4E8);
  static const _scheduledOrange = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kBlack.withValues(alpha: 0.06),
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
                background: _scheduledBg,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: _scheduledOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Scheduled',
                      style: kStyle(
                        kSemiBold,
                        kSize13,
                        color: _scheduledOrange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(
                background: kChipGreyBg,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.autorenew_rounded,
                      size: 18,
                      color: kBlack.withValues(alpha: 0.65),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Round Trip',
                      style: kTripChipR.copyWith(
                        color: kBlack.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.more_horiz_rounded,
                size: 26,
                color: kBlack.withValues(alpha: 0.85),
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
                child: Text('₹ 235', style: kLabel22B),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _DashedDivider(),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: kBlack.withValues(alpha: 0.45),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: kCaption13R.copyWith(height: 1.35),
                    children: [
                      TextSpan(text: 'Tomorrow, ', style: kCaption13SB),
                      const TextSpan(text: '09:00 AM • 1 hrs 15 min • 12 km'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: _DriverProfilePill()),
              const SizedBox(width: 10),
              _ViewBookingsButton(
                onPressed: () {
                  NavigationService().pushNamed(
                    'scheduled_trip_details',
                    arguments: {
                      'scheduledAt': DateTime.now().add(
                        const Duration(hours: 12, minutes: 20),
                      ),
                      'tripId': '# ID2562',
                      'pickup': 'Edappally, Lulu Mall',
                      'dropoff': 'Infopark, Kakkanad',
                      'paymentType': 'online',
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DriverProfilePill extends StatelessWidget {
  const _DriverProfilePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: kTripCreamBg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(
              'https://i.pravatar.cc/128?u=ajith_kumar_driver',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 32,
                height: 32,
                color: kTripDestIconBg,
                child: const Icon(
                  Icons.person,
                  size: 18,
                  color: kTripIconMuted,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Ajith Kumar',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: kLabel15M.copyWith(
                color: kTextColor.withValues(alpha: 0.9),
              ),
            ),
          ),
          const Icon(Icons.star_rounded, size: 16, color: kGoldAccent),
          const SizedBox(width: 2),
          Text('4.8', style: kCaption13SB),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: kBlack.withValues(alpha: 0.45),
          ),
        ],
      ),
    );
  }
}

class _ViewBookingsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ViewBookingsButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBrandBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Text('View Bookings', style: kTrackTripSB),
        ),
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
        const _RouteRow(
          icon: Icons.location_on_rounded,
          iconColor: kActiveGreen,
          label: 'Edappally, Lulu Mall',
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            width: 1.5,
            height: 22,
            margin: const EdgeInsets.symmetric(vertical: 2),
            color: kLineGrey,
          ),
        ),
        const _RouteRow(
          icon: Icons.location_on_rounded,
          iconColor: kDropBlue,
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
              style: kLabel15M.copyWith(
                color: kTextColor.withValues(alpha: 0.9),
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
      painter: _DashedLinePainter(color: kLineGrey),
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
      child: Center(child: Text('No $tab trips', style: kEmptyStateM)),
    );
  }
}

class _TrackTripButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _TrackTripButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kBrandBlue,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text('Track Trip', style: kTrackTripSB),
        ),
      ),
    );
  }
}
