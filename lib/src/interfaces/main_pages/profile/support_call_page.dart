import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/utils/phone_launcher.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:flutter/material.dart';

const _kSupportTollFreePhone = '+916282359916';

class SupportCallPage extends StatelessWidget {
  const SupportCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kWhite,
        surfaceTintColor: kWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: kReferEarnPaddingH - 8),
          child: Center(
            child: _RoundBackButton(
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kReferEarnPaddingH,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/pngs/supportimage.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Need help booking a driver?',
                    textAlign: TextAlign.center,
                    style: kSupportCallTitleSB,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Call our team and get instant assistance.',
                    textAlign: TextAlign.center,
                    style: kSupportCallSubtitleR,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: kLineGrey),
          Padding(
            padding: EdgeInsets.fromLTRB(
              kReferEarnPaddingH,
              20,
              kReferEarnPaddingH,
              bottomInset > 0 ? bottomInset + 12 : 24,
            ),
            child: Column(
              children: [
                primaryButton(
                  label: 'Call Toll-Free Number',
                  onPressed: () => launchPhoneCall(_kSupportTollFreePhone),
                  buttonColor: kBrandBlue,
                  buttonHeight: 52,
                  fontSize: 15,
                  icon: Transform.rotate(
                    angle: -0.35,
                    child: const Icon(
                      Icons.phone_rounded,
                      color: kWhite,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Connect with our booking team instantly.',
                  textAlign: TextAlign.center,
                  style: kSupportCallFooterR,
                ),
              ],
            ),
          ),
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
      color: kReferBackBtnBg,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 40,
          height: 40,
          child: Icon(Icons.chevron_left_rounded, size: 26, color: kTextColor),
        ),
      ),
    );
  }
}
