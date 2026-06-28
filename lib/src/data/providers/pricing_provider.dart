import 'package:driveforme_user/src/data/apis/pricing_api.dart';
import 'package:driveforme_user/src/data/models/pricing_settings_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Live pricing rules from `GET /pricing`, with schema defaults as fallback.
final pricingSettingsProvider = FutureProvider<PricingSettingsModel>((ref) async {
  final response = await ref.read(pricingApiProvider).getPricing();
  if (response.success && response.data != null) {
    return response.data!;
  }
  return PricingSettingsModel.defaults;
});
