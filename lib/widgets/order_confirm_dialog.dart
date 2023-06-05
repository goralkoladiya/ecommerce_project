import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/controller/checkout_controller.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/account/orders/OrderList/MyOrders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderConfirmedDialog extends StatefulWidget {
  @override
  State<OrderConfirmedDialog> createState() => _OrderConfirmedDialogState();
}

class _OrderConfirmedDialogState extends State<OrderConfirmedDialog> {
  final CheckoutController checkoutController = Get.put(CheckoutController());
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () async {
      await checkoutController.getCheckoutList();
      // Get.delete<CheckoutController>();

      // Get.delete<PaymentGatewayController>();
      await cartController.getCartList().then((value) {
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        Get.to(() => MyOrders(0));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Image.asset(
            'assets/images/order_success.png',
            height: 150,
            width: 150,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Order Successful".tr,
            style: AppStyles.appFontBold.copyWith(fontSize: 22),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Your Order is successfully placed. So you can track your order".tr,
            textAlign: TextAlign.center,
            style: AppStyles.appFontBook.copyWith(
              fontSize: 14,
              color: AppStyles.greyColorAlt,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}
