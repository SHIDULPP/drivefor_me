import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              /// title
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 26),

              /// profile card
              _buildProfileCard(),

              const SizedBox(height: 24),

              /// menu section
              _buildMenuSection(),

              const SizedBox(height: 24),

              /// partner section
              _buildPartnerSection(),

              const SizedBox(height: 40),

              /// logo + version
              _buildFooter(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= PROFILE CARD =================
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE4E4EA)),
      ),
      child: Row(
        children: [
          /// profile image
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: const AssetImage('assets/pngs/profile.png'),
          ),

          const SizedBox(width: 18),

          /// details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catherine',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                _infoRow(icon: Icons.call, text: '+91 6282359916'),

                const SizedBox(height: 6),

                _infoRow(icon: Icons.email, text: 'catheriene@gmail.com'),

                const SizedBox(height: 6),

                _infoRow(icon: Icons.calendar_month, text: 'DOB: 16/08/1997'),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// edit button
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: const Color(0xFF04599C),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF8C8C8C)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF8C8C8C),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  /// ================= MENU SECTION =================
  Widget _buildMenuSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE4E4EA)),
      ),
      child: Column(
        children: [
          _menuTile(title: 'Saved Addresses'),
          _divider(),
          _menuTile(title: 'My Vehicles'),
          _divider(),
          _menuTile(title: 'Notifications'),
          _divider(),
          _menuTile(title: 'Refer & Earn'),
          _divider(),
          _menuTile(title: 'About us'),
          _divider(),
          _menuTile(title: 'FAQ'),
          _divider(),
          _menuTile(
            title: 'Logout',
            textColor: Colors.red,
            iconColor: Colors.red,
          ),
        ],
      ),
    );
  }

  /// ================= PARTNER SECTION =================
  Widget _buildPartnerSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE4E4EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              "For Partner's",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFA0A0A0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          _menuTile(title: 'Join as Driver partner'),
          _divider(),
          _menuTile(title: 'B2B Enquiries'),
        ],
      ),
    );
  }

  /// ================= MENU TILE =================
  Widget _menuTile({
    required String title,
    Color textColor = Colors.black,
    Color iconColor = const Color(0xFF8E8E93),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),

          Icon(Icons.chevron_right, color: iconColor, size: 28),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
    );
  }

  /// ================= FOOTER =================
  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Image.asset('assets/pngs/drive_forme_logo.png', height: 40),

          const SizedBox(height: 8),

          const Text(
            'v4.625.100005',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8C8C8C),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
