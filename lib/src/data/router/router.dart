import 'package:driveforme_user/src/interfaces/main_pages/navbar.dart';
import 'package:driveforme_user/src/interfaces/main_pages/trip_pages/booking_confirmed.dart';
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
  TransitionType? transitionToUse;
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
      page = const NavBar();
      transitionToUse = TransitionType.fade;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'booking_confirmed':
      final bookingArgs = settings?.arguments as Map?;
      page = BookingConfirmedPage(
        paymentType: parseTripCompletedPaymentType(
          bookingArgs?['paymentType'] ??
              bookingArgs?['isOnlinePayment'] ??
              bookingArgs?['isOnline'],
        ),
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'trip_scheduled':
      final scheduledArgs = settings?.arguments as Map?;
      final scheduledAtRaw = scheduledArgs?['scheduledAt'];
      final scheduledAt = scheduledAtRaw is DateTime
          ? scheduledAtRaw
          : DateTime.now().add(const Duration(hours: 1));
      page = TripScheduledPage(
        scheduledAt: scheduledAt,
        tripId: scheduledArgs?['tripId'] as String? ?? '#ID2562',
        pickup: scheduledArgs?['pickup'] as String? ?? 'Edappally, Lulu mall',
        dropoff: scheduledArgs?['dropoff'] as String? ?? 'Infopark',
        paymentType: parseTripCompletedPaymentType(
          scheduledArgs?['paymentType'] ??
              scheduledArgs?['isOnlinePayment'] ??
              scheduledArgs?['isOnline'],
        ),
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'waiting_driver':
      final waitingArgs = settings?.arguments as Map?;
      page = WaitingDriverPage(
        tripTitle: waitingArgs?['tripTitle'] as String? ?? 'One Way Trip',
        tripId: waitingArgs?['tripId'] as String? ?? '#ID2562',
        paymentType: parseTripCompletedPaymentType(
          waitingArgs?['paymentType'] ??
              waitingArgs?['isOnlinePayment'] ??
              waitingArgs?['isOnline'],
        ),
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'driver_found':
      final driverArgs = settings?.arguments as Map?;
      page = DriverFoundPage(
        tripTitle: driverArgs?['tripTitle'] as String? ?? 'One Way Trip',
        tripId: driverArgs?['tripId'] as String? ?? '# ID2562',
        pickup: driverArgs?['pickup'] as String? ?? 'Edappally',
        dropoff: driverArgs?['dropoff'] as String? ?? 'Infopark',
        price: driverArgs?['price'] as String? ?? '₹ 235',
        distance: driverArgs?['distance'] as String? ?? '12 km',
        duration: driverArgs?['duration'] as String? ?? '2 hrs',
        driverName: driverArgs?['driverName'] as String? ?? 'Ajith Kumar',
        driverRating:
            (driverArgs?['driverRating'] as num?)?.toDouble() ?? 4.8,
        driverTrips: driverArgs?['driverTrips'] as int? ?? 120,
        vehicleTypes:
            driverArgs?['vehicleTypes'] as String? ?? 'Manual + Auto',
        paymentType: parseTripCompletedPaymentType(
          driverArgs?['paymentType'] ??
              driverArgs?['isOnlinePayment'] ??
              driverArgs?['isOnline'],
        ),
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'payment_completed':
      final paymentDoneArgs = settings?.arguments as Map?;
      page = PaymentCompletedPage(
        paidAmount: paymentDoneArgs?['paidAmount'] as String? ?? '₹590',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'driver_rating':
      final ratingArgs = settings?.arguments as Map?;
      page = DriverRatingPage(
        driverName: ratingArgs?['driverName'] as String? ?? 'Ajith Kumar',
        driverRating: (ratingArgs?['driverRating'] as num?)?.toDouble() ?? 4.8,
        driverTrips: ratingArgs?['driverTrips'] as int? ?? 120,
        vehicleTypes:
            ratingArgs?['vehicleTypes'] as String? ?? 'Manual + Auto',
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
        locationLabel: sosArgs?['locationLabel'] as String? ??
            'Live location shared . MG road, Erankulam',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'sos_countdown':
      final countdownArgs = settings?.arguments as Map?;
      page = SosCountdownPage(
        locationLabel: countdownArgs?['locationLabel'] as String? ??
            'MG Road, Eranakulam, Kochi, GPS Active',
        initialSeconds: countdownArgs?['initialSeconds'] as int? ?? 6,
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'sos_help_on_way':
      final helpArgs = settings?.arguments as Map?;
      page = SosHelpOnWayPage(
        referenceNumber: helpArgs?['referenceNumber'] as String? ??
            'SOS - 2014 - 9568',
        locationLine1: helpArgs?['locationLine1'] as String? ??
            'MG Road, Eranakulam',
        locationLine2: helpArgs?['locationLine2'] as String? ??
            'Kochi, Kerala, 9.9312 N, 76.2673 E',
        supportPhone:
            helpArgs?['supportPhone'] as String? ?? '+91 6282359916',
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
        paymentType: paymentType,
        tripTypeLabel: completedArgs?['tripTypeLabel'] as String? ??
            (paymentType == TripCompletedPaymentType.online
                ? 'Short Trip'
                : 'Long Trip'),
        destinationName:
            completedArgs?['destinationName'] as String? ?? 'Infopark',
        destinationAddress: completedArgs?['destinationAddress'] as String? ??
            'Infoparks Kerala, Infopark Kochi Phase 1, P.O, Infopark, Kochi, Kakkanad, Kerala 682042',
        totalFare: completedArgs?['totalFare'] as String? ?? '₹ 335',
        prepaidAmount: completedArgs?['prepaidAmount'] as String? ?? '₹ 255',
        prepaidDuration:
            completedArgs?['prepaidDuration'] as String? ?? '2 hrs 30 min',
        tripFare: completedArgs?['tripFare'] as String? ?? '₹ 335',
        tripDuration: completedArgs?['tripDuration'] as String? ?? '2 hrs 30 min',
        extraTimeAmount:
            completedArgs?['extraTimeAmount'] as String? ?? '₹ 255',
        extraTimeDuration:
            completedArgs?['extraTimeDuration'] as String? ?? '30 min',
        remainingDue: completedArgs?['remainingDue'] as String? ?? '₹ 120',
        remainingDuration:
            completedArgs?['remainingDuration'] as String? ?? '30 min',
        totalAmount: completedArgs?['totalAmount'] as String? ?? '₹ 590',
      );
      transitionToUse = TransitionType.slideFromRight;
      transitionDuration = const Duration(milliseconds: 400);
      break;
    case 'trip_progress':
      final tripArgs = settings?.arguments as Map?;
      page = TripProgressPage(
        tripTitle: tripArgs?['tripTitle'] as String? ?? 'One Way Trip',
        tripId: tripArgs?['tripId'] as String? ?? '# ID2562',
        headingTo: tripArgs?['headingTo'] as String? ?? 'Infopark',
        driverName: tripArgs?['driverName'] as String? ?? 'Ajith Kumar',
        driverRating: (tripArgs?['driverRating'] as num?)?.toDouble() ?? 4.8,
        driverTrips: tripArgs?['driverTrips'] as int? ?? 120,
        vehicleTypes: tripArgs?['vehicleTypes'] as String? ?? 'Manual + Auto',
        completedStops: tripArgs?['completedStops'] as int? ?? 3,
        showTimeLimitReached: tripArgs?['showTimeLimitReached'] as bool? ?? true,
        pickup: tripArgs?['pickup'] as String? ?? 'Edappally',
        dropoff: tripArgs?['dropoff'] as String? ?? 'Infopark',
        price: tripArgs?['price'] as String? ?? '₹ 235',
        distance: tripArgs?['distance'] as String? ?? '12 km',
        duration: tripArgs?['duration'] as String? ?? '2 hrs 30 min',
        paymentType: parseTripCompletedPaymentType(
          tripArgs?['paymentType'] ??
              tripArgs?['isOnlinePayment'] ??
              tripArgs?['isOnline'],
        ),
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
          backgroundColor: Colors.grey[100],
          body: Center(child: Text('No path for ${settings?.name}')),
        ),
      );
  }
  if (transitionToUse == null) {
    return MaterialPageRoute(settings: settings, builder: (_) => page!);
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
