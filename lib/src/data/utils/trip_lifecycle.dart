import 'package:DriveForme/src/data/apis/trip_api.dart';
import 'package:DriveForme/src/data/models/trip_model.dart';
import 'package:DriveForme/src/data/providers/active_trip_provider.dart';
import 'package:DriveForme/src/data/services/navigation_services.dart';
import 'package:DriveForme/src/data/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String _formatChargeAmount(num? amount) {
  final value = (amount ?? 0).toDouble();
  if (value <= 0) return '₹ 0';
  return '₹ ${value.toStringAsFixed(0)}';
}

Future<bool> showCancelTripDialog(
  BuildContext context, {
  String? chargeMessage,
  double chargeAmount = 0,
}) async {
  final chargeLine = chargeAmount > 0
      ? 'Cancellation charge: ${_formatChargeAmount(chargeAmount)} will be deducted from your wallet.'
      : (chargeMessage?.trim().isNotEmpty == true
          ? chargeMessage!.trim()
          : 'No cancellation charge at this stage.');

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cancel ride?'),
      content: Text(
        'Are you sure you want to cancel this trip?\n\n$chargeLine',
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

  final tripApi = ref.read(tripApiProvider);

  double previewAmount = 0;
  String? previewMessage;
  final preview = await tripApi.previewCancellationCharges(tripMongoId);
  if (preview.success && preview.data != null) {
    previewAmount =
        (preview.data!['customerChargeAmount'] as num?)?.toDouble() ?? 0;
    previewMessage = preview.data!['message']?.toString();
    if (preview.data!['allowed'] == false) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              previewMessage ?? 'Cancellation is not allowed at this stage.',
            ),
          ),
        );
      }
      return null;
    }
  }

  if (!context.mounted) return null;

  final confirmed = await showCancelTripDialog(
    context,
    chargeMessage: previewMessage,
    chargeAmount: previewAmount,
  );
  if (!confirmed || !context.mounted) return null;

  final response = await tripApi.cancelTrip(
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

  final trip = response.data;
  if (trip != null && trip.hasCancellationCharge && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response.message ??
              'Trip cancelled. Cancellation charge: ${trip.cancellationChargeDisplay}.',
        ),
      ),
    );
  }

  return trip;
}

Future<void> navigateAfterTripCancelled(
  Map<String, dynamic> cancelledArguments,
) async {
  NavigationService().resetToNavbarThenPush(
    'cancelled_trip_details',
    arguments: cancelledArguments,
  );
}

Future<void> navigateAfterDriverReassigned({
  required TripModel trip,
  String? message,
}) async {
  final context = NavigationService.navigatorKey.currentContext;
  if (context != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ??
              'Your driver cancelled. Finding another driver nearby...',
        ),
      ),
    );
  }

  NavigationService().pushNamedReplacement(
    'waiting_driver',
    arguments: trip.toWaitingDriverArguments(),
  );
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
