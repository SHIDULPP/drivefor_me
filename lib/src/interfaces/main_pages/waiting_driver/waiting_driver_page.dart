import 'dart:async';

import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/trip_completed.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum WaitingDriverStage {
  /// 1 — "Matching nearby drivers"
  matchingNearby,

  /// 2 — "Expanding search area..."
  expandingSearch,

  /// 3 — "We're matching the best driver for you"
  bestDriverMatch,
}

extension WaitingDriverStageX on WaitingDriverStage {
  double get progress {
    switch (this) {
      case WaitingDriverStage.matchingNearby:
        return 1 / 3;
      case WaitingDriverStage.expandingSearch:
        return 2 / 3;
      case WaitingDriverStage.bestDriverMatch:
        return 1.0;
    }
  }

  WaitingDriverStage? get next {
    switch (this) {
      case WaitingDriverStage.matchingNearby:
        return WaitingDriverStage.expandingSearch;
      case WaitingDriverStage.expandingSearch:
        return WaitingDriverStage.bestDriverMatch;
      case WaitingDriverStage.bestDriverMatch:
        return null;
    }
  }
}

class WaitingDriverPage extends StatefulWidget {
  final String tripTitle;
  final String tripId;
  final WaitingDriverStage initialStage;
  final TripCompletedPaymentType paymentType;

  const WaitingDriverPage({
    super.key,
    this.tripTitle = 'One Way Trip',
    this.tripId = '#ID2562',
    this.initialStage = WaitingDriverStage.matchingNearby,
    this.paymentType = TripCompletedPaymentType.offline,
  });

  @override
  State<WaitingDriverPage> createState() => _WaitingDriverPageState();
}

class _WaitingDriverPageState extends State<WaitingDriverPage>
    with SingleTickerProviderStateMixin {
  static const _stageDuration = Duration(seconds: 5);

  late WaitingDriverStage _stage;
  late AnimationController _progressController;
  Timer? _stageTimer;
  bool _navigatedToDriverFound = false;

  @override
  void initState() {
    super.initState();
    _stage = widget.initialStage;
    _progressController = AnimationController(
      vsync: this,
      duration: _stageDuration,
      value: 0,
    )..addStatusListener(_onProgressAnimationStatus);
    _runStage(_stage);
  }

  void _onProgressAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) return;
    if (_stage != WaitingDriverStage.bestDriverMatch) return;
    _goToDriverFound();
  }

  void _runStage(WaitingDriverStage stage) {
    _stageTimer?.cancel();
    setState(() => _stage = stage);

    _progressController.duration = _stageDuration;
    _progressController.animateTo(stage.progress, curve: Curves.easeOutCubic);

    final next = stage.next;
    if (next == null) return;

    _stageTimer = Timer(_stageDuration, () {
      if (!mounted) return;
      _runStage(next);
    });
  }

  void _goToDriverFound() {
    if (_navigatedToDriverFound || !mounted) return;
    _navigatedToDriverFound = true;
    _stageTimer?.cancel();
    _progressController.stop();
    NavigationService().pushNamedReplacement(
      'driver_found',
      arguments: {
        'tripTitle': widget.tripTitle,
        'tripId': widget.tripId,
        ...tripPaymentArguments(widget.paymentType),
      },
    );
  }

  @override
  void dispose() {
    _stageTimer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Column(
        children: [
          _WaitingDriverHeader(
            tripTitle: widget.tripTitle,
            tripId: widget.tripId,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/pngs/waiting_map.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                const Positioned(right: 20, bottom: 16, child: _HelpButton()),
              ],
            ),
          ),
          _WaitingDriverSheet(
            stage: _stage,
            progress: _progressController,
            onCancel: () => Navigator.of(context).maybePop(),
          ),
        ],
      ),
    );
  }
}

class _WaitingDriverHeader extends StatelessWidget {
  final String tripTitle;
  final String tripId;
  final VoidCallback onBack;

  const _WaitingDriverHeader({
    required this.tripTitle,
    required this.tripId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return ColoredBox(
      color: kWhite,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, topInset + 4, 12, 12),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 22,
                color: kTextColor,
              ),
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    tripTitle,
                    textAlign: TextAlign.center,
                    style: kWaitingDriverTripTitleSB,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tripId,
                    textAlign: TextAlign.center,
                    style: kWaitingDriverTripIdR,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.ios_share_outlined,
                size: 24,
                color: kTextColor,
              ),
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpButton extends StatelessWidget {
  const _HelpButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kWhite,
      elevation: 4,
      shadowColor: kBlack.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/svg/Help_image.svg',
                width: 22,
                height: 22,
              ),
              const SizedBox(width: 8),
              Text('Help', style: kWaitingDriverHelpM),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaitingDriverSheet extends StatelessWidget {
  final WaitingDriverStage stage;
  final Animation<double> progress;
  final VoidCallback onCancel;

  const _WaitingDriverSheet({
    required this.stage,
    required this.progress,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 24,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: AnimatedBuilder(
              animation: progress,
              builder: (context, _) {
                return LinearProgressIndicator(
                  value: progress.value,
                  minHeight: 4,
                  backgroundColor: kActiveGreenBg,
                  color: kActiveGreen,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 20, 24, bottomInset + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/pngs/finding_driver.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.08),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _StageCopy(key: ValueKey(stage), stage: stage),
                ),
                const SizedBox(height: 28),
                primaryButton(
                  label: 'Cancel Ride',
                  onPressed: onCancel,
                  buttonColor: kWhite,
                  sideColor: kRed,
                  labelColor: kRed,
                  fontSize: 16,
                  buttonHeight: 54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StageCopy extends StatelessWidget {
  final WaitingDriverStage stage;

  const _StageCopy({super.key, required this.stage});

  static const _description =
      'Your ride is confirmed , now contacting drivers nearby.';

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      mainAxisSize: MainAxisSize.min,
      children: [
        switch (stage) {
          WaitingDriverStage.matchingNearby => _buildMatchingNearbyHeadline(),
          WaitingDriverStage.expandingSearch => _buildExpandingSearchHeadline(),
          WaitingDriverStage.bestDriverMatch => _buildBestDriverMatchHeadline(),
        },
        const SizedBox(height: 12),
        Text(
          _description,
          textAlign: TextAlign.center,
          style: kWaitingDriverDescriptionR,
        ),
      ],
    );
  }

  Widget _buildMatchingNearbyHeadline() {
    return Column(
      children: [
        Text(
          'Finding your driver',
          textAlign: TextAlign.center,
          style: kWaitingDriverStatusBlueSB,
        ),
        const SizedBox(height: 6),
        Text(
          'Matching nearby drivers',
          textAlign: TextAlign.center,
          style: kWaitingDriverStatusBlackSB,
        ),
      ],
    );
  }

  Widget _buildExpandingSearchHeadline() {
    return Column(
      children: [
        Text(
          'Searching nearby drivers...',
          textAlign: TextAlign.center,
          style: kWaitingDriverStatusBlueSB,
        ),
        const SizedBox(height: 6),
        Text(
          'Expanding search area...',
          textAlign: TextAlign.center,
          style: kWaitingDriverStatusBlackSB,
        ),
      ],
    );
  }

  Widget _buildBestDriverMatchHeadline() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: kWaitingDriverHeadlineSB,
        children: [
          const TextSpan(text: "We're matching the\n"),
          TextSpan(
            text: 'best driver for you',
            style: kWaitingDriverHeadlineAccentSB,
          ),
        ],
      ),
    );
  }
}
