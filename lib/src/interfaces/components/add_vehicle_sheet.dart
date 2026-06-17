import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/constants/style_constants.dart';
import 'package:driveforme_user/src/data/apis/vehicle_api.dart';
import 'package:driveforme_user/src/interfaces/components/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showAddVehicleBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const AddVehicleBottomSheet();
    },
  );
}

class AddVehicleBottomSheet extends ConsumerStatefulWidget {
  const AddVehicleBottomSheet({super.key});

  @override
  ConsumerState<AddVehicleBottomSheet> createState() =>
      _AddVehicleBottomSheetState();
}

class _AddVehicleBottomSheetState extends ConsumerState<AddVehicleBottomSheet> {
  String transmission = 'Manual';
  int selectedVehicle = 0;
  bool _isSubmitting = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  final List<Map<String, String>> vehicleTypes = [
    {'label': 'Hatchback', 'value': 'hatchback'},
    {'label': 'Sedan', 'value': 'sedan'},
    {'label': 'SUV', 'value': 'suv'},
    {'label': 'Premium', 'value': 'premium'},
  ];

  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .80,
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
                    'Add Vehicle',
                    style: kStyle(kSemiBold, 20, color: kTextColor),
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ================= VEHICLE NAME =================
                  Text(
                    'Vehicle Name *',
                    style: kStyle(kSemiBold, 16, color: kTextColor),
                  ),
                  const SizedBox(height: 14),
                  InputField(
                    type: CustomFieldType.text,
                    hint: 'Enter Your Vehicle Name',
                    controller: nameController,
                  ),

                  const SizedBox(height: 28),

                  /// ================= VEHICLE NUMBER =================
                  Text(
                    'Vehicle Number *',
                    style: kStyle(kSemiBold, 16, color: kTextColor),
                  ),
                  const SizedBox(height: 14),
                  InputField(
                    type: CustomFieldType.text,
                    hint: 'Enter Your Vehicle Number',
                    controller: numberController,
                  ),

                  const SizedBox(height: 28),

                  /// ================= TRANSMISSION =================
                  Text(
                    'Transmission *',
                    style: kStyle(kSemiBold, 14, color: kTextColor),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _radioButton(
                        title: 'Manual',
                        selected: transmission == 'Manual',
                        onTap: () => setState(() => transmission = 'Manual'),
                      ),
                      const SizedBox(width: 32),
                      _radioButton(
                        title: 'Automatic',
                        selected: transmission == 'Automatic',
                        onTap: () => setState(() => transmission = 'Automatic'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  /// ================= VEHICLE TYPE =================
                  Text(
                    'Vehicle Type *',
                    style: kStyle(kSemiBold, 14, color: kTextColor),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vehicleTypes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.9,
                        ),
                    itemBuilder: (context, index) {
                      final selected = selectedVehicle == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedVehicle = index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected ? kTripGold : kTripBorder,
                              width: selected ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/pngs/car_image.png',
                                height: 50,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                vehicleTypes[index]['label'] ?? '',
                                style: kStyle(kSemiBold, 12, color: kTextColor),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  /// ================= ACTION BUTTON =================
                  GestureDetector(
                    onTap: _isSubmitting ? null : _submitVehicle,
                    child: Opacity(
                      opacity: _isSubmitting ? 0.7 : 1,
                      child: Container(
                        height: 64,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kTripDestIconBg,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Center(
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: kWhite,
                                  ),
                                )
                              : Text(
                                  'Add vehicle Details',
                                  style: kStyle(kSemiBold, 16, color: kWhite),
                                ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _radioButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? kTripGold : kTripBorder,
                width: selected ? 6 : 1.5,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(title, style: kStyle(kSemiBold, 14, color: kTextColor)),
        ],
      ),
    );
  }

  Future<void> _submitVehicle() async {
    final vehicleName = nameController.text.trim();
    final vehicleNumber = numberController.text.trim().toUpperCase();
    final vehicleType = vehicleTypes[selectedVehicle]['value'] ?? 'hatchback';
    final transmissionValue =
        transmission.toLowerCase() == 'automatic' ? 'automatic' : 'manual';

    if (vehicleName.isEmpty) {
      _showMessage('Vehicle name is required.');
      return;
    }

    if (vehicleNumber.isEmpty) {
      _showMessage('Vehicle number is required.');
      return;
    }

    setState(() => _isSubmitting = true);

    final createResponse = await ref.read(vehicleApiProvider).createVehicle(
      vehicleName: vehicleName,
      vehicleNumber: vehicleNumber,
      vehicleType: vehicleType,
      transmission: transmissionValue,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (!createResponse.success) {
      _showMessage(createResponse.message ?? 'Failed to add vehicle.');
      return;
    }

    _showMessage('Vehicle added successfully.');
    Navigator.pop(context, true);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
