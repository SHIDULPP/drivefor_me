import 'package:driveforme_user/src/data/models/api_response.dart';
import 'package:driveforme_user/src/data/models/wallet_model.dart';
import 'package:driveforme_user/src/data/providers/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalletApi {
  final ApiProvider _api;

  WalletApi(this._api);

  Future<ApiResponse<WalletModel>> getWallet() async {
    final response = await _api.get('/wallet', requireAuth: true);

    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'Failed to load wallet.',
        response.statusCode,
      );
    }

    final data = nestedData(response.data);
    if (data == null) {
      return ApiResponse.error('Invalid wallet response');
    }

    return ApiResponse.success(
      WalletModel.fromJson(data),
      response.statusCode,
    );
  }

  Future<ApiResponse<void>> applyReferral(String referralCode) async {
    final response = await _api.post(
      '/wallet/apply-referral',
      {'referralCode': referralCode.trim()},
      requireAuth: true,
    );

    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'Failed to apply referral code.',
        response.statusCode,
      );
    }

    return ApiResponse.success(null, response.statusCode);
  }
}

final walletApiProvider = Provider<WalletApi>((ref) {
  return WalletApi(ref.watch(apiProviderProvider));
});
