import 'package:businessbuddy/presentation/home_screen/widget/business/view/my_business_details.dart';
import 'package:businessbuddy/presentation/profile/widget/edit_profile.dart';
import 'package:businessbuddy/presentation/profile/widget/following_list.dart';
import '../presentation/profile/view/profile_screen.dart';
import '../utils/exported_path.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: Routes.splash, page: () => SplashScreen()),
    GetPage(name: Routes.onboarding, page: () => IntroScreen()),
    GetPage(name: Routes.login, page: () => LoginScreen()),
    GetPage(name: Routes.verify, page: () => VerifyOtpScreen()),
    GetPage(name: Routes.register, page: () => RegisterScreen()),
    GetPage(name: Routes.mainScreen, page: () => NavigationScreen()),
    GetPage(name: Routes.addOffer, page: () => AddOffer()),
    GetPage(name: Routes.addPost, page: () => AddPost()),
    GetPage(name: Routes.businessDetails, page: () => BusinessDetails()),
    GetPage(name: Routes.profile, page: () => ProfileScreen()),
    GetPage(name: Routes.editProfile, page: () => EditProfile()),
    GetPage(name: Routes.followingList, page: () => FollowingList()),
    // GetPage(name: Routes.helpSupport, page: () => HelpSupport()),
    // GetPage(name: Routes.deleteAccount, page: () => DeleteAccount()),
    GetPage(name: Routes.notificationList, page: () => NotificationList()),
  ];
}
