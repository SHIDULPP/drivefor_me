import 'package:driveforme_user/src/data/models/api_response.dart';
import 'package:driveforme_user/src/data/models/trip_model.dart';
import 'package:driveforme_user/src/data/providers/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripApi {
  final ApiProvider _api;

  TripApi(this._api);

  Future<ApiResponse<Map<String, dynamic>>> createManualTrip(
    Map<String, dynamic> payload,
  ) {
    return _api.post('/trips/manual', payload, requireAuth: true);
  }

  Future<ApiResponse<List<TripModel>>> listOngoingTrips() {
    return _listTrips(status: 'in_progress');
  }

  Future<ApiResponse<List<TripModel>>> listCompletedTrips() {
    return _listTrips(status: 'completed');
  }

  Future<ApiResponse<List<TripModel>>> listCancelledTrips() {
    return _listTrips(status: 'cancelled');
  }

  Future<ApiResponse<List<TripModel>>> listUpcomingTrips() async {
    const statuses = ['pending_assignment', 'driver_assigned', 'scheduled'];
    final responses = await Future.wait(
      statuses.map((status) => _listTrips(status: status)),
    );

    for (final response in responses) {
      if (!response.success) {
        return ApiResponse.error(
          response.message ?? 'Failed to load upcoming trips.',
          response.statusCode,
        );
      }
    }

    final trips =
        responses
            .expand((response) => response.data ?? const <TripModel>[])
            .toList()
          ..sort((a, b) {
            final aDate = a.pickupAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bDate = b.pickupAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return aDate.compareTo(bDate);
          });

    return ApiResponse.success(trips, responses.first.statusCode);
  }

  Future<ApiResponse<List<TripModel>>> _listTrips({
    required String status,
  }) async {
    final response = await _api.get(
      '/trips',
      requireAuth: true,
      queryParams: {'status': status},
    );

    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'Failed to load trips.',
        response.statusCode,
      );
    }

    final trips = nestedListData(
      response.data,
    ).map(TripModel.fromJson).toList();

    return ApiResponse.success(trips, response.statusCode);
  }

  Future<ApiResponse<TripModel>> getTripById(String tripId) async {
    final response = await _api.get('/trips/$tripId', requireAuth: true);

    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'Failed to load trip.',
        response.statusCode,
      );
    }

    final data = nestedData(response.data);
    if (data == null) {
      return ApiResponse.error('Invalid trip response');
    }

    return ApiResponse.success(TripModel.fromJson(data), response.statusCode);
  }

  Future<ApiResponse<TripModel>> cancelTrip(
    String tripId, {
    String? reason,
  }) async {
    final response = await _api.post(
      '/trips/$tripId/cancel',
      {if (reason != null && reason.isNotEmpty) 'reason': reason},
      requireAuth: true,
    );

    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'Failed to cancel trip.',
        response.statusCode,
      );
    }

    final data = nestedData(response.data);
    if (data == null) {
      return ApiResponse.error('Invalid cancel trip response');
    }

    return ApiResponse.success(TripModel.fromJson(data), response.statusCode);
  }

  Future<ApiResponse<TripModel>> rateTrip(
    String tripId, {
    required int stars,
    List<String>? feedbackTags,
    String? comment,
  }) async {
    final response = await _api.post(
      '/trips/$tripId/rate',
      {
        'stars': stars,
        if (feedbackTags != null && feedbackTags.isNotEmpty)
          'feedbackTags': feedbackTags,
        if (comment != null && comment.trim().isNotEmpty)
          'comment': comment.trim(),
      },
      requireAuth: true,
    );

    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'Failed to submit rating.',
        response.statusCode,
      );
    }

    final data = nestedData(response.data);
    if (data == null) {
      return ApiResponse.error('Invalid rating response');
    }

    return ApiResponse.success(TripModel.fromJson(data), response.statusCode);
  }

  Future<ApiResponse<Map<String, dynamic>>> generateStartOtp(
    String tripId,
  ) async {
    final response = await _api.post(
      '/trips/$tripId/start-otp',
      {},
      requireAuth: true,
    );

    if (!response.success) {
      return ApiResponse.error(
        response.message ?? 'Failed to generate trip OTP.',
        response.statusCode,
      );
    }

    final data = nestedData(response.data) ?? response.data;
    if (data == null) {
      return ApiResponse.error('Invalid OTP response');
    }

    return ApiResponse.success(data, response.statusCode);
  }
}

final tripApiProvider = Provider<TripApi>((ref) {
  return TripApi(ref.watch(apiProviderProvider));
});
