import 'package:driveforme_user/src/data/apis/wallet_api.dart';
import 'package:driveforme_user/src/data/models/wallet_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletProvider = FutureProvider<WalletModel>((ref) async {
  final response = await ref.read(walletApiProvider).getWallet();
  if (!response.success || response.data == null) {
    throw Exception(response.message ?? 'Failed to load wallet.');
  }
  return response.data!;
});
