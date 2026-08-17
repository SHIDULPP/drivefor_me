import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/interfaces/components/location_permission_gate.dart';
import 'package:driveforme_user/src/interfaces/main_pages/navbar.dart';
import 'package:driveforme_user/src/interfaces/main_pages/profile/wallet_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/booking_confirmed.dart';
import 'package:driveforme_user/src/interfaces/main_pages/cancelled_trip_screens/cancelled_trip_details.dart';
import 'package:driveforme_user/src/interfaces/main_pages/completed_trip_screens/completed_trip_details.dart';
import 'package:driveforme_user/src/interfaces/main_pages/completed_trip_screens/raise_ticket_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/scheduled_trip_screens/scheduled_trip_details.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/trip_scheduled.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/driver_rating.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/thank_you_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/payment_completed.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/trip_completed.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/trip_progress.dart';
import 'package:driveforme_user/src/interfaces/main_pages/waiting_driver/driver_found.dart';
import 'package:driveforme_user/src/interfaces/main_pages/waiting_driver/waiting_driver_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/sos/sos_countdown_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/sos/sos_help_on_way_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/sos/sos_select_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/search_loacation.dart';
import 'package:driveforme_user/src/interfaces/onboarding/login_page.dart';
import 'package:driveforme_user/src/interfaces/onboarding/registration_page.dart';
import 'package:driveforme_user/src/interfaces/onboarding/splash_screen.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/create_trip.dart';
import 'package:driveforme_user/src/interfaces/main_pages/chat/chat_screeen.dart';
import 'package:driveforme_user/src/interfaces/main_pages/profile/my_vehicles_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/profile/notifications_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/profile/personal_details_page.dart';
import 'package:driveforme_user/src/interfaces/main_pages/profile/refer_earn.dart';
import 'package:driveforme_user/src/interfaces/main_pages/profile/support_call_page.dart';
import 'package:flutter/material.dart';
//router file

enum TransitionType { slideFromBottom, slideFromRight, fade, fadeScale }

PageRouteBuilder<T> createRoute<T>(
  Widget page, {
  TransitionType? transition,
  Duration duration = const Duration(milliseconds: 300),
  RouteSettings? settings,
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: _transitionsBuilderFor(transition),
  );
}

RouteTransitionsBuilder _transitionsBuilderFor(TransitionType? type) {
  switch (type) {
    case TransitionType.slideFromRight:
      return (context, animation, secondaryAnimation, child) {
        // Professional smooth right-to-left slide
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: curved.drive(tween), child: child);
      };

    case TransitionType.fade:
      return (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        return FadeTransition(opacity: curved, child: child);
      };

    case TransitionType.fadeScale:
      return (context, animation, secondaryAnimation, child) {
        // subtle scale + fade for a polished material-like entrance
        final fadeAnim = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );
        final scaleTween = Tween<double>(
          begin: 0.98,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut));
        return FadeTransition(
          opacity: fadeAnim,
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: child,
          ),
        );
      };

    case TransitionType.slideFromBottom:
    default:
      return (context, animation, secondaryAnimation, child) {
        // Standard bottom-up slide (good for modal-ish pages)
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        final tween = Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: curved.drive(tween), child: child);
      };
  }
}

