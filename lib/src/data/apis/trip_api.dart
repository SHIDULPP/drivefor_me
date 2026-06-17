import 'package:driveforme_user/src/data/models/api_response.dart';
import 'package:driveforme_user/src/data/providers/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripApi {
  final ApiProvider _api;

  TripApi(this._api);

  Future<ApiResponse<Map<String, dynamic>>> createManualTrip(
    Map<String, dynamic> payload,
  ) {
    return _api.post('/trips/manual', payload);
  }
}

final tripApiProvider = Provider<TripApi>((ref) {
  return TripApi(ref.watch(apiProviderProvider));
});
