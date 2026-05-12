import 'package:flutter_riverpod/legacy.dart';

class NavNotifier extends StateNotifier<int> {
  NavNotifier() : super(0);
  void updateIndex(int index) => state = index;
}

final selectedIndexProvider = StateNotifierProvider<NavNotifier, int>(
  (ref) => NavNotifier(),
);
