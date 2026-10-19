import 'dart:convert';
import 'package:DriveForme/src/data/apis/vehicle_api.dart';
import 'package:DriveForme/src/data/providers/api_provider.dart';
import 'package:DriveForme/src/data/services/secure_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class _Storage extends SecureStorageService {
  @override
  Future<String?> getAuthToken() async => 'token';
}

void main() {
  setUp(() => dotenv.testLoad(envString: ''));
  VehicleApi api(MockClient client) => VehicleApi(
    ApiProvider(
      baseUrl: 'https://example.test',
      apiKey: '',
      secureStorage: _Storage(),
      client: client,
    ),
  );

  test(
    'vehicle creation sends all document URLs with authenticated owner request',
    () async {
      final service = api(
        MockClient((request) async {
          expect(request.url.path, '/vehicles');
          expect(request.headers['Authorization'], 'Bearer token');
          final body = jsonDecode(request.body);
          expect(body['registrationUrl'], 'rc-url');
          expect(body['insuranceUrl'], 'insurance-url');
          expect(body['pollutionUrl'], 'puc-url');
          expect(body.containsKey('owner'), isFalse);
          return http.Response(
            jsonEncode({
              'data': {'_id': 'vehicle', ...body},
            }),
            201,
          );
        }),
      );
      final result = await service.createVehicle(
        vehicleName: 'Car',
        vehicleNumber: 'KL01A1234',
        vehicleType: 'sedan',
        transmission: 'manual',
        registrationUrl: 'rc-url',
        insuranceUrl: 'insurance-url',
        pollutionUrl: 'puc-url',
      );
      expect(result.success, isTrue);
      expect(result.data!.id, 'vehicle');
    },
  );

  test('extraction preserves expiry and invalid-document feedback', () async {
    final service = api(
      MockClient((request) async {
        expect(request.url.path, '/vehicles/documents/extract');
        expect(jsonDecode(request.body), {
          'documentType': 'registration',
          'documentUrl': 'rc-url',
        });
        return http.Response(
          jsonEncode({
            'data': {
              'status': 'expired',
              'expiryDate': '2020-01-01',
              'problem': null,
              'isReadable': true,
            },
          }),
          200,
        );
      }),
    );
    final result = await service.extractDocument('registration', 'rc-url');
    expect(result.data!['status'], 'expired');
    expect(result.data!['expiryDate'], '2020-01-01');
  });

  test(
    'creation exposes backend rejection without reporting success',
    () async {
      final service = api(
        MockClient(
          (_) async => http.Response(
            jsonEncode({
              'message': 'Insurance expired. Upload a renewed copy.',
            }),
            422,
          ),
        ),
      );
      final result = await service.createVehicle(
        vehicleName: 'Car',
        vehicleNumber: 'KL01A1234',
        vehicleType: 'sedan',
        transmission: 'manual',
        registrationUrl: 'rc-url',
        insuranceUrl: 'insurance-url',
        pollutionUrl: 'puc-url',
      );
      expect(result.success, isFalse);
      expect(result.statusCode, 422);
      expect(result.message, contains('Insurance expired'));
    },
  );
}
