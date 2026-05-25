import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:flutter/material.dart';

/// Matches floating nav bar height: bar (68) + circle lift (36) + safe inset.
double _navBarClearance(BuildContext context) =>
    68 + 36 + MediaQuery.paddingOf(context).bottom;

const double _menuTileHeight = 48;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScreenBg,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, _navBarClearance(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ProfileHeaderCard(),
              const SizedBox(height: 8),
              const _QuickActionsRow(),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _MenuCard(
                        items: const [
                          'Personal Details',
                          'My Vehicles',
                          'Notifications',
                          'FAQ',
                        ],
                      ),
                      const SizedBox(height: 6),
                      const _PartnerMenuCard(),
                      const SizedBox(height: 6),
                      const _MenuCard(
                        items: ['Logout', 'Delete Account'],
                        dangerFromIndex: 0,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(child: Text('v4.625.100005', style: kVersionR)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: kBlack.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: kTertiary,
            backgroundImage: AssetImage('assets/pngs/profile.png'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Arun Kumar', style: kProfileNameB),
                Text('+91 6282359916', style: kProfilePhoneR),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const _EditProfileButton(),
        ],
      ),
    );
  }
}

class _EditProfileButton extends StatelessWidget {
  const _EditProfileButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => NavigationService().pushNamed('personal_details'),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: kBrandBlue, width: 1.1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Profile',
                style: kEditProfileM.copyWith(fontSize: kSize12),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.chevron_right, size: 18, color: kBrandBlue),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _QuickActionTile(
            label: 'Wallet',
            imagePath: 'assets/pngs/wallet_image.png',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _QuickActionTile(
            label: 'Refer & Earn',
            imagePath: 'assets/pngs/refferandearn_image.png',
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _QuickActionTile(
            label: 'Help',
            imagePath: 'assets/pngs/Help_image.png',
          ),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final String label;
  final String imagePath;

  const _QuickActionTile({
    required this.label,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kWhite,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: kBlack.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                width: 44,
                height: 44,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: kQuickActionM.copyWith(fontSize: kSize12),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<String> items;
  final int? dangerFromIndex;

  const _MenuCard({required this.items, this.dangerFromIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: kBlack.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const _MenuDivider(),
            SizedBox(
              height: _menuTileHeight,
              child: _MenuTile(
                title: items[i],
                isDanger: dangerFromIndex != null && i >= dangerFromIndex!,
                onTap: switch (items[i]) {
                  'Personal Details' => () =>
                      NavigationService().pushNamed('personal_details'),
                  'My Vehicles' => () =>
                      NavigationService().pushNamed('my_vehicles'),
                  'Notifications' => () =>
                      NavigationService().pushNamed('notifications'),
                  _ => null,
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PartnerMenuCard extends StatelessWidget {
  const _PartnerMenuCard();

  static const _items = ['Join as Driver partner', 'B2B Enquiries'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: kBlack.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Text('For Partners', style: kSectionLabelR),
          ),
          for (var i = 0; i < _items.length; i++) ...[
            if (i > 0) const _MenuDivider(),
            SizedBox(
              height: _menuTileHeight,
              child: _MenuTile(title: _items[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final String title;
  final bool isDanger;
  final VoidCallback? onTap;

  const _MenuTile({required this.title, this.isDanger = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: (isDanger ? kMenuItemDangerM : kMenuItemM).copyWith(
                    fontSize: kSize15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: kChevronGrey,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 1, thickness: 1, color: kLineGrey),
    );
  }
}
