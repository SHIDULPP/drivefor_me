import 'package:flutter/material.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(children: [_buildTripCard()]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= TOP TAB BAR =================
  Widget _buildTopBar() {
    return Container(
      height: 72,
      width: double.infinity,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _tabItem(title: 'Ongoing', selected: true),
          _tabItem(title: 'Upcoming'),
          _tabItem(title: 'Completed'),
          _tabItem(title: 'Cancelled'),
        ],
      ),
    );
  }

  Widget _tabItem({required String title, bool selected = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFFC58A38) : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 2,
          width: 90,
          color: selected ? const Color(0xFFC58A38) : Colors.transparent,
        ),
      ],
    );
  }

  /// ================= TRIP CARD =================
  Widget _buildTripCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// top chips
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F3E7),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(radius: 5, backgroundColor: Color(0xFF17A34A)),
                    SizedBox(width: 8),
                    Text(
                      'Active Trip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF17A34A),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4EE),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_right_alt, size: 24),
                    SizedBox(width: 6),
                    Text(
                      'One Way',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              const Icon(Icons.more_horiz, size: 30, color: Colors.black),
            ],
          ),

          const SizedBox(height: 28),

          /// location and price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _locationTile(
                      iconColor: const Color(0xFF17A34A),
                      title: 'Edappally, Lulu Mall',
                    ),
                    const SizedBox(height: 18),
                    _locationTile(
                      iconColor: const Color(0xFF0B5EA8),
                      title: 'Infopark, Kakkanad',
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '₹ 235',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0B5EA8),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(height: 1, color: const Color(0xFFE6E6EC)),

          const SizedBox(height: 22),

          /// arrival
          Row(
            children: [
              const Icon(
                Icons.access_time_filled,
                size: 20,
                color: Colors.black,
              ),
              const SizedBox(width: 12),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 15, color: Color(0xFF777777)),
                  children: [
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

          const SizedBox(height: 18),

          /// bottom row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      size: 20,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 12),

                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF888888),
                        ),
                        children: [
                          TextSpan(text: 'Today , '),
                          TextSpan(
                            text: '01:15 PM',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: '  •  1 hrs 15 min  •  12 km'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 22),
                decoration: BoxDecoration(
                  color: const Color(0xFF04599C),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Track Trip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationTile({required Color iconColor, required String title}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on, color: iconColor, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
