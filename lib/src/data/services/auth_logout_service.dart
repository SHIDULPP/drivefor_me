import 'package:driveforme_user/src/data/providers/active_trip_provider.dart';
import 'package:driveforme_user/src/data/providers/notification_provider.dart';
import 'package:driveforme_user/src/data/providers/user_provider.dart';
import 'package:driveforme_user/src/data/providers/wallet_provider.dart';
import 'package:driveforme_user/src/data/services/secure_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthLogoutService {
  Future<void> logout(WidgetRef ref) async {
    await ref.read(secureStorageServiceProvider).clearSession();
    await ref.read(activeTripProvider.notifier).clear();
    ref.invalidate(userProvider);
    ref.invalidate(walletProvider);
    ref.invalidate(notificationsProvider);
  }
}

final authLogoutServiceProvider = Provider<AuthLogoutService>((ref) {
  return AuthLogoutService();
});
