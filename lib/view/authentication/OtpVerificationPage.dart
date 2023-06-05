import 'dart:async';
import 'package:amazy_app/controller/otp_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class OtpVerificationPage extends StatefulWidget {
  final Function(bool) onSuccess;
  final Map data;

  OtpVerificationPage({this.data, this.onSuccess});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {

  final OtpController _otpController = Get.put(OtpController());

  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());

  final CountDownController _countDownController = CountDownController();

  String enteredOtp;

  bool timedOut = false;

  int _validationTime;

  // Timer _timer;

  @override
  void initState() {
    _validationTime = _settingsController.otpCodeValidationTime.value * 60;
    Future.delayed(Duration(seconds: 1), () {
      _countDownController.start();
    });
    super.initState();
  }

  // void startTimer() {
  //   setState(() {
  //     _timer = Timer.periodic(
  //       const Duration(seconds: 1),
  //       (Timer timer) {
  //         if (_validationTime == 0) {
  //           setState(() {
  //             timedOut = true;
  //             timer.cancel();
  //           });
  //         } else {
  //           setState(() {
  //             _validationTime--;
  //           });
  //         }
  //       },
  //     );
  //   });
  // }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(child: Container()),
                CircularCountDownTimer(
                  duration: _validationTime,
                  initialDuration: 0,
                  controller: _countDownController,
                  width: 40,
                  height: 40,
                  ringColor: Colors.grey[300],
                  ringGradient: null,
                  fillColor: AppStyles.pinkColor,
                  fillGradient: null,
                  backgroundColor: Colors.white,
                  backgroundGradient: null,
                  strokeWidth: 4.0,
                  strokeCap: StrokeCap.round,
                  textStyle: TextStyle(
                    fontSize: 10.0,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  textFormat: CountdownTextFormat.MM_SS,
                  isReverse: true,
                  isReverseAnimation: true,
                  isTimerTextShown: true,
                  autoStart: false,
                  onComplete: () {
                    setState(() {
                      timedOut = true;
                      // _timer.cancel();
                    });
                  },
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            Center(
              child: Image.asset(
                'assets/images/otp.png',
                width: 100,
                height: 100,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                'Verification Code',
                textAlign: TextAlign.left,
                style: AppStyles.appFontBold.copyWith(
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'We sent 6 digit code to your email address please check & enter your code',
                textAlign: TextAlign.center,
                style: AppStyles.appFontBook.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  selectedFillColor: AppStyles.textFieldFillColor,
                  activeColor: AppStyles.textFieldFillColor,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  borderWidth: 1,
                ),
                animationDuration: Duration(milliseconds: 300),
                cursorColor: Colors.black,
                cursorWidth: 1.0,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                enableActiveFill: true,
                onChanged: (String value) {
                  if (value != null) {
                    enteredOtp = value.toString();
                  }
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      decoration: BoxDecoration(
                        gradient: AppStyles.gradient,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Submit".tr,
                        style: AppStyles.appFontMedium.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onTap: () {
                      if (timedOut == true) {
                        SnackBars().snackBarWarning(
                          "OTP Timed out. Please resend OTP".tr,
                        );
                      } else {
                        bool isCorrectOTP =
                            _otpController.resultChecker(int.parse(enteredOtp));

                        if (isCorrectOTP) {
                          Get.back(result: widget.onSuccess(true));
                        } else {
                          SnackBars().snackBarWarning(
                            "OTP does not match".tr,
                          );
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        timedOut = false;

                        // _timer.cancel();

                        _validationTime =
                            _settingsController.otpCodeValidationTime.value *
                                60;
                      });

                      await _otpController
                          .generateOtp(widget.data)
                          .then((value) {
                        if (value) {
                          _countDownController.restart();
                        }
                      });
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Didn\'t receive the code?'.tr,
                            style: AppStyles.appFontMedium.copyWith(
                              color: AppStyles.greyColorLight,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: '  ' + 'Resend'.tr,
                            style: AppStyles.appFontMedium.copyWith(
                              color: AppStyles.pinkColor,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}
