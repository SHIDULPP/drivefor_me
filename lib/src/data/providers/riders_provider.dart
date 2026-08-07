import 'package:driveforme_user/src/data/models/rider_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class RidersNotifier extends StateNotifier<List<RiderModel>> {
  RidersNotifier() : super(const []);

  void addRider({required String name, required String mobileNumber}) {
    final trimmedName = name.trim();
    final trimmedMobile = mobileNumber.trim();
    if (trimmedName.isEmpty || trimmedMobile.isEmpty) return;

    state = [
      ...state,
      RiderModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: trimmedName,
        mobileNumber: trimmedMobile,
      ),
    ];
  }

  void removeRider(String id) {
    state = state.where((rider) => rider.id != id).toList(growable: false);
  }
}

final ridersProvider =
    StateNotifierProvider<RidersNotifier, List<RiderModel>>((ref) {
  return RidersNotifier();
});
