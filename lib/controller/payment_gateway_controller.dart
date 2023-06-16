import 'dart:convert';
import 'dart:developer';

import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/controller/checkout_controller.dart';
import 'package:amazy_app/model/BankInformationModel.dart';
import 'package:amazy_app/model/Product/ProductType.dart';
import 'package:amazy_app/model/PaymentGatewayModel.dart';
import 'package:amazy_app/model/PaymentStoreModel.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:amazy_app/widgets/order_confirm_dialog.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PaymentGatewayController extends GetxController {
  final CheckoutController checkoutController = Get.put(CheckoutController());
  final CartController cartController = Get.put(CartController());

  var isPaymentGatewayLoading = false.obs;
  var gateway = PaymentGatewayModel().obs;

  var bank = BankInformationModel().obs;

  var gatewayList = <Gateway>[].obs;

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  var paymentProcessing = false.obs;

  DIO.Response response;
  DIO.Dio dio = new DIO.Dio();

  Rx<Gateway> selectedGateway = Gateway().obs;

  Future<PaymentGatewayModel> getPaymentGateway() async {
    Uri userData = Uri.parse(URLs.PAYMENT_GATEWAY);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    var jsonString = jsonDecode(response.body);
    return PaymentGatewayModel.fromJson(jsonString);
  }

  Future<BankInformationModel> getBankInfo() async {
    Uri userData = Uri.parse(URLs.BANK_INFO);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    var jsonString = jsonDecode(response.body);
    var bankInfo = BankInformationModel.fromJson(jsonString);
    bank.value = bankInfo;
    return bank.value;
  }

  Future<PaymentGatewayModel> getGatewayList() async {
    try {
      isPaymentGatewayLoading(true);
      var gateways = await getPaymentGateway();
      if (gateways != null) {
        gateway.value = gateways;

        gatewayList.value = gateways.data
            .where((element) => element.activeStatus == "1")
            .toList();

        checkoutController.checkoutModel.value.packages.forEach((key, value) {
          value.items.forEach((value2) {
            if (value2.productType == ProductType.GIFT_CARD) {
              gatewayList.remove(gatewayList[0]);
            }
          });
        });
        selectedGateway.value = gatewayList.first;
      } else {
        gateway.value = PaymentGatewayModel();
      }
      return gateways;
    } finally {
      isPaymentGatewayLoading(false);
    }
  }

  RxBool isPaymentProcessing = false.obs;

  Future paymentInfoStore(
      {Map paymentData, Map orderData, String transactionID}) async {
    isPaymentProcessing(true);
    String token = await userToken.read(tokenKey);
    Uri userData = Uri.parse(URLs.ORDER_PAYMENT_STORE);

    if (transactionID == null) {
      paymentData.addAll(
          {'transection_id': 'AMZ-${DateTime.now().millisecondsSinceEpoch}'});
    }
    var body = json.encode(paymentData);
    log(body.toString());
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    log(response.statusCode.toString());
    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 201) {
      var data = PaymentStore.fromJson(jsonString);

      orderData.addAll({
        'payment_id': data.paymentInfo.id,
      });

      await submitOrder(orderData);

      return true;
    } else {
      SnackBars().snackBarError(jsonString['message']);
      return false;
    }
  }

  Future submitOrder(data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    final m = new Map<String, dynamic>.from(data);

    final DIO.FormData formData = DIO.FormData.fromMap(m);

    log(jsonEncode(data));

    try {
      response = await dio.post(URLs.ORDER_STORE,
          options: DIO.Options(
            followRedirects: false,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data',
            },
          ),
          data: formData);
      log(response.statusCode.toString());
      log(response.data.toString());

      if (response.statusCode == 201) {
        SnackBars().snackBarSuccess("Order created successfully");

        Get.dialog(OrderConfirmedDialog());
        // await checkoutController.getCheckoutList();
        // Get.delete<CheckoutController>();
        // await cartController.getCartList();

        // Get.offAndToNamed('/');

        // Get.to(() => MyOrders(0));
      }
    } on DIO.DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.response);
        SnackBars().snackBarError(e.response.statusMessage);
      }
    }

    EasyLoading.dismiss();
    // Get.offAndToNamed('/');
    // Get.to(() => MainNavigation(
    //   navIndex: 2,
    // ));
  }

  @override
  void onInit() {
    getGatewayList();
    super.onInit();
  }
}
