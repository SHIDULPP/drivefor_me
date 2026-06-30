import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecureStorageService {
  static const _userIdKey = 'user_id';
  static const _phoneNumberKey = 'phone_number';
  static const _authTokenKey = 'auth_token';
  static const _onboardingStatusKey = 'onboarding_status';
  static const _activeTripIdKey = 'active_trip_id';

  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveUserId(String userId) =>
      _storage.write(key: _userIdKey, value: userId);

  Future<String?> getUserId() => _storage.read(key: _userIdKey);

  Future<void> savePhoneNumber(String phoneNumber) =>
      _storage.write(key: _phoneNumberKey, value: phoneNumber);

  Future<String?> getPhoneNumber() => _storage.read(key: _phoneNumberKey);

  Future<void> saveAuthToken(String token) =>
      _storage.write(key: _authTokenKey, value: token);

  Future<String?> getAuthToken() => _storage.read(key: _authTokenKey);

  Future<void> saveOnboardingStatus(String status) =>
      _storage.write(key: _onboardingStatusKey, value: status);

  Future<String?> getOnboardingStatus() =>
      _storage.read(key: _onboardingStatusKey);

  Future<void> saveActiveTripId(String tripId) =>
      _storage.write(key: _activeTripIdKey, value: tripId);

  Future<String?> getActiveTripId() => _storage.read(key: _activeTripIdKey);

  Future<void> clearActiveTripId() => _storage.delete(key: _activeTripIdKey);

  Future<void> clearSession() async {
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _phoneNumberKey);
    await _storage.delete(key: _authTokenKey);
    await _storage.delete(key: _onboardingStatusKey);
    await _storage.delete(key: _activeTripIdKey);
  }
}

final secureStorageServiceProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);
