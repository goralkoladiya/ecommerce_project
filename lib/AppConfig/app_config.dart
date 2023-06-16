import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/Customer/CustomerData.dart';

class AppConfig {
  // static const String hostUrl = 'https://amazy.rishfa.com';
  static const String hostUrl = 'https://ecommerce.yoursoftwaredemo.com';

  static String appName = 'MeghalayanAge';

  static String loginBackgroundImage = 'assets/config/login_bg.png';

  static String splashScreenLogo = 'assets/config/splash_logo.png';

  static String appLogo = 'assets/config/app_logo.png';

  static String appBanner = 'assets/config/app_banner.png';

  static String appBarIcon = 'assets/config/appbar_icon.png';

  static const String assetPath = hostUrl + '/public';

  static Color loginScreenBackgroundGradient1 = Color(0xffFF3566);

  static Color loginScreenBackgroundGradient2 = Color(0xffD7365C);

  static String appColorScheme = "#FD4949";

  static String appColorSchemeGradient1 = '#FD4949';
  
  static String appColorSchemeGradient2 = '#d20000';

  static const String privacyPolicyUrl =
      'https://ecommerce.yoursoftwaredemo.com/privacy-policy';

  static bool googleLogin = true;

  static bool facebookLogin = true;

  static bool appleLogin = false;

  static bool isDemo = false;




}
