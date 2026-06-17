import 'package:driveforme_user/src/data/models/api_response.dart';
import 'package:driveforme_user/src/data/providers/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleApi {
  final ApiProvider _api;

  VehicleApi(this._api);

  Future<ApiResponse<Map<String, dynamic>>> createVehicle({
    required String vehicleName,
    required String vehicleNumber,
    required String vehicleType,
    required String transmission,
  }) {
    return _api.post(
      '/vehicles',
      {
        'vehicleName': vehicleName,
        'vehicleNumber': vehicleNumber,
        'vehicleType': vehicleType,
        'transmission': transmission,
      },
      requireAuth: true,
    );
  }
}

final vehicleApiProvider = Provider<VehicleApi>((ref) {
  return VehicleApi(ref.watch(apiProviderProvider));
});
