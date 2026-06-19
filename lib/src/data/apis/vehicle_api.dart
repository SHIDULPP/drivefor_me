import 'package:driveforme_user/src/data/models/api_response.dart';
import 'package:driveforme_user/src/data/models/vehicle_model.dart';
import 'package:driveforme_user/src/data/providers/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleApi {
  final ApiProvider _api;

  VehicleApi(this._api);

  Future<ApiResponse<VehicleModel>> createVehicle({
    required String vehicleName,
    required String vehicleNumber,
    required String vehicleType,
    required String transmission,
  }) async {
    final response = await _api.post(
      '/vehicles',
      {
        'vehicleName': vehicleName,
        'vehicleNumber': vehicleNumber,
        'vehicleType': vehicleType,
        'transmission': transmission,
      },
      requireAuth: true,
    );

    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'Failed to add vehicle.',
        response.statusCode,
      );
    }

    final data = nestedData(response.data);
    if (data == null) {
      return ApiResponse.error('Invalid vehicle response');
    }

    return ApiResponse.success(
      VehicleModel.fromJson(data),
      response.statusCode,
    );
  }

  Future<ApiResponse<List<VehicleModel>>> getMyVehicles() async {
    final response = await _api.get('/vehicles', requireAuth: true);
    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'Failed to load vehicles.',
        response.statusCode,
      );
    }

    final items = nestedListData(response.data)
        .map(VehicleModel.fromJson)
        .toList();

    return ApiResponse.success(items, response.statusCode);
  }

  Future<ApiResponse<Map<String, List<String>>>> getVehicleTypes() async {
    final response = await _api.get('/vehicles/types', requireAuth: true);
    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'Failed to load vehicle types.',
        response.statusCode,
      );
    }

    final data = nestedData(response.data);
    if (data == null) {
      return ApiResponse.error('Invalid vehicle types response');
    }

    final vehicleTypes = (data['vehicleTypes'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];
    final transmissionTypes = (data['transmissionTypes'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        const <String>[];

    return ApiResponse.success(
      {
        'vehicleTypes': vehicleTypes,
        'transmissionTypes': transmissionTypes,
      },
      response.statusCode,
    );
  }
}

final vehicleApiProvider = Provider<VehicleApi>((ref) {
  return VehicleApi(ref.watch(apiProviderProvider));
});
