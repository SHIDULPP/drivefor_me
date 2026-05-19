import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/interfaces/components/add_rider_sheet.dart';
import 'package:flutter/material.dart';

Future<void> showSelectRiderBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return const SelectRiderBottomSheet();
    },
  );
}

class SelectRiderBottomSheet extends StatefulWidget {
  const SelectRiderBottomSheet({super.key});

  @override
  State<SelectRiderBottomSheet> createState() => _SelectRiderBottomSheetState();
}

class _SelectRiderBottomSheetState extends State<SelectRiderBottomSheet> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .50,
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),

          /// ================= HEADER =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Rider',
                    style: kStyle(kSemiBold, 16, color: kTextColor),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 44,
                    width: 44,
                    decoration: const BoxDecoration(
                      color: kTripCloseBtnBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 24, color: kTextColor),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          /// ================= SCROLLABLE RIDER LIST =================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _riderTile(
                    index: 0,
                    title: 'Myself',
                    selected: selectedIndex == 0,
                  ),
                  const SizedBox(height: 16),
                  _riderTile(
                    index: 1,
                    title: 'Anandhu',
                    selected: selectedIndex == 1,
                    showDelete: true,
                  ),
                  const SizedBox(height: 16),

                  /// ================= ADD RIDER =================
                  GestureDetector(
                    onTap: () => showAddRiderBottomSheet(context),
                    child: Container(
                      height: 78,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: kTripBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: const BoxDecoration(
                              color: kTripCreamBg,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 28,
                              color: kTextColor,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Text(
                            'Add New Rider',
                            style: kStyle(kMedium, 16, color: kTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ================= BUTTON =================
          Padding(
            padding: const EdgeInsets.all(24),
            child: GestureDetector(
              onTap: () {
                // Handle confirm rider
              },
              child: Container(
                height: 64,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kBrandBlue,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Center(
                  child: Text(
                    'Confirm Rider',
                    style: kStyle(kSemiBold, 16, color: kWhite),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _riderTile({
    required int index,
    required String title,
    required bool selected,
    bool showDelete = false,
  }) {
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF7F8F2) : kWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? kTripGold : kTripBorder,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: const BoxDecoration(
                color: kBrandBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: kWhite, size: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(title, style: kStyle(kMedium, 16, color: kTextColor)),
            ),
            if (showDelete) const Icon(Icons.delete, color: kRed, size: 28),
          ],
        ),
      ),
    );
  }
}
