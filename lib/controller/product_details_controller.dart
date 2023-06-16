import 'dart:convert';
import 'dart:developer';

import 'package:amazy_app/network/config.dart';

import 'package:amazy_app/model/Product/ProductDetailsModel.dart';
import 'package:amazy_app/model/Product/ProductSkus.dart';
import 'package:amazy_app/model/Product/ProductType.dart';
import 'package:amazy_app/model/Product/Review.dart';
import 'package:amazy_app/model/ShippingMethod/ShippingMethodElement.dart';
import 'package:amazy_app/model/Product/SellerSkuModel.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as DIO;

class ProductDetailsController extends GetxController {
  var products = ProductDetailsModel().obs;

  var isLoading = false.obs;

  var productId = "0".obs;

  // ignore: deprecated_member_use
  var productReviews = List<Review>().obs;

  // ignore: deprecated_member_use
  var giftCardReviews = List<Review>().obs;

  var visibleSKU = ProductSku().obs;

  var productSKU = SkuData().obs;

  var isSkuLoading = false.obs;

  var finalPrice = 0.0.obs;
  var productPrice = 0.0.obs;

  double discount;
  String discountType;

  var itemQuantity = 1.obs;

  var minOrder = "1".obs;
  var maxOrder = "1".obs;

  var productSkuID = "0".obs;

  var shippingID = 0.obs;

  Map getSKU = {};

  var stockManage = "0".obs;
  var stockCount = 0.obs;
  var isCartLoading = false.obs;

  var shippingValue = ShippingMethodElement().obs;

  Future fetchProductDetails(id) async {
    log("${URLs.ALL_PRODUCTS + '/$id'}");
    try {
      Uri userData = Uri.parse(URLs.ALL_PRODUCTS + '/$id');
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      var jsonString = jsonDecode(response.body);
      if (jsonString['message'] != 'not found') {
        return ProductDetailsModel.fromJson(jsonString);
      } else {
        Get.back();
        SnackBars().snackBarWarning('not found');
      }
    } catch (e) {
      print(e);
    }
    return ProductDetailsModel();
  }

  Future<ProductDetailsModel> getProductDetails2(id) async {
    try {
      isCartLoading(true);
      var data = await fetchProductDetails(id);
      if (data != null) {
        print("fetch=$data");
        products.value = data;
        productReviews.value = data.data.reviews
            .where((element) => element.type == ProductType.PRODUCT)
            .toList();
        visibleSKU.value = products.value.data.product.skus.first;

        if (products.value.data.discountStartDate != null &&
            products.value.data.discountStartDate != '') {
          var endDate =
              DateTime.parse('${products.value.data.discountEndDate}');
          if (endDate.millisecondsSinceEpoch <
              DateTime.now().millisecondsSinceEpoch) {
            discount = 0;
          } else {
            discount = double.parse(products.value.data.discount);
          }
        } else {
          discount = double.parse(products.value.data.discount);
        }
        discountType = products.value.data.discountType;
        minOrder.value = products.value.data.product.minimumOrderQty;
        maxOrder.value = products.value.data.product.maxOrderQty;

        itemQuantity.value = int.parse(products.value.data.product.minimumOrderQty);

        if (products.value.data.variantDetails.length > 0) {
          await skuGet();
        } else {
          stockManage.value = products.value.data.stockManage;
          stockCount.value = int.parse(products.value.data.skus.first.productStock);
          visibleSKU.value = products.value.data.product.skus.first;
        }
        productSkuID.value = products.value.data.skus.first.productSkuId;
      }
      else {
        products.value = ProductDetailsModel();
      }
      calculatePrice();
    } catch (e) {
      print(e.toString());
      isCartLoading(false);
    } finally {
      isCartLoading(false);
    }

    return products.value;
  }

  Future skuGet() async {
    for (var i = 0; i < products.value.data.variantDetails.length; i++) {
      getSKU.addAll({
        'id[$i]':
            "${products.value.data.variantDetails[i].attrValId.first}-${products.value.data.variantDetails[i].attrId}"
      });
    }
    getSKU.addAll({
      'product_id': products.value.data.id,
      'user_id': products.value.data.userId
    });
    await getSkuWisePrice(getSKU);
  }

