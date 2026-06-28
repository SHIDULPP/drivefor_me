import 'package:driveforme_user/src/data/models/api_response.dart';
import 'package:driveforme_user/src/data/models/pricing_settings_model.dart';
import 'package:driveforme_user/src/data/providers/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PricingApi {
  final ApiProvider _api;

  PricingApi(this._api);

  Future<ApiResponse<PricingSettingsModel>> getPricing() async {
    final response = await _api.get('/pricing', requireAuth: true);

    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'Failed to load pricing settings.',
        response.statusCode,
      );
    }

    final data = nestedData(response.data) ?? response.data;
    if (data == null) {
      return ApiResponse.error('Invalid pricing response');
    }

    return ApiResponse.success(
      PricingSettingsModel.fromJson(Map<String, dynamic>.from(data)),
      response.statusCode,
    );
  }
}

final pricingApiProvider = Provider<PricingApi>((ref) {
  return PricingApi(ref.watch(apiProviderProvider));
});
