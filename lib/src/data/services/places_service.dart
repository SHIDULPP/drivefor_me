import 'dart:convert';
import 'dart:developer';

import 'package:driveforme_user/src/data/models/place_prediction_model.dart';
import 'package:driveforme_user/src/data/models/trip_location_model.dart';
import 'package:driveforme_user/src/data/services/logging_http_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PlacesService {
  final http.Client _client;

  PlacesService({http.Client? client}) : _client = loggingHttpClient(client);

  String get _apiKey =>
      dotenv.env['GOOGLE_PLACES_API_KEY'] ??
      dotenv.env['GOOGLE_MAPS_ANDROID_KEY'] ??
      dotenv.env['GOOGLE_MAPS_IOS_KEY'] ??
      '';

  Future<List<PlacePrediction>> autocomplete(String input) async {
    final query = input.trim();
    if (query.length < 2 || _apiKey.isEmpty) return const [];

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      {
        'input': query,
        'key': _apiKey,
        'components': 'country:in',
      },
    );

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) return const [];

      final body = json.decode(response.body);
      if (body is! Map<String, dynamic>) return const [];
      if (body['status'] != 'OK' && body['status'] != 'ZERO_RESULTS') {
        log('Places autocomplete: ${body['status']}', name: 'PlacesService');
        return const [];
      }

      final predictions = body['predictions'];
      if (predictions is! List) return const [];

      return predictions
          .whereType<Map>()
          .map((item) {
            final structured = item['structured_formatting'];
            final mainText = structured is Map
                ? structured['main_text']?.toString() ?? ''
                : '';
            final secondaryText = structured is Map
                ? structured['secondary_text']?.toString() ?? ''
                : '';
            final description = item['description']?.toString() ?? '';

            return PlacePrediction(
              placeId: item['place_id']?.toString() ?? '',
              title: mainText.isNotEmpty ? mainText : description,
              subtitle: secondaryText,
            );
          })
          .where((prediction) => prediction.placeId.isNotEmpty)
          .toList();
    } catch (e) {
      log('Places autocomplete failed: $e', name: 'PlacesService');
      return const [];
    }
  }

  Future<TripLocation?> placeDetails(String placeId) async {
    if (placeId.isEmpty || _apiKey.isEmpty) return null;

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      {
        'place_id': placeId,
        'fields': 'formatted_address,geometry',
        'key': _apiKey,
      },
    );

    try {
      final response = await _client.get(uri);
      if (response.statusCode != 200) return null;

      final body = json.decode(response.body);
      if (body is! Map<String, dynamic> || body['status'] != 'OK') {
        return null;
      }

      final result = body['result'];
      if (result is! Map) return null;

      final geometry = result['geometry'];
      final location = geometry is Map ? geometry['location'] : null;
      if (location is! Map) return null;

      final lat = location['lat'];
      final lng = location['lng'];
      if (lat is! num || lng is! num) return null;

      return TripLocation(
        address: result['formatted_address']?.toString().trim() ?? '',
        latitude: lat.toDouble(),
        longitude: lng.toDouble(),
      );
    } catch (e) {
      log('Place details failed: $e', name: 'PlacesService');
      return null;
    }
  }

  void dispose() => _client.close();
}
