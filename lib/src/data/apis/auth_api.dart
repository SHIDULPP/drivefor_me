import 'package:driveforme_user/src/data/models/api_response.dart';
import 'package:driveforme_user/src/data/providers/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthApi {
  static const _vehicleOwnerRole = 'vehicle_owner';

  final ApiProvider _api;

  AuthApi(this._api);

  Future<ApiResponse<Map<String, dynamic>>> requestOtp(String phoneNumber) {
    return _api.post('/auth/request-otp', {
      'phoneNumber': phoneNumber,
      'role': _vehicleOwnerRole,
    });
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) {
    return _api.post('/auth/verify-otp', {
      'phoneNumber': phoneNumber,
      'role': _vehicleOwnerRole,
      'otp': otp,
    });
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(apiProviderProvider));
});
