import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';
//import 'package:firebase_analytics/observer.dart';
import 'package:indianhub/controllers/controllers.dart';
import 'package:indianhub/controllers/referral_controller.dart';
import 'package:indianhub/constants/constants.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  Get.put<ReferralController>(ReferralController());
  Get.put<AuthController>(AuthController());
  Get.put<ThemeController>(ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeController.to.getThemeModeFromStore();
    return GetMaterialApp(
          navigatorObservers: [
            // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
          ],
          debugShowCheckedModeBanner: false,
          //defaultTransition: Transition.fade,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: "/",
          getPages: AppRoutes.routes,
    );
  }
}
