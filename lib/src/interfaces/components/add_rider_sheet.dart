import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/providers/riders_provider.dart';
import 'package:driveforme_user/src/interfaces/components/input_field.dart';
import 'package:driveforme_user/src/interfaces/components/primaryButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showAddRiderBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return const AddRiderBottomSheet();
    },
  );
}

class AddRiderBottomSheet extends ConsumerStatefulWidget {
  const AddRiderBottomSheet({super.key});

  @override
  ConsumerState<AddRiderBottomSheet> createState() =>
      _AddRiderBottomSheetState();
}

class _AddRiderBottomSheetState extends ConsumerState<AddRiderBottomSheet> {
  final TextEditingController nameController = TextEditingController(
    text: 'Anandhu',
  );

  final TextEditingController mobileController = TextEditingController(
    text: '6282359916',
  );

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  void _confirmRider() {
    ref.read(ridersProvider.notifier).addRider(
          name: nameController.text,
          mobileNumber: mobileController.text,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        decoration: const BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),

              /// ================= HEADER =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Add Rider',
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
                        child: const Icon(
                          Icons.close,
                          size: 24,
                          color: kTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ================= RIDER NAME =================
                    Text(
                      'Rider Name *',
                      style: kStyle(kSemiBold, 16, color: kTextColor),
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      type: CustomFieldType.text,
                      hint: 'Enter Rider Name',
                      controller: nameController,
                    ),

                    const SizedBox(height: 28),

                    /// ================= MOBILE NUMBER =================
                    Text(
                      'Rider Mobile Number *',
                      style: kStyle(kSemiBold, 16, color: kTextColor),
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      type: CustomFieldType.number,
                      hint: 'Enter Mobile Number',
                      controller: mobileController,
                    ),
                  ],
                ),
              ),

              /// ================= BUTTON =================
              Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  safeBottom > 0 ? safeBottom + 10 : 24,
                ),
                child: primaryButton(
                  label: 'Confirm Rider',
                  buttonHeight: 64,
                  buttonColor: kBrandBlue,
                  fontSize: 16,
                  onPressed: _confirmRider,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
