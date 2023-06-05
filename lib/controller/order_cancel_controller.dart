import 'dart:convert';

import 'package:amazy_app/controller/order_controller.dart';
import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/model/Order/OrderCancelReasonModel.dart';
import 'package:amazy_app/model/Order/OrderListModel.dart';
import 'package:amazy_app/view/account/orders/MyCancellations.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class OrderCancelController extends GetxController {
  final OrderController orderController = Get.put(OrderController());

  var isLoading = false.obs;

  var cancelReasons = <CancelReason>[].obs;

  var reasonValue = CancelReason().obs;

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  Future<OrderCancelReasonModel> fetchCancelReasons() async {
    var jsonString;
    try {
      Uri userData = Uri.parse(URLs.CANCEL_REASONS);
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      jsonString = jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
    return OrderCancelReasonModel.fromJson(jsonString);
  }

  Future getCancelReasons() async {
    try {
      isLoading(true);
      var data = await fetchCancelReasons();
      if (data != null) {
        cancelReasons.value = data.reasons;
        reasonValue.value = data.reasons.first;
      }
    } catch (e) {
      print(e);
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  Future cancelOrder(Map data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);
    try {
      Uri userData = Uri.parse(URLs.ORDER_CANCEL_STORE);
      var response = await http.post(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );
      var jsonString = jsonDecode(response.body.toString());
      SnackBars().snackBarSuccess(jsonString['message'].toString());
      orderController.allOrderListModel = OrderListModel().obs;
      await orderController.getAllOrders();
      orderController.controller.animateTo(0);
      Get.to(() => MyCancellations());
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onInit() {
    getCancelReasons();
    super.onInit();
  }
}
