import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:driveforme_user/src/data/models/api_response.dart';
import 'package:driveforme_user/src/data/services/logging_http_client.dart';
import 'package:driveforme_user/src/data/services/secure_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String baseUrl;
  final String apiKey;
  final SecureStorageService secureStorage;
  final http.Client _client;

  ApiProvider({
    required this.baseUrl,
    required this.apiKey,
    required this.secureStorage,
    http.Client? client,
  }) : _client = loggingHttpClient(client);

  Future<Map<String, String>> _buildHeaders({
    bool requireUserId = false,
    bool requireAuth = false,
  }) async {
    final headers = {'Content-Type': 'application/json', 'accept': '*/*'};

    if (apiKey.isNotEmpty) {
      headers['x-api-key'] = apiKey;
    }

    if (requireAuth) {
      final token = await secureStorage.getAuthToken();
      if (token == null || token.isEmpty) {
        throw StateError('No auth token found. Please log in again.');
      }
      headers['Authorization'] = 'Bearer $token';
    }

    if (requireUserId) {
      final userId = await secureStorage.getUserId();
      if (userId != null && userId.isNotEmpty) {
        headers['x-user-id'] = userId;
      }
    }

    return headers;
  }

  Future<ApiResponse<Map<String, dynamic>>> get(
    String endpoint, {
    bool requireUserId = false,
    bool requireAuth = false,
    Map<String, String>? queryParams,
  }) async {
    try {
      final headers = await _buildHeaders(
        requireUserId: requireUserId,
        requireAuth: requireAuth,
      );
      final uri = Uri.parse('$baseUrl$endpoint');
      final requestUri = queryParams != null && queryParams.isNotEmpty
          ? uri.replace(queryParameters: queryParams)
          : uri;

      final response = await _client.get(requestUri, headers: headers);
      return _parseResponse(response);
    } on StateError catch (e) {
      debugPrint('[ApiProvider] GET $endpoint StateError: ${e.message}');
      return ApiResponse.error(e.message);
    } catch (e) {
      debugPrint('[ApiProvider] GET $endpoint failed: $e');
      return ApiResponse.error('Failed to connect to the server.');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool requireUserId = false,
    bool requireAuth = false,
  }) async {
    try {
      final headers = await _buildHeaders(
        requireUserId: requireUserId,
        requireAuth: requireAuth,
      );
      final response = await _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
      return _parseResponse(response);
    } on StateError catch (e) {
      debugPrint('[ApiProvider] POST $endpoint StateError: ${e.message}');
      return ApiResponse.error(e.message);
    } catch (e) {
      debugPrint('[ApiProvider] POST $endpoint failed: $e');
      return ApiResponse.error('Failed to connect to the server.');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> patch(
    String endpoint, {
    Map<String, dynamic>? data,
    bool requireUserId = false,
    bool requireAuth = false,
  }) async {
    try {
      final headers = await _buildHeaders(
        requireUserId: requireUserId,
        requireAuth: requireAuth,
      );
      final response = await _client.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: data != null ? json.encode(data) : null,
      );
      return _parseResponse(response);
    } on StateError catch (e) {
      debugPrint('[ApiProvider] PATCH $endpoint StateError: ${e.message}');
      return ApiResponse.error(e.message);
    } catch (e) {
      debugPrint('[ApiProvider] PATCH $endpoint failed: $e');
      return ApiResponse.error('Failed to connect to the server.');
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> delete(
    String endpoint, {
    bool requireUserId = false,
    bool requireAuth = false,
  }) async {
    try {
      final headers = await _buildHeaders(
        requireUserId: requireUserId,
        requireAuth: requireAuth,
      );
      final response = await _client.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _parseResponse(response);
    } on StateError catch (e) {
      debugPrint('[ApiProvider] DELETE $endpoint StateError: ${e.message}');
      return ApiResponse.error(e.message);
    } catch (e) {
      debugPrint('[ApiProvider] DELETE $endpoint failed: $e');
      return ApiResponse.error('Failed to connect to the server.');
    }
  }

  ApiResponse<Map<String, dynamic>> _parseResponse(http.Response response) {
    if (response.body.isEmpty) {
      return ApiResponse.error(
        'Empty response from server.',
        response.statusCode,
      );
    }

    final dynamic decodedBody = json.decode(response.body);
    if (decodedBody is! Map<String, dynamic>) {
      return ApiResponse.error(
        'Unexpected response format.',
        response.statusCode,
      );
    }

    final message = decodedBody['message'] as String? ?? 'Request failed';

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse.success(decodedBody, response.statusCode);
    }

    return ApiResponse.error(message, response.statusCode);
  }

  void dispose() => _client.close();
}

final apiProviderProvider = Provider<ApiProvider>((ref) {
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  final apiKey = dotenv.env['API_KEY'] ?? '';
  if (baseUrl.isEmpty) {
    debugPrint('[ApiProvider] BASE_URL is missing from .env');
  }
  if (apiKey.isEmpty) {
    debugPrint('[ApiProvider] API_KEY is missing from .env');
  }

  return ApiProvider(
    baseUrl: baseUrl,
    apiKey: apiKey,
    secureStorage: ref.watch(secureStorageServiceProvider),
  );
});
