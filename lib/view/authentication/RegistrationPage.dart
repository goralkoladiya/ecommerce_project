import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/login_controller.dart';
import 'package:amazy_app/controller/otp_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/authentication/ForgotPassword.dart';
import 'package:amazy_app/view/authentication/OtpVerificationPage.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationPage extends GetView<LoginController> {
  final LoginController _accountController = Get.put(LoginController());

  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Container(
          height: Get.height,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                            Get.close(1);
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
                      'Create An Account'.tr,
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
                      'Signup with your own active email and new password or login your account'
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.firstName,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        hintText: 'First Name'.tr,
                        hintStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 14,
                        ),
                        prefixIcon: Container(
                          height: 10,
                          width: 10,
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/images/person.png',
                          ),
                        ),
                        errorStyle: AppStyles.appFontMedium
                            .copyWith(color: AppStyles.pinkColor, fontSize: 12),
                      ),
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      style: AppStyles.appFontMedium,
                      validator: (value) {
                        if (value.length == 0) {
                          return 'Please Type something'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.lastName,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        hintText: 'Last Name'.tr,
                        hintStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 14,
                        ),
                        prefixIcon: Container(
                          height: 10,
                          width: 10,
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/images/person.png',
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
                          return 'Please Type something'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.registerEmail,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        hintText: 'Email'.tr,
                        hintStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 14,
                        ),
                        prefixIcon: Container(
                          height: 10,
                          width: 10,
                          alignment: Alignment.center,
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
                          return 'Please Type something'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.registerPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        hintText: 'Password'.tr,
                        hintStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 14,
                        ),
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
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.appFontMedium,
                      maxLines: 1,
                      validator: (value) {
                        if (value.length == 0) {
                          return 'Please Type something'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.registerConfirmPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        hintText: 'Confirm Password'.tr,
                        hintStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 14,
                        ),
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
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.appFontMedium,
                      maxLines: 1,
                      validator: (value) {
                        if (value.length == 0) {
                          return 'Please Type something'.tr;
                        } else if (controller.registerPassword.text != value) {
                          return 'Password must be the same'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.referralCode,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        hintText: 'Refferal Code (optional)'.tr,
                        hintStyle: AppStyles.appFontBook.copyWith(
                          fontSize: 14,
                        ),
                        prefixIcon: Container(
                          height: 10,
                          width: 10,
                          padding: EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/images/my_review.png',
                          ),
                        ),
                        errorStyle: AppStyles.appFontMedium
                            .copyWith(color: AppStyles.pinkColor, fontSize: 12),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.appFontMedium,
                      maxLines: 1,
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: _accountController.isLoading.value
                        ? Center(
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                child: CupertinoActivityIndicator()))
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState.validate()) {
                                  Map registrationData = {
                                    "first_name": controller.firstName.text,
                                    "last_name": controller.lastName.text,
                                    "email": controller.registerEmail.text,
                                    "referral_code":
                                        controller.referralCode.text ?? '',
                                    "password":
                                        controller.registerPassword.text,
                                    "password_confirmation":
                                        controller.registerConfirmPassword.text,
                                    "user_type": "customer"
                                  };

                                  if (_settingsController
                                      .otpOnCustomerRegistration.value) {
                                    Map data = {
                                      "type": "otp_on_customer_registration",
                                      "email": controller.registerEmail.text,
                                      "first_name": controller.firstName.text,
                                    };

                                    final OtpController otpController =
                                        Get.put(OtpController());

                                    _accountController.isLoading.value = true;

                                    await otpController
                                        .generateOtp(data)
                                        .then((value) {
                                      if (value == true) {
                                        _accountController.isLoading.value =
                                            false;
                                        Get.to(() => OtpVerificationPage(
                                              data: data,
                                              onSuccess: (result) async {
                                                if (result == true) {
                                                  await _accountController
                                                      .registerUser(
                                                          registrationData);
                                                }
                                              },
                                            ));
                                      } else {
                                        _accountController.isLoading.value =
                                            false;
                                        SnackBars()
                                            .snackBarWarning(value.toString());
                                      }
                                    });
                                  } else {
                                    await _accountController
                                        .registerUser(registrationData);
                                  }
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
                                    'Sign Up'.tr,
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
                  GestureDetector(
                    onTap: () => Get.to(() => ForgotPasswordPage()),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Forgot password'.tr + '?',
                        style: AppStyles.kFontWhite14w5,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
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
                              text: 'Already have an account?'.tr,
                              style: AppStyles.appFontMedium.copyWith(
                                color: AppStyles.greyColorLight,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: '  ' + 'Login'.tr,
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
                  SizedBox(
                    height: Get.height * 0.07,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
