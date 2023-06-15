import 'dart:convert';
import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/model/Cart/MyCartModel.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  var isLoading = false.obs;

  var isCartLoading = false.obs;

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  var cartListModel = MyCartModel().obs;

  var cartListCount = 0.obs;

  var cartListSelectedCount = 0.obs;

  RxList<MyCart> cartItemDelete = <MyCart>[].obs;

  RxBool deleteSelected = false.obs;

  Future<MyCartModel> getCart() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonString = jsonDecode(response.body);
    print("jsonstring====$jsonString");
    if (jsonString['message'] == 'success') {
      return MyCartModel.fromJson(jsonString);
    } else {
      cartListSelectedCount.value = 0;
      //show error message
      return null;
    }
  }

  Future<MyCartModel> getCartList() async {
    // cartItemDelete.clear();
    try {
      isCartLoading(true);
      var cartList = await getCart();
      if (cartList != null) {
        cartListModel.value = cartList;
        print("cartlist=${cartList.toString()}");
        var count = 0;
        var selectedCount = 0;
        cartListModel.value.carts.values.forEach((element) {
          element.forEach((element) {
            if (element.isSelect != null) {
              selectedCount += int.parse(element.qty);
              print("quantity===$selectedCount");
            }
            else {
              count += int.parse(element.qty);
            }
            });
        });
        cartListCount.value = 0;
        cartListCount.value = count;
        cartListSelectedCount.value = 0;
        cartListSelectedCount.value = selectedCount;
      } else {
        cartListModel.value = MyCartModel();
      }
      return cartList;
    } finally {
      isCartLoading(false);
    }
  }

  RxBool isCartAdding = false.obs;

  Future<bool> addToCart(data) async {
    isCartAdding(true);
    String token = await userToken.read(tokenKey);
    Uri userData = Uri.parse(URLs.CART);
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
      isCartAdding(false);
      SnackBars().snackBarSuccessBottom(jsonString['message'].toString().capitalizeFirst);
      await getCartList();
      return true;
    } else {
      isCartAdding(false);
      EasyLoading.dismiss();
      SnackBars().snackBarError(jsonString['message'].toString().capitalizeFirst);
      return false;
    }
  }

  Future updateCartQuantity(data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART_QUANTITY_UPDATE);

    var body = jsonEncode(data);

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
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  Future selectUnselectCartItem(data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART_SELECT_UNSELECT_SINGLE);

    var body = jsonEncode(data);

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
    if (response.statusCode == 200) {
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  Future selectUnselectSeller(data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART_SELECT_UNSELECT_SELLER_WISE);

    var body = jsonEncode(data);

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
    if (response.statusCode == 200) {
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  Future selectUnselectAllItem(data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART_SELECT_UNSELECT_ALL);

    var body = jsonEncode(data);

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
    if (response.statusCode == 200) {
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  Future removeFromCart(data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART_REMOVE_CART_ITEM);

    var body = jsonEncode(data);

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
    if (response.statusCode == 203) {
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  Future removeAllFromCart() async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART_REMOVE_ALL);

    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 203) {
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  Future updateShipping(data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CART_UPDATE_SHIPPING);

    var body = jsonEncode(data);

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
      this.getCartList();
    } else {
      //show error message
      SnackBars().snackBarError(jsonString['message']);
      return null;
    }
    EasyLoading.dismiss();
  }

  @override
  void onInit() {
    getCartList();
    super.onInit();
  }
}
