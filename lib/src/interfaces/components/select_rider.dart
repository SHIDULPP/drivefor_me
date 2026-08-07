import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/models/rider_model.dart';
import 'package:driveforme_user/src/data/providers/riders_provider.dart';
import 'package:driveforme_user/src/interfaces/components/add_rider_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class SelectRiderBottomSheet extends ConsumerStatefulWidget {
  const SelectRiderBottomSheet({super.key});

  @override
  ConsumerState<SelectRiderBottomSheet> createState() =>
      _SelectRiderBottomSheetState();
}

class _SelectRiderBottomSheetState
    extends ConsumerState<SelectRiderBottomSheet> {
  /// 0 = Myself; 1..n map to [ridersProvider] entries.
  int selectedIndex = 0;

  void _deleteRider(List<RiderModel> riders, int listIndex) {
    final rider = riders[listIndex];
    final tileIndex = listIndex + 1;

    ref.read(ridersProvider.notifier).removeRider(rider.id);

    setState(() {
      if (selectedIndex == tileIndex) {
        selectedIndex = 0;
      } else if (selectedIndex > tileIndex) {
        selectedIndex -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final riders = ref.watch(ridersProvider);

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
                  for (var i = 0; i < riders.length; i++) ...[
                    const SizedBox(height: 16),
                    _riderTile(
                      index: i + 1,
                      title: riders[i].name,
                      selected: selectedIndex == i + 1,
                      showDelete: true,
                      onDelete: () => _deleteRider(riders, i),
                    ),
                  ],
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
    VoidCallback? onDelete,
  }) {
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? AppColors.riderSelectedBackground : kWhite,
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
            if (showDelete)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onDelete,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.delete, color: kRed, size: 28),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
