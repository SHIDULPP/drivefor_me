import 'dart:async';

import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/providers/nav_provider.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThankYouPage extends ConsumerStatefulWidget {
  const ThankYouPage({super.key});

  @override
  ConsumerState<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends ConsumerState<ThankYouPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        ref.read(selectedIndexProvider.notifier).updateIndex(0);
        NavigationService().resetToNavbar();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScreenBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Image.asset('assets/pngs/thank_you.png', fit: BoxFit.contain),
              const SizedBox(height: 40),
              Text(
                'Thank You!',
                textAlign: TextAlign.center,
                style: kBookingConfirmedTitleSB,
              ),
              const SizedBox(height: 16),
              Text(
                'Your rating helps us match you with better\ndrivers every time.',
                textAlign: TextAlign.center,
                style: kBookingConfirmedSubtitleR,
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