  Future getSkuWisePrice(Map data) async {
    try {
      isSkuLoading(true);
      DIO.Response response;
      DIO.Dio dio = new DIO.Dio();
      var formData = DIO.FormData();
      data.forEach((k, v) {
        formData.fields.add(MapEntry(k, v.toString()));
      });
      response = await dio.post(
        URLs.PRODUCT_PRICE_SKU_WISE,
        options: DIO.Options(
          followRedirects: false,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: formData,
      );
      if (response.data == "0") {
        SnackBars().snackBarWarning('Product not available');
        getProductDetails2(data['product_id']).then((value) {
          itemQuantity.value = int.parse(products.value.data.product.minimumOrderQty);
          productId.value = data['product_id'];
        });
      } else {
        final returnData = new Map<String, dynamic>.from(response.data);
        discount = double.parse(returnData['data']['product']['discount']);
        discountType = returnData['data']['product']['discount_type'];
        // visibleSKU.value = ProductSkus.fromJson(returnData['data']['sku']);
        productSKU.value = SkuData.fromJson(returnData['data']);
        productSkuID.value = returnData['data']['id'];
        stockManage.value = products.value.data.stockManage;
        stockCount.value = int.parse(productSKU.value.productStock);
        itemQuantity.value = int.parse(products.value.data.product.minimumOrderQty);
        calculatePriceAfterSku();
      }
    } catch (e) {
      isSkuLoading(false);
      print(e.toString());
    } finally {
      isSkuLoading(false);
    }
  }

   void calculatePrice() {

     print("Discount : $discount \t ${discount.runtimeType}");
     // log("Discount : ${products.value}");
    if (products.value.data.hasDeal != null)
    {
      if (products.value.data.hasDeal.discountType == 0) {
        finalPrice.value = double.parse(products.value.data.skus.first.sellingPrice) -
            ((double.parse(products.value.data.hasDeal.discount) / 100) * double.parse(products.value.data.skus.first.sellingPrice));
        productPrice.value = double.parse(products.value.data.skus.first.sellingPrice) -
            ((double.parse(products.value.data.hasDeal.discount) / 100) * double.parse(products.value.data.skus.first.sellingPrice));

        print("finalPrice.value1 : ${finalPrice.value}");
      } else {
        finalPrice.value = double.parse(products.value.data.skus.first.sellingPrice) -
            double.parse(products.value.data.hasDeal.discount);
        productPrice.value = double.parse(products.value.data.skus.first.sellingPrice) -
            double.parse(products.value.data.hasDeal.discount);
        print("finalPrice.value2 : ${finalPrice.value}");
      }
    }
    else {
      if (discount > 0) {
        print(finalPrice.value);
        if (discountType == "0" || discountType == 0) {
          ///has variant
          ///

          finalPrice.value = double.parse(products.value.data.skus.first.sellingPrice) -
              ((discount / 100) * double.parse(products.value.data.skus.first.sellingPrice));
          print(finalPrice.value);
          productPrice.value = double.parse(products.value.data.skus.first.sellingPrice) -
              ((discount / 100) * double.parse(products.value.data.skus.first.sellingPrice));
          print("finalPrice.valu3 : ${finalPrice.value}");
        } else {
          ///has variant
          finalPrice.value = double.parse(products.value.data.skus.first.sellingPrice) - discount;
          productPrice.value = double.parse(products.value.data.skus.first.sellingPrice) - discount;
          print("finalPrice.valu4 : ${finalPrice.value}");
        }
      } else {

        finalPrice.value = double.parse(products.value.data.skus.first.sellingPrice);
        productPrice.value = double.parse(products.value.data.skus.first.sellingPrice);
        print("finalPrice.value4a : ${finalPrice.value}");
      }
    }
  }

  void calculatePriceAfterSku() {
    if (products.value.data.hasDeal != null) {
      if (products.value.data.hasDeal.discountType == 0) {
        finalPrice.value = productSKU.value.sellingPrice -
            ((double.parse(products.value.data.hasDeal.discount) / 100) *
                productSKU.value.sellingPrice);
        productPrice.value = productSKU.value.sellingPrice -
            ((double.parse(products.value.data.hasDeal.discount) / 100) *
                productSKU.value.sellingPrice);
        print("finalPrice.value5 : ${finalPrice.value}");
      } else {
        finalPrice.value = productSKU.value.sellingPrice -
            products.value.data.hasDeal.discount;
        productPrice.value = productSKU.value.sellingPrice -
            products.value.data.hasDeal.discount;
        print("finalPrice.value6 : ${finalPrice.value}");
      }
    } else {
      if (discount > 0) {
        ///percentage - type
        if (discountType == "0") {
          ///has variant
          ///
          finalPrice.value = productSKU.value.sellingPrice -
              ((discount / 100) * productSKU.value.sellingPrice);
          productPrice.value = productSKU.value.sellingPrice -
              ((discount / 100) * productSKU.value.sellingPrice);
          print("finalPrice.value7 : ${finalPrice.value}");
        } else {
          ///has variant
          finalPrice.value = productSKU.value.sellingPrice - discount;
          productPrice.value = productSKU.value.sellingPrice - discount;
          print("finalPrice.value8 : ${finalPrice.value}");
        }
      } else {
        ///
        ///no discount
        ///
        ///has variant
        finalPrice.value = productSKU.value.sellingPrice;
        productPrice.value = productSKU.value.sellingPrice;
        print("finalPrice.value9 : ${finalPrice.value}");
      }
    }
  }

  void cartIncrease() {
    if (maxOrder.value != null) {
      if (itemQuantity.value < int.parse(maxOrder.value)) {
        itemQuantity.value++;
      }
    } else {
      itemQuantity.value++;
    }

    finalPrice.value = productPrice.roundToDouble() * itemQuantity.value;
    print("finalPrice.value10 : ${finalPrice.value}");
  }

  void cartDecrease() {
    if (itemQuantity.value > int.parse(minOrder.value)) {
      itemQuantity.value--;
      finalPrice.value = productPrice * itemQuantity.value;
      print("finalPrice.value11 : ${finalPrice.value}");
    }
  }

  @override
  void onInit() {
    // getProductDetails();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
