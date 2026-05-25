import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:flutter/material.dart';

class _NotificationItem {
  final String title;
  final String body;
  final String timeAgo;

  const _NotificationItem({
    required this.title,
    required this.body,
    required this.timeAgo,
  });
}

class _NotificationSection {
  final String dateLabel;
  final List<_NotificationItem> items;

  const _NotificationSection({
    required this.dateLabel,
    required this.items,
  });
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const _sections = [
    _NotificationSection(
      dateLabel: 'Sat, 10 Mar',
      items: [
        _NotificationItem(
          title: 'Please update Membership',
          body:
              'Your membership plan has expired. Renew now to continue enjoying premium features and uninterrupted access.',
          timeAgo: '3 hours ago',
        ),
        _NotificationItem(
          title: 'New Offer Available',
          body:
              'Get 20% off on your annual subscription if you upgrade today. Limited-time offer!',
          timeAgo: '3 hours ago',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        surfaceTintColor: kWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Align(
            alignment: Alignment.center,
            child: _RoundBackButton(
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
        title: Text(
          'Notifications',
          style: kStyle(kSemiBold, kSize18, color: kBrandBlue),
        ),
      ),
      body: ListView(
        children: [
          for (final section in _sections) ...[
            _DateHeader(label: section.dateLabel),
            for (var i = 0; i < section.items.length; i++) ...[
              _NotificationTile(item: section.items[i]),
              if (i < section.items.length - 1)
                const Divider(height: 1, thickness: 1, color: kLineGrey),
            ],
          ],
        ],
      ),
    );
  }
}

class _RoundBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _RoundBackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kChipGreyBg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: kTextColor,
          ),
        ),
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String label;

  const _DateHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: kScreenBg,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Text(
        label,
        style: kStyle(kRegular, kSize14, color: kTripBodyMuted, height: 1.2),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final _NotificationItem item;

  const _NotificationTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: kBrandBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: kStyle(
                        kSemiBold,
                        kSize16,
                        color: kBrandBlue,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.body,
                      style: kTripNotificationBodyR,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              item.timeAgo,
              style: kTripNotificationTimeM,
            ),
          ),
        ],
      ),
    );
  }
}
