import 'dart:convert';
import 'dart:developer';

import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/model/ErrorResponse.dart';
import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/controller/account_controller.dart';
import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/controller/my_wishlist_controller.dart';
import 'package:amazy_app/model/UserModel.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final AccountController accountController = Get.put(AccountController());
  final CartController cartController = Get.put(CartController());
  final MyWishListController _myWishListController =
      Get.put(MyWishListController());

  var isLoading = false.obs;
  var token;
  var loginMsg = "".obs;

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  var loggedIn = false.obs;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController registerEmail = TextEditingController();
  final TextEditingController registerPassword = TextEditingController();
  final TextEditingController registerConfirmPassword = TextEditingController();
  final TextEditingController referralCode = TextEditingController();

  String loadToken;

  final _googleSignIn = GoogleSignIn();

  Future<bool> checkToken() async {
    String token = await userToken.read(tokenKey);
    // await userToken.erase();
    if (token != null) {
      print('Token OK checkToken()');
    } else {
      print('Token NOT checkToken()');
    }
    if (token != null) {
      print("Logged in");
      loggedIn.value = true;
      update();
      await getProfileData();
      return true;
    } else {
      print("Login Fail");
      loggedIn.value = false;
      update();
      return false;
    }
  }

  var profileData = UserClass().obs;

  Future<UserClass> getProfileData() async {
    String token = await userToken.read(tokenKey);
    try {
      // isLoading(true);
      var products = await getProfile(token);
      if (products != null) {
        profileData.value = products;
      }
      return products;
    } finally {
      // isLoading(false);
    }
  }

  static Future<UserClass> getProfile(String token) async {
    Uri userData = Uri.parse(URLs.GET_USER);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      return UserClass.fromJson(jsonString['user']);
    } else {
      //show error message
      return null;
    }
  }

  Future<void> loadUserToken() async {
    loadToken = await loadData();
    if (loadToken != null) {
      var toke = await userToken.read(tokenKey);
      checkToken();
      return toke;
    } else {
      await userToken.remove(tokenKey);
    }
  }

  Future<String> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey);
  }

  Future<void> saveToken(String msg) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (msg.length > 5) {
      await preferences.setString(tokenKey, msg);
      await userToken.write(tokenKey, msg);
    } else {
      print("Invalid token");
    }
  }

  Future registerUser(Map data) async {
    isLoading(true);
    try {
      var loginData = await register(data);

      print('Register $loginData');

      if (loginData != null) {
        await fetchUserLogin(
                email: registerEmail.text, password: registerPassword.text)
            .then((value) {
          if (value == true) {
            Get.back(closeOverlays: true);
          }
          // if (value) {
          //   Get.offAndToNamed('/');

          //   firstName.clear();
          //   lastName.clear();
          //   registerEmail.clear();
          //   registerPassword.clear();
          //   registerConfirmPassword.clear();
          //   referralCode.clear();
          // }
        });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  static Future register(data) async {
    Uri registerUrl = Uri.parse(URLs.REGISTER);

    var body = json.encode(data);
    var response = await http.post(registerUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body);
    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return jsonString;
    } else {
      log(response.body);
      var jsonString = jsonDecode(response.body);

      if (jsonString['message'] == "The given data was invalid.") {
        final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));

        SnackBars().snackBarError("${errorResponse.message}");
      } else {
        SnackBars().snackBarError("${jsonString['message']}");
      }
    }
  }

  Future<bool> fetchUserLogin({String email, String password}) async {
    try {
      isLoading(true);
      var loginData = await login(email, password);
      if (loginData != null) {
        token = loginData['token'];
        if (token.length > 5) {
          await saveToken(token);
          await loadUserToken();
          await accountController.getAccountDetails();
          await cartController.getCartList();
          await _myWishListController.getAllWishList();
          isLoading(false);
          return true;
        } else {
          isLoading(false);
          return false;
        }
      } else {
        isLoading(false);
        return false;
      }
    } finally {
      isLoading(false);
    }
  }

  static Future login(email, password) async {
    Uri loginUrl = Uri.parse(URLs.LOGIN);
    Map data = {"email": email.toString(), "password": password.toString()};
    var body = json.encode(data);
    var response = await http.post(loginUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body);
    log(response.body);
    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return jsonString;
    } else {
      var jsonString = jsonDecode(response.body);

      if (jsonString['message'] == "The given data was invalid.") {
        final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));

        SnackBars().snackBarError("${errorResponse.message}");
      } else {
        SnackBars().snackBarError("${jsonString['message']}");
      }
    }
  }

  Future<bool> socialLogin(Map data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    Uri loginUrl = Uri.parse(URLs.SOCIAL_LOGIN);

    var body = json.encode(data);
    var response = await http.post(loginUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body);
    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 200) {
      token = jsonString['token'];

      if (token.length > 5) {
        await userToken.write("method", "${data['provider']}");

        await saveToken(token);
        await loadUserToken();
        await accountController.getAccountDetails();
        await cartController.getCartList();
        await _myWishListController.getAllWishList();

        EasyLoading.dismiss();
        return true;
      } else {
        return false;
      }
    } else if (response.statusCode == 401) {
      EasyLoading.dismiss();
      var jsonString = jsonDecode(response.body);

      if (jsonString['message'] == "The given data was invalid.") {
        final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));

        SnackBars().snackBarError("${errorResponse.message}");
      } else {
        SnackBars().snackBarError("${jsonString['message']}");
      }
    } else {
      EasyLoading.dismiss();
      var jsonString = jsonDecode(response.body);

      if (jsonString['message'] == "The given data was invalid.") {
        final errorResponse = ErrorResponse.fromJson(jsonDecode(response.body));

        SnackBars().snackBarError("${errorResponse.message}");
      } else {
        SnackBars().snackBarError("${jsonString['message']}");
      }
    }

    return false;
  }

  Future<void> removeToken() async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    final CartController cartController = Get.put(CartController());

    try {
      isLoading(true);

      String token = await userToken.read(tokenKey);

      Uri logoutUrl = Uri.parse(URLs.LOGOUT);
      var response = await http.post(
        logoutUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      var jsonString = jsonDecode(response.body);
      if (jsonString['message'] == 'Logged out successfully') {
        EasyLoading.dismiss();

        var jsonString = jsonDecode(response.body);

        SnackBars().snackBarSuccess("${jsonString['message']}");

        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove(tokenKey);
        await userToken.remove(tokenKey);

        await _googleSignIn.signOut();

        await FacebookAuth.instance.logOut();

        print("User logged Out");
        // cartController.getCartList();
        await checkToken();
        loginMsg.value = 'Logged out';
        update();
        isLoading(false);
        cartController.getCartList();
        _myWishListController.getAllWishList();
        return jsonString;
      } else {
        EasyLoading.dismiss();
        var jsonString = jsonDecode(response.body);

        if (jsonString['message'] == "The given data was invalid.") {
          final errorResponse =
              ErrorResponse.fromJson(jsonDecode(response.body));

          SnackBars().snackBarError("${errorResponse.message}");
        } else {
          SnackBars().snackBarError("${jsonString['message']}");
        }
        isLoading(false);
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoading(false);
    } finally {
      EasyLoading.dismiss();
      isLoading(false);
    }
  }

  Future<dynamic> forgotPassword() async {
    var body = jsonEncode({
      'email': email.text,
    });

    var response = await http.post(
      Uri.parse(URLs.FORGOT_PASSWORD),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body,
    );

    var jsonString = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return jsonString['message'];
    }
  }

  RxBool obscrure = true.obs;

  @override
  void onInit() {
    checkToken();
    if (AppConfig.isDemo) {
      email.text = "customer2@gmail.com";
      password.text = "12345678";
    }
    super.onInit();
  }
}
