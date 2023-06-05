import 'package:get/get.dart';

class GiftCardController extends GetxController {
  var itemQuantity = 1.obs;

  var finalPrice = 0.0.obs;
  var productPrice = 0.0.obs;

  var minOrder = 1.obs;

  void cartIncrease() {
    itemQuantity.value++;
    finalPrice.value = productPrice.value * itemQuantity.value;
  }

  void cartDecrease() {
    itemQuantity.value--;
    finalPrice.value = productPrice.value * itemQuantity.value;
  }
}
