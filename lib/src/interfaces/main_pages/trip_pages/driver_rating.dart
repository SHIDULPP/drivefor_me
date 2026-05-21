import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/thank_you_page.dart';
import 'package:flutter/material.dart';

class DriverRatingPage extends StatefulWidget {
  final String driverName;
  final double driverRating;
  final int driverTrips;
  final String vehicleTypes;

  const DriverRatingPage({
    super.key,
    this.driverName = 'Ajith Kumar',
    this.driverRating = 4.8,
    this.driverTrips = 120,
    this.vehicleTypes = 'Manual + Auto',
  });

  @override
  State<DriverRatingPage> createState() => _DriverRatingPageState();
}

class _DriverRatingPageState extends State<DriverRatingPage> {
  static const _chipSelectedBorder = Color(0xFFC5A358);
  static const _commentFieldBg = Color(0xFFF4F5F8);
  static const _smileyBlue = Color(0xFF2B74E1);

  static const _feedbackTags = [
    'Excellent Service',
    'Friendly Driver',
    'Well Maintained Car',
    'Clean & Comfortable',
  ];

  int _selectedRating = 1;
  final Set<String> _selectedTags = {'Excellent Service'};
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ThankYouPage(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RatingHeader(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DriverProfileCard(
                      driverName: widget.driverName,
                      driverRating: widget.driverRating,
                      driverTrips: widget.driverTrips,
                      vehicleTypes: widget.vehicleTypes,
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1, color: kCardBorder),
                    const SizedBox(height: 28),
                    Text(
                      'How was your ride?',
                      textAlign: TextAlign.center,
                      style: kDriverRatingQuestionSB,
                    ),
                    const SizedBox(height: 20),
                    _RatingStars(
                      rating: _selectedRating,
                      onRatingChanged: (value) {
                        setState(() => _selectedRating = value);
                      },
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: _feedbackTags.map((tag) {
                        final isSelected = _selectedTags.contains(tag);
                        return _FeedbackChip(
                          label: tag,
                          isSelected: isSelected,
                          selectedBorderColor: _chipSelectedBorder,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedTags.remove(tag);
                              } else {
                                _selectedTags.add(tag);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    _CommentField(
                      controller: _commentController,
                      backgroundColor: _commentFieldBg,
                      smileyColor: _smileyBlue,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 16),
              child: primaryButton(
                label: 'Submit Rating',
                onPressed: () {
                  NavigationService().pushNamedReplacement('thank_you');
                },
                buttonColor: kTripCtaBlue,
                buttonHeight: 58,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _RatingHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 12),
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
          Text(
            'Rate your Driver',
            style: kDriverRatingAppBarSB.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _DriverProfileCard extends StatelessWidget {
  final String driverName;
  final double driverRating;
  final int driverTrips;
  final String vehicleTypes;

  const _DriverProfileCard({
    required this.driverName,
    required this.driverRating,
    required this.driverTrips,
    required this.vehicleTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://i.pravatar.cc/128?u=ajith_kumar_rating',
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 72,
              height: 72,
              color: kChipGreyBg,
              child: const Icon(Icons.person, color: kMutedText, size: 36),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(driverName, style: kDriverRatingNameSB),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    driverRating.toStringAsFixed(1),
                    style: kDriverRatingStatR,
                  ),
                  const SizedBox(width: 4),
                  ..._buildProfileStars(driverRating),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '• $driverTrips trips',
                      style: kDriverRatingStatMutedR,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(vehicleTypes, style: kDriverRatingVehicleR),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _ActionCircle(color: kActiveGreen, icon: Icons.chat_rounded),
        const SizedBox(width: 8),
        _ActionCircle(color: kBlue, icon: Icons.phone_in_talk_rounded),
      ],
    );
  }

  List<Widget> _buildProfileStars(double rating) {
    final fullStars = rating.floor();
    final hasHalf = rating - fullStars >= 0.25;

    return List.generate(5, (index) {
      IconData icon;
      if (index < fullStars) {
        icon = Icons.star_rounded;
      } else if (index == fullStars && hasHalf) {
        icon = Icons.star_half_rounded;
      } else {
        icon = Icons.star_outline_rounded;
      }
      return Icon(icon, size: 14, color: const Color(0xFFE8B923));
    });
  }
}

class _ActionCircle extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _ActionCircle({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () {},
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: kWhite, size: 20),
        ),
      ),
    );
  }
}

class _RatingStars extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const _RatingStars({required this.rating, required this.onRatingChanged});

  static const _starActiveColor = Color(0xFFFFB400);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isFilled = starIndex <= rating;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: () => onRatingChanged(starIndex),
            borderRadius: BorderRadius.circular(8),
            child: Icon(
              isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 40,
              color: isFilled ? _starActiveColor : const Color(0xFFD8D8DE),
            ),
          ),
        );
      }),
    );
  }
}

class _FeedbackChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color selectedBorderColor;
  final VoidCallback onTap;

  const _FeedbackChip({
    required this.label,
    required this.isSelected,
    required this.selectedBorderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kWhite,
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected ? selectedBorderColor : kCardBorder,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(label, style: kDriverRatingChipR),
        ),
      ),
    );
  }
}

class _CommentField extends StatelessWidget {
  final TextEditingController controller;
  final Color backgroundColor;
  final Color smileyColor;

  const _CommentField({
    required this.controller,
    required this.backgroundColor,
    required this.smileyColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 1,
      style: kDriverRatingCommentR,
      decoration: InputDecoration(
        hintText: 'Leave a Comment(Optional)',
        hintStyle: kDriverRatingCommentHintR,
        filled: true,
        fillColor: backgroundColor,
        contentPadding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: smileyColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sentiment_satisfied_alt_rounded,
              color: kWhite,
              size: 22,
            ),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
      ),
    );
  }
}
