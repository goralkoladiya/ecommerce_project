import 'dart:convert';

import 'package:amazy_app/model/Order/OrderData.dart';
import 'package:amazy_app/network/config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class OrderTrackController extends GetxController{

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  Future<OrderData> trackOrder(orderId) async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CHECKOUT);

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
      return OrderData.fromJson(jsonString['order']);
    } else {
      return null;
    }
  }
}