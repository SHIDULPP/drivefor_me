import 'package:driveforme_user/src/data/apis/notification_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationTokenService {
  final NotificationApi _notificationApi;

  NotificationTokenService(this._notificationApi);

  /// Registers the device FCM token with the backend.
  ///
  /// TODO: wire firebase_messaging when Firebase project is configured
  /// (google-services.json / GoogleService-Info.plist).
  Future<void> registerTokenIfAvailable() async {
    // No Firebase configured in this project yet — skip silently.
    return;
  }
}

final notificationTokenServiceProvider =
    Provider<NotificationTokenService>((ref) {
  return NotificationTokenService(ref.watch(notificationApiProvider));
});
