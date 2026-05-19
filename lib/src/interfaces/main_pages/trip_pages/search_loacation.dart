import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:flutter/material.dart';

class SearchLocationPage extends StatelessWidget {
  final String title;
  final bool showCurrentLocation;
  const SearchLocationPage({
    super.key,
    required this.title,
    this.showCurrentLocation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScreenBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            /// ================= HEADER =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 52,
                      width: 52,
                      decoration: const BoxDecoration(
                        color: kWhite,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 28,
                        color: kTextColor,
                      ),
                    ),
                  ),

                  const SizedBox(width: 22),

                  Expanded(
                    child: Text(
                      title,
                      style: kStyle(kSemiBold, 14, color: kTextColor),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// ================= WHITE BODY =================
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: kWhite),
                child: Column(
                  children: [
                    const SizedBox(height: 26),

                    /// ================= SEARCH FIELD =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: kSearchFieldBg,
                          borderRadius: BorderRadius.circular(45),
                          border: Border.all(color: kLineGrey, width: 2),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.my_location,
                              size: 34,
                              color: kTextColor,
                            ),

                            const SizedBox(width: 20),

                            Expanded(
                              child: TextField(
                                style: kStyle(kRegular, 16, color: kTextColor),
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: kStyle(
                                    kLight,
                                    16,
                                    color: kMutedText,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 42),

                    /// ================= CURRENT LOCATION =================
                    if (showCurrentLocation) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 36),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.my_location,
                              size: 34,
                              color: kTextColor,
                            ),

                            const SizedBox(width: 24),

                            Text(
                              'Use current location',
                              style: kStyle(
                                kSemiBold,
                                16,
                                color: const Color(0xFF39463D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 44),
                    ],

                    /// ================= RECENT =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 38),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'RECENT',
                          style: kStyle(
                            kSemiBold,
                            16,
                            color: kMutedText,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// ================= LOCATION LIST =================
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: const [
                          _LocationTile(
                            title: 'Infopark Phase I',
                            subtitle: 'Kakkanand',
                          ),
                          _LocationTile(
                            title: 'Infopark Phase II',
                            subtitle: 'Kakkanand',
                          ),
                          _LocationTile(
                            title: 'Infopark Phase',
                            subtitle: 'Kakkanand',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ============================================================
/// LOCATION TILE
/// ============================================================

class _LocationTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _LocationTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  size: 28,
                  color: Color(0xFF121223),
                ),
              ),

              const SizedBox(width: 22),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: kStyle(
                        kSemiBold,
                        16,
                        color: const Color(0xFF39463D),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      subtitle,
                      style: kStyle(
                        kRegular,
                        14,
                        color: const Color(0xFF39463D),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right, size: 38, color: kChevronGrey),
            ],
          ),
        ),

        const Divider(height: 1, thickness: 1, color: kLineGrey),
      ],
    );
  }
}
