import 'package:get/get.dart';
import 'package:indianhub/ui/account/load_fund_ui.dart';
import 'package:indianhub/ui/account/my-account.dart';
import 'package:indianhub/ui/account/withdraw_fund_ui.dart';
import 'package:indianhub/ui/mybets/my_bets_ui.dart';
import 'package:indianhub/ui/referred_users.dart';
import '../ui/ui.dart';
import '../ui/auth/auth.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(name: '/', page: () => SplashUI()),
    GetPage(name: '/signin', page: () => SignInUI()),
    GetPage(name: '/signup', page: () => SignUpUI()),
    GetPage(name: '/home', page: () => HomeUI()),
    GetPage(name: '/settings', page: () => SettingsUI()),
    GetPage(name: '/reset-password', page: () => ResetPasswordUI()),
    GetPage(name: '/update-profile', page: () => UpdateProfileUI()),
    GetPage(name: '/referred-users', page: () => ReferredUsers()),
    GetPage(name: '/my-bets', page: () => MyBets()),
    GetPage(name: '/my-account', page: () => MyAccount()),
    GetPage(name: '/withdraw-fund', page:()=> WithdrawFund()),
    GetPage(name: 'load-fund', page: ()=>LoadFund())
  ];
}
