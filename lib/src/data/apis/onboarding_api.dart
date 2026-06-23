import 'package:driveforme_user/src/data/models/api_response.dart';
import 'package:driveforme_user/src/data/models/user_model.dart';
import 'package:driveforme_user/src/data/providers/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingApi {
  final ApiProvider _api;

  OnboardingApi(this._api);

  Future<ApiResponse<UserModel>> getMe() async {
    final response = await _api.get('/onboarding/me', requireAuth: true);
    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'Failed to load profile',
        response.statusCode,
      );
    }

    final data = nestedData(response.data);
    if (data == null) {
      return ApiResponse.error('Invalid profile response');
    }

    return ApiResponse.success(UserModel.fromJson(data), response.statusCode);
  }

  Future<ApiResponse<Map<String, dynamic>>> submitVehicleOwnerProfile({
    required String fullName,
    required String email,
    required String dateOfBirth,
    required String gender,
  }) {
    return _api.post('/onboarding/vehicle-owner/profile', {
      'fullName': fullName,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
    }, requireAuth: true);
  }
}

final onboardingApiProvider = Provider<OnboardingApi>((ref) {
  return OnboardingApi(ref.watch(apiProviderProvider));
});
