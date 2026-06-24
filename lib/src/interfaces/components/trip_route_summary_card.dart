import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:flutter/material.dart';

class TripRouteSummaryCard extends StatelessWidget {
  final String pickup;
  final String dropoff;
  final String price;
  final String distance;
  final String duration;

  const TripRouteSummaryCard({
    super.key,
    required this.pickup,
    required this.dropoff,
    required this.price,
    required this.distance,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kCardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: kActiveGreenBg,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          pickup,
                          style: kDriverFoundRouteSB,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: kActiveGreen,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          dropoff,
                          style: kDriverFoundRouteSB,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(price, style: kDriverFoundPriceSB),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(
              children: [
                _TripMetaRow(
                  icon: Icons.location_on_outlined,
                  label: 'Distance: $distance',
                ),
                const SizedBox(height: 6),
                _TripMetaRow(
                  icon: Icons.access_time_rounded,
                  label: 'Time Duration: $duration',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripMetaRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TripMetaRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: kTripIconMuted),
        const SizedBox(width: 6),
        Text(label, style: kDriverFoundTripMetaR),
      ],
    );
  }
}
