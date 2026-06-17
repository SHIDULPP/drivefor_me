import 'package:driveforme_user/src/data/models/api_response.dart';
import 'package:driveforme_user/src/data/providers/api_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthApi {
  static const _vehicleOwnerRole = 'vehicle_owner';

  final ApiProvider _api;

  AuthApi(this._api);

  Future<ApiResponse<Map<String, dynamic>>> requestOtp(String phoneNumber) async {
    const endpoint = '/auth/request-otp';
    final body = {
      'phoneNumber': phoneNumber,
      'role': _vehicleOwnerRole,
    };

    debugPrint('┌─── [AuthApi] requestOtp ───────────────────────────');
    debugPrint('│ POST $endpoint');
    debugPrint('│ Body: $body');
    debugPrint('└────────────────────────────────────────────────────');

    final response = await _api.post(endpoint, body);

    debugPrint('┌─── [AuthApi] requestOtp Response ──────────────────');
    debugPrint('│ Success : ${response.success}');
    debugPrint('│ Message : ${response.message}');
    debugPrint('│ Data    : ${response.data}');
    debugPrint('└────────────────────────────────────────────────────');

    return response;
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    const endpoint = '/auth/verify-otp';
    final body = {
      'phoneNumber': phoneNumber,
      'role': _vehicleOwnerRole,
      'otp': otp,
    };

    debugPrint('┌─── [AuthApi] verifyOtp ────────────────────────────');
    debugPrint('│ POST $endpoint');
    debugPrint('│ Body: $body');
    debugPrint('└────────────────────────────────────────────────────');

    final response = await _api.post(endpoint, body);

    debugPrint('┌─── [AuthApi] verifyOtp Response ───────────────────');
    debugPrint('│ Success : ${response.success}');
    debugPrint('│ Message : ${response.message}');
    debugPrint('│ Data    : ${response.data}');
    debugPrint('└────────────────────────────────────────────────────');

    return response;
  }
}

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(apiProviderProvider));
});
