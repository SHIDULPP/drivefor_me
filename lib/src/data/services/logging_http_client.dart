import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const _secretQueryKeys = {'key', 'api_key', 'apikey', 'token'};

/// Wraps any [http.Client] so every request/response is emitted with [debugPrint].
http.Client loggingHttpClient([http.Client? client]) {
  if (client is LoggingHttpClient) return client;
  return LoggingHttpClient(inner: client);
}

class LoggingHttpClient extends http.BaseClient {
  LoggingHttpClient({http.Client? inner}) : _inner = inner ?? http.Client();

  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final method = request.method;
    final url = _redactedUri(request.url);

    debugPrint('[API Request] $method $url');
    _logRequestBody(request);

    try {
      final streamed = await _inner.send(request);
      final bytes = await streamed.stream.toBytes();
      final body = utf8.decode(bytes, allowMalformed: true);

      debugPrint('[API Response] ${streamed.statusCode} $method $url');
      if (body.isNotEmpty) {
        debugPrint('[API Response Body] $body');
      }

      return http.StreamedResponse(
        http.ByteStream.fromBytes(bytes),
        streamed.statusCode,
        contentLength: bytes.length,
        request: request,
        headers: streamed.headers,
        isRedirect: streamed.isRedirect,
        persistentConnection: streamed.persistentConnection,
        reasonPhrase: streamed.reasonPhrase,
      );
    } catch (e, stackTrace) {
      debugPrint('[API Error] $method $url failed: $e\n$stackTrace');
      rethrow;
    }
  }

  void _logRequestBody(http.BaseRequest request) {
    if (request is http.Request && request.body.isNotEmpty) {
      debugPrint('[API Request Body] ${request.body}');
      return;
    }
    if (request is http.MultipartRequest && request.fields.isNotEmpty) {
      debugPrint('[API Request Fields] ${request.fields}');
    }
  }

  Uri _redactedUri(Uri uri) {
    if (uri.queryParameters.isEmpty) return uri;
    final params = Map<String, String>.from(uri.queryParameters);
    var changed = false;
    for (final key in params.keys.toList()) {
      if (_secretQueryKeys.contains(key.toLowerCase())) {
        params[key] = '***';
        changed = true;
      }
    }
    return changed ? uri.replace(queryParameters: params) : uri;
  }

  @override
  void close() => _inner.close();
}