Route<dynamic> generateRoute(RouteSettings? settings) {
  Widget? page;
  TransitionType transitionToUse = TransitionType.slideFromBottom;
  Duration transitionDuration = const Duration(milliseconds: 300);

  if (settings?.arguments != null && settings!.arguments is Map) {
    final args = settings.arguments as Map;
    if (args['transition'] is TransitionType) {
      transitionToUse = args['transition'] as TransitionType;
    }
    if (args['duration'] is Duration) {
      transitionDuration = args['duration'] as Duration;
    }
  }

  switch (settings?.name) {
    case 'Splash':
      page = const SplashScreen();
      transitionToUse = TransitionType.fade;
      transitionDuration = const Duration(milliseconds: 500);
      break;
    case 'Phone':
      page = PhoneNumberScreen();
      transitionToUse = TransitionType.fade;
      transitionDuration = const Duration(milliseconds: 500);
      break;
    case 'registration':
      page = const RegistrationPage();
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'create_trip':
      page = const CreateTripPage();
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'navbar':
      page = const LocationPermissionGate(child: NavBar());
      transitionToUse = TransitionType.fade;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'booking_confirmed':
      final bookingArgs = settings?.arguments as Map?;
      page = BookingConfirmedPage(
        waitingArgs: bookingArgs == null
            ? const {}
            : Map<String, dynamic>.from(bookingArgs),
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'scheduled_trip_details':
      final detailsArgs = settings?.arguments as Map?;
      final detailsMap = detailsArgs == null
          ? const <String, dynamic>{}
          : Map<String, dynamic>.from(detailsArgs);
      final detailsScheduledAt = _routeDateTime(
        detailsMap['scheduledAt'],
        fallback: DateTime.now().add(const Duration(hours: 1)),
      );
      final hasDriver = detailsMap['hasDriver'] == true;
      page = ScheduledTripDetailsPage(
        tripTitle: detailsMap['tripTitle'] as String? ?? 'One Way Trip',
        tripId: detailsMap['tripId'] as String? ?? '—',
        tripMongoId: detailsMap['tripMongoId'] as String?,
        scheduledAt: detailsScheduledAt,
        pickup: detailsMap['pickup'] as String? ?? '—',
        dropoff: detailsMap['dropoff'] as String? ?? '—',
        distance: detailsMap['distance'] as String? ?? '—',
        duration: detailsMap['duration'] as String? ?? '—',
        vehicleType: detailsMap['vehicleType'] as String? ?? '—',
        tripFare: detailsMap['tripFare'] as String? ?? '—',
        paymentTypeLabel: detailsMap['paymentTypeLabel'] as String? ?? 'Cash',
        hasDriver: hasDriver,
        driverName: hasDriver
            ? detailsMap['driverName'] as String? ?? 'Driver'
            : null,
        driverRating: (detailsMap['driverRating'] as num?)?.toDouble() ?? 5.0,
        driverTrips: detailsMap['driverTrips'] as int? ?? 0,
        driverPhotoUrl: detailsMap['driverPhotoUrl'] as String?,
        vehicleTypes: detailsMap['vehicleTypes'] as String? ?? '—',
        isLongTrip: detailsMap['isLongTrip'] == true,
        paymentType: parseTripCompletedPaymentType(
          detailsMap['paymentType'] ??
              detailsMap['isOnlinePayment'] ??
              detailsMap['isOnline'],
        ),
        forcePickupTime: detailsMap['forcePickupTime'] == true,
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'cancelled_trip_details':
      final cancelledDetailsArgs = settings?.arguments as Map?;
      page = CancelledTripDetailsPage(
        tripTitle:
            cancelledDetailsArgs?['tripTitle'] as String? ?? 'One Way Trip',
        tripId: cancelledDetailsArgs?['tripId'] as String? ?? '# ID2562',
        tripMongoId: cancelledDetailsArgs?['tripMongoId'] as String?,
        isLongTrip: cancelledDetailsArgs?['isLongTrip'] == true,
        pickup:
            cancelledDetailsArgs?['pickup'] as String? ??
            'Edappally, Lulu Mall',
        dropoff:
            cancelledDetailsArgs?['dropoff'] as String? ?? 'Infopark, Kakkanad',
        metaLine:
            cancelledDetailsArgs?['metaLine'] as String? ??
            'April 30, 09:00 AM • 1 hrs 15 min • 12 km',
        amountPaid: cancelledDetailsArgs?['amountPaid'] as String? ?? '₹ 235',
        refundAmount:
            cancelledDetailsArgs?['refundAmount'] as String? ?? '₹ 355',
        refundInitiatedAt:
            cancelledDetailsArgs?['refundInitiatedAt'] as String? ??
            '25 April 2025, 08:45 AM',
        driverName:
            cancelledDetailsArgs?['driverName'] as String? ?? 'Ajith Kumar',
        driverRating:
            (cancelledDetailsArgs?['driverRating'] as num?)?.toDouble() ?? 4.8,
        driverTrips: cancelledDetailsArgs?['driverTrips'] as int? ?? 120,
        driverPhotoUrl: cancelledDetailsArgs?['driverPhotoUrl'] as String?,
        vehicleTypes:
            cancelledDetailsArgs?['vehicleTypes'] as String? ?? 'Manual + Auto',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'raise_ticket':
      final raiseTicketArgs = settings?.arguments as Map?;
      page = RaiseTicketPage(
        tripId: raiseTicketArgs?['tripId'] as String? ?? '# ID2562',
        tripMongoId: raiseTicketArgs?['tripMongoId'] as String?,
        category: raiseTicketArgs?['category'] as String? ?? 'General Support',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'completed_trip_details':
      final completedDetailsArgs = settings?.arguments as Map?;
      page = CompletedTripDetailsPage(
        tripTitle:
            completedDetailsArgs?['tripTitle'] as String? ?? 'One Way Trip',
        tripId: completedDetailsArgs?['tripId'] as String? ?? '# ID2562',
        tripMongoId: completedDetailsArgs?['tripMongoId'] as String?,
        isLongTrip: completedDetailsArgs?['isLongTrip'] == true,
        pickup:
            completedDetailsArgs?['pickup'] as String? ??
            'Edappally, Lulu Mall',
        dropoff:
            completedDetailsArgs?['dropoff'] as String? ?? 'Infopark, Kakkanad',
        metaLine:
            completedDetailsArgs?['metaLine'] as String? ??
            'April 30, 09:00 AM • 1 hrs 15 min • 12 km',
        tripFare: completedDetailsArgs?['tripFare'] as String? ?? '₹ 235',
        tripFareDurationLabel:
            completedDetailsArgs?['tripFareDurationLabel'] as String? ??
            '2 hrs',
        extraTimeFare:
            completedDetailsArgs?['extraTimeFare'] as String? ?? '₹ 120',
        extraTimeDurationLabel:
            completedDetailsArgs?['extraTimeDurationLabel'] as String? ??
            '30 min',
        totalPaid: completedDetailsArgs?['totalPaid'] as String? ?? '₹ 355',
        driverName:
            completedDetailsArgs?['driverName'] as String? ?? 'Ajith Kumar',
        driverRating:
            (completedDetailsArgs?['driverRating'] as num?)?.toDouble() ?? 4.8,
        driverTrips: completedDetailsArgs?['driverTrips'] as int? ?? 120,
        driverPhotoUrl: completedDetailsArgs?['driverPhotoUrl'] as String?,
        vehicleTypes:
            completedDetailsArgs?['vehicleTypes'] as String? ?? 'Manual + Auto',
        ticketSubject:
            completedDetailsArgs?['ticketSubject'] as String? ??
            CompletedTripDetailsPage.kDummyTicketSubject,
        ticketDescription:
            completedDetailsArgs?['ticketDescription'] as String? ??
            CompletedTripDetailsPage.kDummyTicketDescription,
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'wallet':
      page = const WalletPage();
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'refer_earn':
      page = const ReferEarnPage();
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'chat_screen':
      final chatArgs = settings?.arguments as Map?;
      page = ChatScreen(
        receiverId: chatArgs?['receiverId'] as String? ?? '',
        receiverName:
            chatArgs?['receiverName'] as String? ??
            chatArgs?['participantName'] as String? ??
            'Driver',
        tripId: chatArgs?['tripId'] as String?,
        participantName:
            chatArgs?['participantName'] as String? ?? 'Jacob John',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'personal_details':
      page = const PersonalDetailsPage();
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'my_vehicles':
      page = const MyVehiclesPage();
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'notifications':
      page = const NotificationsPage();
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'support_call':
      page = const SupportCallPage();
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'trip_scheduled':
      final scheduledArgs = settings?.arguments as Map?;
      final scheduledMap = scheduledArgs == null
          ? const <String, dynamic>{}
          : Map<String, dynamic>.from(scheduledArgs);
      final scheduledAt = _routeDateTime(
        scheduledMap['scheduledAt'],
        fallback: DateTime.now().add(const Duration(hours: 1)),
      );
      page = TripScheduledPage(
        scheduledAt: scheduledAt,
        bookingArgs: scheduledMap,
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'waiting_driver':
      final waitingArgs = settings?.arguments as Map?;
      page = WaitingDriverPage(
        tripMongoId: waitingArgs?['tripMongoId'] as String? ?? '',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'driver_found':
      final driverArgs = settings?.arguments as Map?;
      page = DriverFoundPage(
        tripMongoId: driverArgs?['tripMongoId'] as String? ?? '',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'payment_completed':
      final paymentDoneArgs = settings?.arguments as Map?;
      page = PaymentCompletedPage(
        paidAmount: paymentDoneArgs?['paidAmount'] as String? ?? '₹590',
        tripMongoId: paymentDoneArgs?['tripMongoId'] as String? ?? '',
        driverId: paymentDoneArgs?['driverId'] as String? ?? '',
        driverName: paymentDoneArgs?['driverName'] as String? ?? 'Driver',
        driverRating:
            (paymentDoneArgs?['driverRating'] as num?)?.toDouble() ?? 4.8,
        driverTrips: paymentDoneArgs?['driverTrips'] as int? ?? 0,
        driverPhotoUrl: paymentDoneArgs?['driverPhotoUrl'] as String?,
        vehicleTypes:
            paymentDoneArgs?['vehicleTypes'] as String? ?? 'Manual + Auto',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'driver_rating':
      final ratingArgs = settings?.arguments as Map?;
      page = DriverRatingPage(
        tripMongoId: ratingArgs?['tripMongoId'] as String? ?? '',
        driverId: ratingArgs?['driverId'] as String? ?? '',
        driverName: ratingArgs?['driverName'] as String? ?? 'Ajith Kumar',
        driverRating: (ratingArgs?['driverRating'] as num?)?.toDouble() ?? 4.8,
        driverTrips: ratingArgs?['driverTrips'] as int? ?? 120,
        driverPhotoUrl: ratingArgs?['driverPhotoUrl'] as String?,
        vehicleTypes: ratingArgs?['vehicleTypes'] as String? ?? 'Manual + Auto',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'thank_you':
      page = const ThankYouPage();
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'sos_select':
      final sosArgs = settings?.arguments as Map?;
      page = SosSelectPage(
        locationLabel:
            sosArgs?['locationLabel'] as String? ??
            sosArgs?['pickupAddress'] as String? ??
            'Live location shared . MG road, Erankulam',
        tripId: sosArgs?['tripId'] as String?,
        pickupAddress: sosArgs?['pickupAddress'] as String? ?? '',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'sos_countdown':
      final countdownArgs = settings?.arguments as Map?;
      page = SosCountdownPage(
        locationLabel:
            countdownArgs?['locationLabel'] as String? ??
            'MG Road, Eranakulam, Kochi, GPS Active',
        sosType: countdownArgs?['sosType'] as String? ?? 'Other Emergency',
        tripId: countdownArgs?['tripId'] as String?,
        pickupAddress: countdownArgs?['pickupAddress'] as String? ?? '',
        initialSeconds: countdownArgs?['initialSeconds'] as int? ?? 6,
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'sos_help_on_way':
      final helpArgs = settings?.arguments as Map?;
      page = SosHelpOnWayPage(
        referenceNumber:
            helpArgs?['referenceNumber'] as String? ?? 'SOS - 2014 - 9568',
        locationLine1:
            helpArgs?['locationLine1'] as String? ?? 'MG Road, Eranakulam',
        locationLine2:
            helpArgs?['locationLine2'] as String? ??
            'Kochi, Kerala, 9.9312 N, 76.2673 E',
        supportPhone: helpArgs?['supportPhone'] as String? ?? '+91 6282359916',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'trip_completed':
      final completedArgs = settings?.arguments as Map?;
      final paymentType = parseTripCompletedPaymentType(
        completedArgs?['paymentType'] ??
            completedArgs?['isOnlinePayment'] ??
            completedArgs?['isOnline'],
      );
      page = TripCompletedPage(
        tripMongoId: completedArgs?['tripMongoId'] as String? ?? '',
        paymentType: paymentType,
        paymentMethod: completedArgs?['paymentMethod'] as String? ?? 'cash',
        isRated: completedArgs?['isRated'] == true,
        tripTypeLabel:
            completedArgs?['tripTypeLabel'] as String? ??
            (paymentType == TripCompletedPaymentType.online
                ? 'Short Trip'
                : 'Long Trip'),
        destinationName:
            completedArgs?['destinationName'] as String? ?? 'Infopark',
        destinationAddress:
            completedArgs?['destinationAddress'] as String? ??
            'Infoparks Kerala, Infopark Kochi Phase 1, P.O, Infopark, Kochi, Kakkanad, Kerala 682042',
        totalFare: completedArgs?['totalFare'] as String? ?? '₹ 335',
        prepaidAmount: completedArgs?['prepaidAmount'] as String? ?? '₹ 255',
        prepaidDuration:
            completedArgs?['prepaidDuration'] as String? ?? '2 hrs 30 min',
        tripFare: completedArgs?['tripFare'] as String? ?? '₹ 335',
        tripDuration:
            completedArgs?['tripDuration'] as String? ?? '2 hrs 30 min',
        extraTimeAmount:
            completedArgs?['extraTimeAmount'] as String? ?? '₹ 255',
        extraTimeDuration:
            completedArgs?['extraTimeDuration'] as String? ?? '30 min',
        remainingDue: completedArgs?['remainingDue'] as String? ?? '₹ 120',
        remainingDuration:
            completedArgs?['remainingDuration'] as String? ?? '30 min',
        totalAmount: completedArgs?['totalAmount'] as String? ?? '₹ 590',
        driverId: completedArgs?['driverId'] as String? ?? '',
        driverName: completedArgs?['driverName'] as String? ?? 'Driver',
        driverRating:
            (completedArgs?['driverRating'] as num?)?.toDouble() ?? 4.8,
        driverTrips: completedArgs?['driverTrips'] as int? ?? 0,
        driverPhotoUrl: completedArgs?['driverPhotoUrl'] as String?,
        vehicleTypes: completedArgs?['vehicleTypes'] as String? ?? '',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'trip_progress':
      final tripArgs = settings?.arguments as Map?;
      page = TripProgressPage(
        tripMongoId: tripArgs?['tripMongoId'] as String? ?? '',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'search_location':
      final args = settings?.arguments as Map?;
      final String title = args?['title'] ?? 'Where are you leaving from?';
      final bool showCurrentLocation = args?['showCurrentLocation'] ?? true;
      page = SearchLocationPage(
        title: title,
        showCurrentLocation: showCurrentLocation,
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;

    default:
      if (settings?.name?.startsWith('/app') == true) {
        return PageRouteBuilder(
          opaque: false,
          settings: settings,
          pageBuilder: (context, _, _) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            });
            return const SizedBox();
          },
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      }
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => Scaffold(
          backgroundColor: kScreenBg,
          body: Center(child: Text('No path for ${settings?.name}')),
        ),
      );
  }
  return createRoute(
    page,
    transition: transitionToUse,
    duration: transitionDuration,
    settings: settings,
  );
}

extension NavigatorTransitionHelpers on NavigatorState {
  Future<T?> pushWithTransition<T>(
    Widget page, {
    TransitionType transition = TransitionType.slideFromBottom,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return push<T>(
      createRoute(page, transition: transition, duration: duration),
    );
  }
}

DateTime _routeDateTime(dynamic value, {required DateTime fallback}) {
  if (value is DateTime) return value.toLocal();
  if (value is String) {
    return DateTime.tryParse(value)?.toLocal() ?? fallback;
  }
  return fallback;
}
