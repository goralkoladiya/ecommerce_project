import 'dart:convert';

import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/model/MyWishListModel.dart';
import 'package:amazy_app/model/Product/ProductType.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class MyWishListController extends GetxController {
  var isLoading = false.obs;

  var wishListModel = MyWishListModel().obs;

  GetStorage userToken = GetStorage();
  var tokenKey = 'token';

  dynamic wishListCount = 0.obs;

  RxList<WishListLocal> wishListProducts = <WishListLocal>[].obs;

  Future<MyWishListModel> getWishlists() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.MY_WISHLIST);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    var jsonString = jsonDecode(response.body);
    print("responseprint==$jsonString");
    print("ppp: ${response.body}");
    if (jsonString['message'] == 'success') {
      return MyWishListModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<MyWishListModel> getAllWishList() async {
    wishListProducts.clear();
    try {
      print("try");
      isLoading(true);
      print("wishlist: ${getWishlists()}");
      var wishlist = await getWishlists();
      if (wishlist != null) {
        wishListModel.value = wishlist;
        var count = 0;
        wishListModel.value.products.values.forEach((element) {
          count += element.length;

          element.forEach((element2) {
            if (element2.type == ProductType.GIFT_CARD) {
              wishListProducts.add(WishListLocal(
                  id: element2.giftcard.id,
                  wishListId: element2.id,
                  productType: ProductType.GIFT_CARD,),);
            } else {
              wishListProducts.add(
                WishListLocal(
                  id: element2.product.id,
                  productType: ProductType.PRODUCT,
                  wishListId: element2.id,
                ),
              );
            }
          });
        });
        wishListCount.value = count;
      } else {
        wishListModel.value = MyWishListModel();
      }
      return wishlist;

    } catch (e) {

      print("vatch");
      throw e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future deleteWishListProduct(id) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.MY_WISHLIST_DELETE);

    Map data = {
      "id": id,
      "type": "product",
      "seller_id": 1,
    };
    var body = json.encode(data);

    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    
    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 202) {
      SnackBars().snackBarSuccessBottom(jsonString['message'].toString().capitalizeFirst);

      EasyLoading.dismiss();
      SnackBars().snackBarSuccess(jsonString['message'].toString().capitalizeFirst);
      wishListModel.value = MyWishListModel();
      wishListCount.value = 0;
      await getAllWishList();
      return true;
      print("1111: ${response.statusCode}");

    } else {
      print("2222: ${response.statusCode}");

      EasyLoading.dismiss();
      SnackBars().snackBarError(jsonString['message'].toString().capitalizeFirst);
      return false;
    }
  }

  Future addProductToWishList(Map data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.MY_WISHLIST);

    var body = json.encode(data);

    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    
    var jsonString = jsonDecode(response.body);

    if (response.statusCode == 201) {
      EasyLoading.dismiss();
      SnackBars()
          .snackBarSuccess(jsonString['message'].toString().capitalizeFirst);
      wishListModel.value = MyWishListModel();
      wishListCount.value = 0;
      await getAllWishList();
    } else {
      EasyLoading.dismiss();
      SnackBars()
          .snackBarError(jsonString['message'].toString().capitalizeFirst);
    }
  }

  @override
  void onInit() {
    getAllWishList();
    super.onInit();
  }
}

class WishListLocal {
  final int id;
  final int wishListId;
  final ProductType productType;

  WishListLocal({this.id, this.productType, this.wishListId});
}
