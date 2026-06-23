import 'package:driveforme_user/src/data/apis/trip_api.dart';
import 'package:driveforme_user/src/data/models/trip_model.dart';
import 'package:driveforme_user/src/data/providers/active_trip_provider.dart';
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:driveforme_user/src/data/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<bool> showCancelTripDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cancel ride?'),
      content: const Text(
        'Are you sure you want to cancel this trip? Cancellation charges may apply.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Keep ride'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Cancel ride'),
        ),
      ],
    ),
  );
  return result == true;
}

Future<TripModel?> cancelTripWithDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String tripMongoId,
  String? reason,
}) async {
  if (tripMongoId.isEmpty) return null;

  final confirmed = await showCancelTripDialog(context);
  if (!confirmed || !context.mounted) return null;

  final response = await ref.read(tripApiProvider).cancelTrip(
        tripMongoId,
        reason: reason ?? 'Cancelled by vehicle owner',
      );

  if (!context.mounted) return null;

  if (!response.success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.message ?? 'Failed to cancel trip.')),
    );
    return null;
  }

  await ref.read(secureStorageServiceProvider).clearActiveTripId();
  ref.read(activeTripProvider.notifier).clear();

  return response.data;
}

void openChatScreen({
  required String receiverId,
  required String receiverName,
  String? tripId,
}) {
  if (receiverId.isEmpty) return;
  NavigationService().pushNamed(
    'chat_screen',
    arguments: {
      'receiverId': receiverId,
      'receiverName': receiverName,
      if (tripId != null && tripId.isNotEmpty) 'tripId': tripId,
      'participantName': receiverName,
    },
  );
}
