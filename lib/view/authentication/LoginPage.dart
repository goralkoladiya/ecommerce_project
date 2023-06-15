import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/otp_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/controller/login_controller.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/authentication/ForgotPassword.dart';
import 'package:amazy_app/view/authentication/OtpVerificationPage.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../MainNavigation.dart';
import 'RegistrationPage.dart';

// ignore: must_be_immutable
class LoginPage extends GetView<LoginController> {
  final _googleSignIn = GoogleSignIn();

  FirebaseAuth auth = FirebaseAuth.instance;

  final LoginController _loginController = Get.put(LoginController());

  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());

  // ignore: unused_field
  Map<String, dynamic> _userData;
  AccessToken _accessToken;

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      body: Obx(() {
        if (_loginController.loggedIn.value == true) {
          Get.back();
        }
        return Container(
          height: Get.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 10),
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppConfig.appLogo,
                      width: 33,
                      height: 33,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      AppConfig.appName,
                      style: AppStyles.appFontBold.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Login Your Account'.tr,
                    style: AppStyles.appFontBold.copyWith(
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Enter your email and password to access your account or create an account.'
                        .tr,
                    textAlign: TextAlign.center,
                    style: AppStyles.appFontBook.copyWith(
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: TextFormField(
                    controller: _loginController.email,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email'.tr,
                      hintStyle: AppStyles.appFontMedium,
                      prefixIcon: Container(
                        height: 10,
                        width: 10,
                        padding: EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/email.png',
                        ),
                      ),
                      errorStyle: AppStyles.appFontMedium
                          .copyWith(color: AppStyles.pinkColor, fontSize: 12),
                    ),
                    keyboardType: TextInputType.text,
                    style: AppStyles.appFontMedium,
                    maxLines: 1,
                    validator: (value) {
                      if (value.length == 0) {
                        return 'Please Type your email'.tr + '...';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: TextFormField(
                    controller: _loginController.password,
                    obscureText: _loginController.obscrure.value,
                    decoration: InputDecoration(
                      hintText: 'Password'.tr,
                      hintStyle: AppStyles.appFontMedium,
                      prefixIcon: Container(
                        height: 10,
                        width: 10,
                        padding: EdgeInsets.all(12),
                        child: Image.asset(
                          'assets/images/lock.png',
                        ),
                      ),
                      errorStyle: AppStyles.appFontMedium
                          .copyWith(color: AppStyles.pinkColor, fontSize: 12),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _loginController.obscrure.value =
                              !_loginController.obscrure.value;
                        },
                        child: Icon(
                          _loginController.obscrure.value
                              ? FontAwesomeIcons.solidEyeSlash
                              : FontAwesomeIcons.solidEye,
                          color: Color(0xffBBBBBB),
                          size: 18,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: AppStyles.appFontMedium,
                    maxLines: 1,
                    validator: (value) {
                      if (value.length == 0) {
                        return 'Please Type your password.'.tr + '..';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: _loginController.isLoading.value
                      ? Center(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: CupertinoActivityIndicator()))
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: InkWell(
                            onTap: () async {
                              if (_settingsController.otpOnLogin.value) {
                                Map data = {
                                  "type": "otp_on_login",
                                  "email": _loginController.email.value.text,
                                  "password":
                                      _loginController.password.value.text,
                                };

                                final OtpController otpController =
                                    Get.put(OtpController());

                                _loginController.isLoading.value = true;

                                await otpController
                                    .generateOtp(data)
                                    .then((value) {
                                  if (value == true) {
                                    _loginController.isLoading.value = false;
                                    Get.to(() => OtpVerificationPage(
                                          data: data,
                                          onSuccess: (result) async {
                                            if (result == true) {
                                              var jsonString =
                                                  await _loginController
                                                      .fetchUserLogin(
                                                          email:
                                                              _loginController
                                                                  .email.text,
                                                          password:
                                                              _loginController
                                                                  .password
                                                                  .text)
                                                      .then((value) {
                                                if (value == true) {
                                                  Get.back(closeOverlays: true);
                                                }
                                              });
                                              print(jsonString);
                                            }
                                          },
                                        ));
                                  } else {
                                    _loginController.isLoading.value = false;
                                    SnackBars()
                                        .snackBarWarning(value.toString());
                                  }
                                });
                              } else {
                                var jsonString = await _loginController
                                    .fetchUserLogin(
                                        email: _loginController.email.text,
                                        password:
                                            _loginController.password.text)
                                    .then((value) {
                                  if (value == true) {
                                    Get.back(closeOverlays: true);
                                  }
                                });
                                print(jsonString);
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: Get.width,
                              height: 50,
                              decoration: BoxDecoration(
                                  gradient: AppStyles.gradient,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Login'.tr,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.appFontBook.copyWith(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ForgotPasswordPage());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'Forgot password?'.tr,
                      style: AppStyles.appFontMedium.copyWith(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        color: AppStyles.pinkColor,
                      ),
                    ),
                  ),
                ),
                AppConfig.appleLogin ||
                        AppConfig.googleLogin ||
                        AppConfig.facebookLogin
                    ? Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            child: Text(
                              '..Or continue with'.tr,
                              style: AppStyles.appFontMedium.copyWith(
                                fontSize: 16,
                                color: AppStyles.greyColorLight,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35, vertical: 5),
                            child: Expanded(
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AppConfig.facebookLogin
                                    ? InkWell(
                                  onTap: () async {
                                    final LoginResult result =
                                    await FacebookAuth.instance
                                        .login(); // by default we request the email and the public profile
                                    if (result.status ==
                                        LoginStatus.success) {
                                      _accessToken = result.accessToken;
                                      _printCredentials();

                                      final userData = await FacebookAuth
                                          .instance
                                          .getUserData();
                                      _userData = userData;

                                      final _getToken =
                                      FacebookResponse.fromJson(
                                          _accessToken.toJson());

                                      final _getUser =
                                      FacebookUser.fromJson(userData);

                                      Map data = {
                                        "provider_id": _getUser.id,
                                        "provider_name": "facebook",
                                        "name": _getUser.name,
                                        "email": _getUser.email,
                                        "token":
                                        _getToken.token.toString(),
                                      };

                                      print(data);

                                      await _loginController
                                          .socialLogin(data)
                                          .then((value) async {
                                        if (value == true) {
                                          Get.back();
                                        } else {
                                          await FacebookAuth.instance
                                              .logOut();
                                        }
                                      });
                                    } else {
                                      print(result.status);
                                      print(result.message);
                                    }
                                  },
                                  child: Container(
                                    width: 140,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xff969599),
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: Image.asset(
                                            'assets/images/facebook_logo.png',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Facebook'.tr,
                                          style: AppStyles.appFontBold
                                              .copyWith(
                                            fontSize: 15,
                                            color: AppStyles
                                                .greyColorLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                    : SizedBox.shrink(),
                                SizedBox(
                                  width: 20,
                                ),
                                AppConfig.googleLogin
                                    ? InkWell(
                                  onTap: ()

                                  async {
                                    print("Login Enter:");
                                    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

                                    googleSignInAccount.authentication.then((value) async {
                                      log("token :${value.idToken.toString()}");
                                      log("name :${googleSignInAccount.displayName}",);

                                      Map data = {
                                        "provider_id": googleSignInAccount.id,
                                        "provider_name": "google",
                                        "name": googleSignInAccount.displayName,
                                        "email": googleSignInAccount.email,
                                        "token": value.idToken.toString(),
                                      };

                                      _loginController.socialLogin(data).then((value) {
                                        print("data: ${_loginController.socialLogin(data)}");
                                        print(value);

                                        if (value == true) {
                                          print("login::");
                                          print(value);

                                          Navigator.push(context, MaterialPageRoute(builder: (context){
                                            return Card();
                                          }));
                                        } else {
                                          print("logout::");
                                          _googleSignIn.signOut();
                                        }
                                      });
                                    });
                                  },
                                  child: Container(
                                    width: 140,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xff969599),
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: Image.asset(
                                            'assets/images/google_logo.png',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Google'.tr,
                                          style: AppStyles.appFontBold
                                              .copyWith(
                                            fontSize: 15,
                                            color:
                                            AppStyles.greyColorLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                    : SizedBox.shrink(),
                              ],
                            ),)
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          (Platform.isIOS && AppConfig.appleLogin)
                              ? InkWell(
                                  onTap: () async {
                                    final credential = await SignInWithApple
                                        .getAppleIDCredential(
                                      scopes: [
                                        AppleIDAuthorizationScopes.email,
                                        AppleIDAuthorizationScopes.fullName,
                                      ],
                                    );

                                    print(credential);
                                  },
                                  child: Container(
                                    width: Get.width * 0.4,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xff969599),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: Icon(
                                            FontAwesomeIcons.apple,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Apple'.tr,
                                          style: AppStyles.appFontBold.copyWith(
                                            fontSize: 16,
                                            color: AppStyles.greyColorLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      )
                    : SizedBox.shrink(),

                SizedBox(
                  height: 10,
                ),

                // sign up
                GestureDetector(
                  onTap: () {
                    Get.dialog(RegistrationPage(), useSafeArea: false);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Don\'t have an account?'.tr,
                            style: AppStyles.appFontMedium.copyWith(
                              color: AppStyles.greyColorLight,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: '  ' + 'Sign Up'.tr,
                            style: AppStyles.appFontMedium.copyWith(
                              color: AppStyles.pinkColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _printCredentials() {
    print(
      prettyPrint(_accessToken.toJson()),
    );
  }
}

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

FacebookResponse facebookResponseFromJson(String str) =>
    FacebookResponse.fromJson(json.decode(str));

String facebookResponseToJson(FacebookResponse data) =>
    json.encode(data.toJson());

class FacebookResponse {
  FacebookResponse({
    this.userId,
    this.token,
  });

  String userId;
  String token;

  factory FacebookResponse.fromJson(Map<String, dynamic> json) =>
      FacebookResponse(
        userId: json["userId"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "token": token,
      };
}

FacebookUser facebookUserFromJson(String str) =>
    FacebookUser.fromJson(json.decode(str));

String facebookUserToJson(FacebookUser data) => json.encode(data.toJson());

class FacebookUser {
  FacebookUser({
    this.email,
    this.id,
    this.name,
  });

  String email;
  String id;
  String name;

  factory FacebookUser.fromJson(Map<String, dynamic> json) => FacebookUser(
        email: json["email"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "name": name,
      };
}
