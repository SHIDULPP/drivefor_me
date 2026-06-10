import 'package:driveforme_user/src/data/models/user_model.dart';

String routeForOnboardingStatus(String status) {
  switch (status) {
    case 'approved':
      return 'navbar';
    case 'profile_pending':
      return 'registration';
    default:
      return 'Phone';
  }
}

String routeForUser(UserModel user) => routeForOnboardingStatus(user.onboardingStatus);
