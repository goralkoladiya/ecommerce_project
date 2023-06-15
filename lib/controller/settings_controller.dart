import 'dart:convert';
import 'dart:developer';

import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/model/Currency.dart';
import 'package:amazy_app/model/GeneralSettingsModel.dart';
import 'package:amazy_app/model/Product/GiftCardData.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/model/Product/ProductType.dart';
import 'package:amazy_app/view/MainNavigation.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../view/SplashScreen.dart';
import 'cart_controller.dart';
import 'login_controller.dart';
import 'my_wishlist_controller.dart';

class GeneralSettingsController extends GetxController {
  var isLoading = false.obs;
  var appCurrency = ''.obs;
  var conversionRate = 0.0.obs;
  var generalCurrencyCode = ''.obs;
  var currencyName = ''.obs;
  var currencyCode = ''.obs;
  var errorMsg = "".obs;
  var connected = false.obs;
  Rx<String> vendorType = ''.obs;
  var currenciesList = <Currency>[].obs;
  var currency = Currency().obs;

  Dio _dio = Dio();

  String priceText;
  DateTime endDate = DateTime.now();

  Rx<GeneralSettingsModel> settingsModel = GeneralSettingsModel().obs;

  Rx<bool> otpModuleEnabled = false.obs;

  Rx<int> otpCodeValidationTime = 0.obs;

  Rx<bool> otpOnCustomerRegistration = false.obs;

  Rx<bool> otpOnLogin = false.obs;

  Rx<bool> otpOnPasswordReset = false.obs;

  Rx<bool> otpOnOrderWithCod = false.obs;

  Rx<bool> otpOrderOnVerifiedCustomer = false.obs;

  Rx<int> orderCancelLimitOnVerified = 0.obs;

  Rx<bool> goldPriceModule = false.obs;

  Rx<bool> multivendorModule = false.obs;

  GetStorage userToken = GetStorage();
  var tokenKey = 'token';
  final LoginController loginController = Get.put(LoginController());
  final CartController cartController = Get.put(CartController());
  final MyWishListController _myWishListController = Get.put(MyWishListController());
  final _googleSignIn = GoogleSignIn();


  Future<GeneralSettingsModel> getGeneralSettings() async {
    try {
      isLoading(true);
      await loadData().then((value) async {
        String uri = URLs.GENERAL_SETTINGS;

        var response = await _dio.get(
          uri,
          options: buildCacheOptions(
            Duration(minutes: 2),
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          ),
        );

        if (response.statusCode == 200) {
          var data = new Map<String, dynamic>.from(response.data);
          log("object... ");
          log("object... $data  <<<");
          settingsModel.value = GeneralSettingsModel.fromJson(data);
          log("hey: ${settingsModel.value}");
          print("object...1");
          if (settingsModel.value.msg == 'success') {
            print("fff");
            generalCurrencyCode.value = settingsModel.value.settings.currencyCode;

            currenciesList.value = settingsModel.value.currencies;
            currency.value = settingsModel.value.currencies.where((element) => element.code == generalCurrencyCode.value).first;
            appCurrency.value = currency.value.symbol.toString();
            conversionRate.value = double.parse(currency.value.convertRate).toPrecision(2);

            print(" conversionRate.value :: ${ conversionRate.value}");
            currencyName.value = currency.value.name;
            currencyCode.value = currency.value.code;
            vendorType.value = settingsModel.value.vendorType;

            if (settingsModel.value.otpConfiguration != null) {
              otpModuleEnabled.value = true;

              otpCodeValidationTime.value = int.parse(settingsModel
                  .value.otpConfiguration
                  .firstWhere(
                      (element) => element.type == 'code_validation_time')
                  .value
                  .toString());

              if (settingsModel.value.otpConfiguration
                      .firstWhere((element) =>
                          element.type == 'otp_on_customer_registration')
                      .value ==
                  1) {
                otpOnCustomerRegistration.value = true;
              } else {
                otpOnCustomerRegistration.value = false;
              }

              if (settingsModel.value.otpConfiguration
                      .firstWhere((element) => element.type == 'otp_on_login')
                      .value ==
                  1) {
                otpOnLogin.value = true;
              } else {
                otpOnLogin.value = false;
              }
              if (settingsModel.value.otpConfiguration
                      .firstWhere(
                          (element) => element.type == 'otp_on_password_reset')
                      .value ==
                  1) {
                otpOnPasswordReset.value = true;
              } else {
                otpOnPasswordReset.value = false;
              }
              if (settingsModel.value.otpConfiguration
                      .firstWhere(
                          (element) => element.type == 'otp_on_order_with_cod')
                      .value ==
                  1) {
                otpOnOrderWithCod.value = true;
              } else {
                otpOnOrderWithCod.value = false;
              }
              if (settingsModel.value.otpConfiguration
                      .firstWhere((element) =>
                          element.type == 'order_otp_on_verified_customer')
                      .value ==
                  1) {
                otpOrderOnVerifiedCustomer.value = true;
              } else {
                otpOrderOnVerifiedCustomer.value = false;
              }
              orderCancelLimitOnVerified.value = settingsModel
                  .value.otpConfiguration
                  .firstWhere((element) =>
                      element.type == 'order_cancel_limit_on_verified_customer')
                  .value;
            }

            //* Module check

          settingsModel.value.modules.forEach((key, value) {
            if (key == "GoldPrice") {
              if (value) {
                goldPriceModule.value = true;
              } else {
                goldPriceModule.value = false;
              }
            }
            if (key == "MultiVendor") {
              if (value) {
                multivendorModule.value = true;
              } else {
                multivendorModule.value = false;
              }
            }
          });

          print("GOLDPRICE MODUEL => ${goldPriceModule.value}");
          print("MultiVendor MODUEL => ${multivendorModule.value}");

            Map otpConfig = {
              'otp_configuration': otpModuleEnabled,
              'code_validation_time': otpCodeValidationTime,
              'otp_on_customer_registration': otpOnCustomerRegistration,
              'otp_on_password_reset': otpOnPasswordReset,
              'otp_on_login': otpOnLogin,
              'otp_on_order_with_cod': otpOnOrderWithCod,
              'order_otp_on_verified_customer': otpOrderOnVerifiedCustomer,
            };
            log(otpConfig.toString());

            isLoading(false);
          }
        } else {
          SnackBars().snackBarError('Something went wrong.');
        }
      });
    } catch (e) {
      print(e);
      throw e.toString();
    }
    return settingsModel.value;
  }

