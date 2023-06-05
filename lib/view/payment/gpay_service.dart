import 'dart:developer';

import 'package:amazy_app/AppConfig/api_keys.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/view/payment/stripe/stripe_payment.dart';
import 'package:get/get.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:http/http.dart' as http;

class GooglePaymentIntentConfirm {
  final GeneralSettingsController currencyController = Get.put(GeneralSettingsController());
  final String postCreateIntentURL = "$stripeServerURL/payment-intent-gpay";

  final Stripe stripe = Stripe(
    "$stripePublishableKey",
    // returnUrlForSca: "stripesdk://3ds.stripesdk.io",
  );

  Future<StripeIntentResponse> postGpayPaymentIntent(
      {String email, String token, String orderAmount}) async {
    final amount = (double.parse(orderAmount) * 100).toInt();
    print("AMOUNT => $amount");
    final url = Uri.parse(postCreateIntentURL +
        "?amount=$amount&email=$email&gpayToken=$token&currency=${currencyController.currencyCode.value.toLowerCase()}");
    print("URL is $url");
    http.Response response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    print('response status code => ${response.statusCode}');
    print("---" * 12);
    final stripeIntentResponse = stripeIntentResponseFromJson(response.body);

    log(stripeIntentResponse.toJson().toString());
    return stripeIntentResponse;
  }
}
