import 'dart:convert';

import 'package:DriveForme/src/data/providers/api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class VehicleDocumentUploadService {
  VehicleDocumentUploadService(this.api);
  final ApiProvider api;

  Future<String> upload(XFile file) async {
    final token = await api.secureStorage.getAuthToken();
    if (token == null || token.isEmpty) {
      throw Exception('Session expired. Please log in again.');
    }
    final bytes = await file.readAsBytes();
    final mime = lookupMimeType(file.name, headerBytes: bytes);
    if (!['image/jpeg', 'image/png'].contains(mime)) {
      throw Exception('Please select a JPG or PNG image.');
    }
    final request =
        http.MultipartRequest('POST', Uri.parse('${api.baseUrl}/upload'))
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['folder'] = 'vehicle-documents';
    if (api.apiKey.isNotEmpty) request.headers['x-api-key'] = api.apiKey;
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: file.name,
        contentType: MediaType.parse(mime!),
      ),
    );
    final client = http.Client();
    try {
      final response = await client
          .send(request)
          .then(http.Response.fromStream)
          .timeout(const Duration(seconds: 90));
      dynamic body;
      try {
        body = jsonDecode(response.body);
      } catch (_) {
        throw Exception('Upload failed. Please try again.');
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          body is Map ? body['message'] ?? 'Upload failed' : 'Upload failed',
        );
      }
      final url = body is Map ? body['data'] : null;
      if (url is! String || url.isEmpty)
        throw Exception('Invalid upload response');
      return url;
    } finally {
      client.close();
    }
  }
}

final vehicleDocumentUploadServiceProvider = Provider(
  (ref) => VehicleDocumentUploadService(ref.watch(apiProviderProvider)),
);