  /// Account Delete Api Call
  Future deleteAccount() async {
    String token = await userToken.read(tokenKey);
    String uri = URLs.USER_DELETE;

    print('url --->>> ${URLs.USER_DELETE}');
    print('token --->>> $token');

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var request = http.MultipartRequest('POST', Uri.parse(uri));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responseString = await response.stream.bytesToString();
    if (response.statusCode == 200) {

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove(tokenKey);
      await userToken.remove(tokenKey);

      await _googleSignIn.signOut();

      await FacebookAuth.instance.logOut();

      print("User logged Out");
      // cartController.getCartList();

      await loginController.checkToken();
      loginController.loginMsg.value = 'Logged out';
      update();
      isLoading(false);
      cartController.getCartList();
      _myWishListController.getAllWishList();
      // SnackBars().snackBarSuccess(responseString);
      // print('response false: $responseString');
    } else {
      SnackBars().snackBarError(response.reasonPhrase);
      Get.back();
      print('response false: ${response.reasonPhrase}');
    }
  }

  Future loadData() async {
    try {
      isLoading(true);
      final response = await http
          .get(Uri.parse(URLs.CHECK), headers: {'Accept': 'application/json'} );
      var decode = jsonDecode(response.body);
      isLoading(false);
      connected.value = decode;
      return connected.value;
    } catch (e) {
      connected.value = false;
      isLoading(false);
      errorMsg.value = "Something went wrong";
      throw e.toString();
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    _dio.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: AppConfig.hostUrl)).interceptor);
    getGeneralSettings();
    super.onInit();
  }

  String calculateMainPrice(ProductModel productModel) {
    String amountText;

    if (productModel.productType == ProductType.GIFT_CARD) {
      amountText = double.parse(
                  (productModel.giftCardSellingPrice * conversionRate.value)
                      .toString())
              .toStringAsFixed(2) +
          appCurrency.value;
    } else {
      if (productModel.hasDiscount == 'yes' || productModel.hasDeal != null) {
        if (productModel.product.productType == 1) {
          amountText = double.parse(
                      (productModel.maxSellingPrice * conversionRate.value).toString()).toStringAsFixed(2) + appCurrency.value;
        } else {
          amountText = double.parse(
                      (productModel.maxSellingPrice * conversionRate.value).toString()).toStringAsFixed(2) + appCurrency.value;
        }
      } else {
        amountText = '';
      }
    }

    return amountText;
  }

  String calculatePrice222(ProductModel prod) {
    // log("ProductModel=$prod \t");
    //
    // print("prod.discountType ${prod.discountType.runtimeType}");
    // print("prod.giftCardSellingPrice :${prod.productName}\t ${prod.giftCardSellingPrice.runtimeType}");
    // if (prod.productType == ProductType.GIFT_CARD) {
    //   if (prod.giftCardEndDate.compareTo(DateTime.now()) > 0) {
    //     print("priceText1:: ${singlePrice(sellingPrice(prod.giftCardSellingPrice, prod.discountType, double.parse(prod.discount)))}");
    //     priceText = singlePrice(sellingPrice(
    //         prod.giftCardSellingPrice, prod.discountType, double.parse(prod.discount))).toStringAsFixed(2);
    //
    //   } else {
    //     print("priceText2:: ${singlePrice(prod.giftCardSellingPrice).toStringAsFixed(2)}");
    //     priceText = singlePrice(prod.giftCardSellingPrice).toStringAsFixed(2);
    //   }
    // }
    // else {

      // print("prod.skus.first.sellingPrice ${prod.skus.first.sellingPrice.runtimeType}");
      // print("prod.hasDeal.discountType ${prod.hasDeal.discountType.runtimeType}");
    //   print("prod.hasDeal.discount ${prod.hasDeal.discount.runtimeType}");
    // print("prod.minSellPrice : ${prod.minSellPrice.runtimeType}");
    // print("prod.maxSellingPrice : ${prod.maxSellingPrice.runtimeType}");
    // print("prod.discountType : ${prod.discountType}");

      if (prod.hasDeal != null) {
        if (prod.product.productType == 1) {
          print("priceTex3:: ${singlePrice(sellingPrice(double.parse(prod.skus.first.sellingPrice), prod.hasDeal.discountType, prod.hasDeal.discount))}");
          print("prod.hasDeal.discount ${prod.hasDeal.discount.runtimeType}");
          priceText = singlePrice(sellingPrice(double.parse(prod.skus.first.sellingPrice),
              prod.hasDeal.discountType,prod.hasDeal.discount)).toStringAsFixed(2);
        } else {
          if (sellingPrice(double.parse(prod.minSellPrice), prod.hasDeal.discountType, prod.hasDeal.discount) ==
              sellingPrice(double.parse(prod.maxSellingPrice), prod.hasDeal.discountType, prod.hasDeal.discount)) {
            print("priceText4:: ${singlePrice(sellingPrice(double.parse(prod.minSellPrice), prod.hasDeal.discountType, prod.hasDeal.discount))}");
            priceText = singlePrice(sellingPrice(double.parse(prod.minSellPrice),
                prod.hasDeal.discountType, prod.hasDeal.discount))
                .toStringAsFixed(2);
          } else {
            // print("${prod.productName} -- ${prod.product.productType} -- Max: ${prod.maxSellingPrice} -- Min: ${prod.minSellPrice}");
            print("priceText5:: ${singlePrice(sellingPrice(double.parse(prod.minSellPrice), prod.hasDeal.discountType, prod.hasDeal.discount))}");

            priceText = singlePrice(sellingPrice(double.parse(prod.minSellPrice),
                prod.hasDeal.discountType, prod.hasDeal.discount))
                .toStringAsFixed(2);
          }
        }
      } else {
        if (prod.product.productType == 1) {
          if (prod.hasDiscount == 'yes') {
            print("priceText6:: ${singlePrice(sellingPrice(double.parse(prod.maxSellingPrice), prod.discountType, double.parse(prod.discount)))}");

            priceText = singlePrice(sellingPrice(
                double.parse(prod.maxSellingPrice), prod.discountType, double.parse(prod.discount)))
                .toStringAsFixed(2);
          } else {
            priceText = singlePrice(double.parse(prod.maxSellingPrice)).toStringAsFixed(2);
            print("priceText7::${singlePrice(double.parse(prod.maxSellingPrice)).toStringAsFixed(2)}");
          }
        }
        else {
          ///variant product
          // print ("disctyp : ${prod.discount.runtimeType}");
          // print ("prod.maxSellingPrice : ${prod.maxSellingPrice.runtimeType}");
          // print ("prod.minSellingPrice : ${prod.minSellPrice.runtimeType}");
          if (sellingPrice(double.parse(prod.minSellPrice), prod.discountType, double.parse(prod.discount)) ==
              sellingPrice(prod.maxSellingPrice, prod.discountType, double.parse(prod.discount))) {
            if (prod.hasDiscount == 'yes') {
              priceText = singlePrice(sellingPrice(double.parse(prod.skus.first.sellingPrice),
                  prod.discountType, double.parse(prod.discount)))
                  .toStringAsFixed(2);
            } else {
              priceText = singlePrice(double.parse(prod.skus.first.sellingPrice)).toStringAsFixed(2);
            }
          }
          else {
            double priceA;

            if (prod.hasDiscount == 'yes') {
              print("priceText AA:: ${(sellingPrice(double.parse(prod.minSellPrice), double.parse(prod.discountType),double.parse(prod.discount)))}");
              priceA = singlePrice(sellingPrice(double.parse(prod.minSellPrice), double.parse(prod.discountType),double.parse( prod.discount)));

            } else {
              // print("priceT
              priceA = singlePrice(double.parse(prod.minSellPrice));
              // priceB = singlePrice(prod.maxSellingPrice).toStringAsFixed(2);
            }
            priceText = '$priceA';

            // print("priceText8:: $priceText");
          }
        }
      }
    // }
    // print("priceText9::${priceText}");
    return priceText;
  }


  String calculatePrice(ProductModel prod) {
    print("ProductModel=$prod");
    if (prod.productType == ProductType.GIFT_CARD) {
      if (prod.giftCardEndDate.compareTo(DateTime.now()) > 0) {
        print("priceText1:: ${singlePrice(sellingPrice(prod.giftCardSellingPrice, prod.discountType, double.parse(prod.discount)))}");
        priceText = singlePrice(sellingPrice(
                prod.giftCardSellingPrice, prod.discountType, double.parse(prod.discount)))
            .toStringAsFixed(2);

      } else {
        print("priceText2:: ${singlePrice(prod.giftCardSellingPrice).toStringAsFixed(2)}");
        priceText = singlePrice(prod.giftCardSellingPrice).toStringAsFixed(2);
      }
    }
    else {
      if (prod.hasDeal != null) {
        if (prod.product.productType == 1) {
          print("priceTex3:: ${singlePrice(sellingPrice(double.parse(prod.skus.first.sellingPrice), prod.hasDeal.discountType, prod.hasDeal.discount))}");
          priceText = singlePrice(sellingPrice(double.parse(prod.skus.first.sellingPrice),
              prod.hasDeal.discountType, prod.hasDeal.discount)).toStringAsFixed(2);
        } else {
          if (sellingPrice(double.parse(prod.minSellPrice), prod.hasDeal.discountType, prod.hasDeal.discount) ==
              sellingPrice(double.parse(prod.maxSellingPrice), prod.hasDeal.discountType, prod.hasDeal.discount)) {
            print("priceText4:: ${singlePrice(sellingPrice(double.parse(prod.minSellPrice), prod.hasDeal.discountType, prod.hasDeal.discount))}");
            priceText = singlePrice(sellingPrice(double.parse(prod.minSellPrice),
                    prod.hasDeal.discountType, prod.hasDeal.discount))
                .toStringAsFixed(2);
          } else {
            // print("${prod.productName} -- ${prod.product.productType} -- Max: ${prod.maxSellingPrice} -- Min: ${prod.minSellPrice}");
            print("priceText5:: ${singlePrice(sellingPrice(double.parse(prod.minSellPrice), prod.hasDeal.discountType, prod.hasDeal.discount))}");

            priceText = singlePrice(sellingPrice(double.parse(prod.minSellPrice),
                    prod.hasDeal.discountType, prod.hasDeal.discount))
                .toStringAsFixed(2);
          }
        }
      } else {
        if (prod.product.productType == 1) {
          if (prod.hasDiscount == 'yes') {
            print("priceText6:: ${singlePrice(sellingPrice(double.parse(prod.maxSellingPrice), prod.discountType, double.parse(prod.discount)))}");

            priceText = singlePrice(sellingPrice(
                    double.parse(prod.maxSellingPrice), prod.discountType, double.parse(prod.discount)))
                .toStringAsFixed(2);
          } else {
            priceText = singlePrice(double.parse(prod.maxSellingPrice)).toStringAsFixed(2);
             print("priceText7::${singlePrice(double.parse(prod.maxSellingPrice)).toStringAsFixed(2)}");
          }
        } else {
          ///variant product
          print ("ssmaxSellingPrice : ${prod.maxSellingPrice}");
          if (sellingPrice(double.parse(prod.minSellPrice), prod.discountType, double.parse(prod.discount)) ==
              sellingPrice(prod.maxSellingPrice, prod.discountType, double.parse(prod.discount))) {
            if (prod.hasDiscount == 'yes') {
              priceText = singlePrice(sellingPrice(double.parse(prod.skus.first.sellingPrice),
                      prod.discountType, double.parse(prod.discount)))
                  .toStringAsFixed(2);
            } else {
              priceText =
                  singlePrice(double.parse(prod.skus.first.sellingPrice)).toStringAsFixed(2);
            }
          } else {
            dynamic priceA;
            // var priceB;
            if (prod.hasDiscount == 'yes') {
              print("priceText A:: ${singlePrice(sellingPrice(double.parse(prod.minSellPrice), prod.discountType, double.parse(prod.discount))).toStringAsFixed(2)}");
              priceA = singlePrice(sellingPrice(double.parse(prod.minSellPrice), prod.discountType, double.parse(prod.discount))).toStringAsFixed(2);
              // priceB = singlePrice(sellingPrice(
              //         prod.maxSellingPrice, prod.discountType, double.parse(prod.discount)))
              //     .toStringAsFixed(2);
            } else {
              print("priceText AE:: ${singlePrice(double.parse(prod.minSellPrice)).toStringAsFixed(2)}");
              priceA = singlePrice(double.parse(prod.minSellPrice)).toStringAsFixed(2);
              // priceB = singlePrice(prod.maxSellingPrice).toStringAsFixed(2);
            }
            priceText = '$priceA';

            print("priceText8:: $priceText");
          }
        }
      }
    }
    print("priceText9::${priceText}");
    return priceText;
  }

  String calculateMainPriceWithVariant(ProductModel productModel) {
    String amountText;

    if (productModel.hasDiscount == 'yes' || productModel.hasDeal != null) {
      if (productModel.product.productType == 1) {
        amountText = double.parse((productModel.maxSellingPrice * conversionRate.value).toString()).toStringAsFixed(2) +
            appCurrency.value;
      } else {
        double conversion= conversionRate.value;
        amountText = double.parse((productModel.minSellPrice * conversion.toInt()).toString()).toStringAsFixed(2) +
            appCurrency.value + ' - ' +
            double.parse((productModel.maxSellingPrice * conversion).toString()).toStringAsFixed(2) + appCurrency.value;
      }
    } else {
      amountText = '';
    }
    return amountText;
  }

  String calculatePriceWithVariant(ProductModel prod) {
    if (prod.hasDeal != null) {
      if (prod.product.productType == 1) {
        print("priceText10:: ${singlePrice(sellingPrice(double.parse(prod.skus.first.sellingPrice),
            prod.hasDeal.discountType, prod.hasDeal.discount)).toStringAsFixed(2)}");

        priceText = singlePrice(sellingPrice(double.parse(prod.skus.first.sellingPrice),
                prod.hasDeal.discountType, prod.hasDeal.discount)).toStringAsFixed(2);
      } else {
        if (sellingPrice(double.parse(prod.minSellPrice), prod.hasDeal.discountType,
                prod.hasDeal.discount) == sellingPrice(double.parse(prod.maxSellingPrice), prod.hasDeal.discountType,
            prod.hasDeal.discount)) {

          print("priceText11:: ${singlePrice(sellingPrice(double.parse(prod.minSellPrice),
              prod.hasDeal.discountType, prod.hasDeal.discount)).toStringAsFixed(2)}");
          priceText = singlePrice(sellingPrice(double.parse(prod.minSellPrice),
                  prod.hasDeal.discountType, prod.hasDeal.discount))
              .toStringAsFixed(2);
        } else {

          print("priceText12:: ${singlePrice(sellingPrice(double.parse(prod.minSellPrice),
              prod.hasDeal.discountType, prod.hasDeal.discount)).toStringAsFixed(2)}");

          priceText = singlePrice(sellingPrice(double.parse(prod.minSellPrice),
                  prod.hasDeal.discountType, prod.hasDeal.discount))
              .toStringAsFixed(2);
        }
      }
    } else {
      if (prod.product.productType == 1) {
        if (prod.hasDiscount == 'yes') {

          print("priceText13:: ${singlePrice(sellingPrice(double.parse(prod.minSellPrice),
          prod.discountType, double.parse(prod.discount))).toStringAsFixed(2)}");

          priceText = singlePrice(sellingPrice(
                  double.parse(prod.maxSellingPrice), prod.discountType, double.parse(prod.discount))).toStringAsFixed(2);
        } else {
          priceText = singlePrice(double.parse(prod.maxSellingPrice)).toStringAsFixed(2);
          print("priceText14:: ${singlePrice(double.parse(prod.maxSellingPrice)).toStringAsFixed(2)}");
        }
      } else {
        ///variant product
        if (sellingPrice(double.parse(prod.minSellPrice), prod.discountType, double.parse(prod.discount)) ==
            sellingPrice(double.parse(prod.maxSellingPrice), prod.discountType, double.parse(prod.discount))) {
          if (prod.hasDiscount == 'yes') {
            priceText = singlePrice(sellingPrice(double.parse(prod.skus.first.sellingPrice),
                prod.discountType, double.parse(prod.discount))).toStringAsFixed(2);
            print("priceText15:: ${priceText = singlePrice(sellingPrice(double.parse(prod.skus.first.sellingPrice),
                prod.discountType, double.parse(prod.discount))).toStringAsFixed(2)}");

          } else {
            priceText =
                singlePrice(double.parse(prod.skus.first.sellingPrice)).toStringAsFixed(2);
            print("priceText16:: ${singlePrice(double.parse(prod.skus.first.sellingPrice)).toStringAsFixed(2)}");
          }
        } else {
          var priceA;
          var priceB;
          if (prod.hasDiscount == 'yes') {
            priceA = singlePrice(sellingPrice(double.parse(prod.skus.first.sellingPrice),
                    prod.discountType, double.parse(prod.discount))).toStringAsFixed(2);
            priceB = singlePrice(sellingPrice(prod.skus.last.sellingPrice,
                    prod.discountType, double.parse(prod.discount))).toStringAsFixed(2);

            print("priceText17:: $priceA");
            print("priceText18:: $priceB");

          } else {
            priceA = singlePrice(double.parse(prod.skus.first.sellingPrice)).toStringAsFixed(2);
            priceB = singlePrice(prod.skus.last.sellingPrice).toStringAsFixed(2);

            print("priceText19:: $priceA");
            print("priceText20:: $priceB");
          }
          priceText = '$priceA - $priceB';
          print("priceText21:: $priceText");
        }
      }
    }
    return priceText;
  }

  String calculateGiftcardPrice(ProductModel prod) {

   String price = "";
    if (prod.giftCardEndDate.compareTo(DateTime.now()) > 0) {
      price = singlePrice(sellingPrice(prod.giftCardSellingPrice, prod.discountType, double.parse(prod.discount))).toStringAsFixed(2);
      print("priceText :::: $price");
    } else {
      price = singlePrice(prod.giftCardSellingPrice).toStringAsFixed(2);
      print("priceText :::: $price");
    }
    return price;
  }

  String calculateWishListGiftcardPrice(GiftCardData giftCardData) {
    String price = "";
    price = double.parse((giftCardData.sellingPrice * conversionRate.value).toString()).toStringAsFixed(2) + appCurrency.value;
    return price;
  }

  double sellingPrice(amount, discountType, double discountAmount) {
    double discount = 0.0;
    if (discountType == "0" || discountType == 0) {
      discount = (amount / 100) * double.parse(discountAmount.toString());

      // print("discount0 :::: $discount");
      // print("discountAmount0 :::: $discountAmount");
      // print("amount0 :::: $amount");
    }
    if (discountType == "1" || discountType == 1) {
      discount = double.parse(discountAmount.toString());

      // print("discount1 :::: $discount");
      // print("discountAmount 1:::: $discountAmount");
      // print("amount1 :::: $amount");

    }
    // print("dis-amount : ${discountAmount.runtimeType}");
    amount=amount.toString().substring(0,amount.toString().length-2);

    dynamic sellingPrice = double.parse(amount) - discount;
    // print("sellingPrice ::: $sellingPrice");
    return sellingPrice;

  }

  double singlePrice(double price) {
    return price * conversionRate.value;
  }

// dynamic getMin(List<ProductSkus> skus) {
//   skus.sort((u2, u1) => u2.sellingPrice.toInt() - u1.sellingPrice.toInt());
//   return skus.first.sellingPrice;
// }
//
// dynamic getMax(List<ProductSkus> skus) {
//   skus.sort((u1, u2) => u2.sellingPrice.toInt() - u1.sellingPrice.toInt());
//   return skus.first.sellingPrice;
// }
}
