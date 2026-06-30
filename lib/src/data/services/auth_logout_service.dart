import 'package:driveforme_user/src/data/providers/active_trip_provider.dart';
import 'package:driveforme_user/src/data/providers/notification_provider.dart';
import 'package:driveforme_user/src/data/providers/user_provider.dart';
import 'package:driveforme_user/src/data/providers/wallet_provider.dart';
import 'package:driveforme_user/src/data/services/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mirrors 24-connect `AuthProvider.clearAllData()` — local session wipe.
/// DriveFORme has no `/auth/logout` API, so logout is device-side only.
class AuthLogoutService {
  Future<void> performLogout(WidgetRef ref) async {
    await clearAllData(ref);
  }

  Future<void> clearAllData(WidgetRef ref) async {
    await ref.read(secureStorageServiceProvider).clearSession();
    await ref.read(activeTripProvider.notifier).clear();

    ref.invalidate(userProvider);
    ref.invalidate(walletProvider);
    ref.invalidate(notificationsProvider);
    ref.invalidate(activeTripProvider);
  }
}

final authLogoutServiceProvider = Provider<AuthLogoutService>((ref) {
  return AuthLogoutService();
});
