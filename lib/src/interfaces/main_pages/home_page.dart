import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopSection(),
              const SizedBox(height: 20),
              _buildSupportCard(),
              const SizedBox(height: 40),
              _buildBottomText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 270,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF04599C),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hii Catherine!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Edappally, Lulu Mall',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        /// booking card
        Positioned(
          left: 24,
          right: 24,
          bottom: -70,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F5F5),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// text on the left
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Book Your',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Personal Driver',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFB77728),
                          ),
                        ),
                      ],
                    ),

                    /// car + driver image on the right
                    Expanded(
                      child: Image.asset(
                        'assets/pngs/car_driving.png',
                        height: 110,
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// search bar below
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5EF),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: const Color(0xFFC58A38),
                      width: 1.2,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, size: 26, color: Colors.black87),
                      SizedBox(width: 12),
                      Text(
                        'Where to go?',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: const Color(0xFF04599C),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Need help booking a driver?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Call our team and get instant assistance.',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  /// phone button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFFC58A38),
                          child: Icon(Icons.call, color: Colors.white),
                        ),
                        SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '+91 75929 33933',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '24/7 Support',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// replace with support image
            Image.asset('assets/pngs/support_headphone.png', height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'YOUR TRUSTED\nDRIVER,\nJUST A TAP AWAY!',
            style: TextStyle(
              fontSize: 48,
              height: 1,
              fontWeight: FontWeight.w900,
              color: Color(0xFFD8D8DD),
            ),
          ),
          const SizedBox(height: 18),
          RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 15),
              children: [
                TextSpan(text: 'Powered by '),
                TextSpan(
                  text: 'Skybertech',
                  style: TextStyle(
                    color: Color(0xFF04599C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' & Developed by '),
                TextSpan(
                  text: 'Xyvin Technologies',
                  style: TextStyle(
                    color: Color(0xFF04599C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
