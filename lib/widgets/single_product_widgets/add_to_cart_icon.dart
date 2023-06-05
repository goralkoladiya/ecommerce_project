import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/controller/login_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/model/Product/ProductType.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/authentication/LoginPage.dart';
import 'package:amazy_app/view/products/product/product_details.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartIcon extends StatefulWidget {
  final ProductModel productModel;
  CartIcon(this.productModel);

  @override
  State<CartIcon> createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  bool _isAddingToCart = false;

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  final CartController cartController = Get.put(CartController());

  double getPriceForCart() {
    return double.parse((widget.productModel.hasDeal != null
            ? widget.productModel.hasDeal.discount > 0
                ? currencyController.calculatePrice(widget.productModel)
                : currencyController.calculatePrice(widget.productModel)
            : currencyController.calculatePrice(widget.productModel))
        .toString());
  }

  double getGiftCardPriceForCart() {
    dynamic productPrice = 0.0;
    if (widget.productModel.giftCardEndDate.millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch) {
      productPrice = widget.productModel.giftCardSellingPrice;
    } else {
      if (widget.productModel.discountType == 0 ||
          widget.productModel.discountType == "0") {
        productPrice = (widget.productModel.giftCardSellingPrice -
            ((widget.productModel.discount / 100) *
                widget.productModel.giftCardSellingPrice));
      } else {
        productPrice = (widget.productModel.giftCardSellingPrice -
            widget.productModel.discount);
      }
    }
    return double.parse(productPrice.toString());
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(() {
          _isAddingToCart = true;
        });
        final LoginController loginController = Get.put(LoginController());
        if (widget.productModel.productType == ProductType.PRODUCT) {
          if (loginController.loggedIn.value) {
            if (widget.productModel.variantDetails.length == 0) {
              if (widget.productModel.stockManage == 1) {
                if (widget.productModel.skus.first.productStock > 0) {
                  if (widget.productModel.product.minimumOrderQty >
                      widget.productModel.skus.first.productStock) {
                    SnackBars().snackBarWarning('No more stock'.tr);
                  } else {
                    Map data = {
                      'product_id': widget.productModel.skus.first.id,
                      'qty': 1,
                      'price': getPriceForCart(),
                      'seller_id': widget.productModel.userId,
                      'product_type': 'product',
                      'checked': true,
                    };

                    print(data);

                    await cartController.addToCart(data).then((value) {
                      if (value) {
                        SnackBars()
                            .snackBarSuccess('Card Added successfully'.tr);
                      }
                    });
                  }
                } else {
                  SnackBars().snackBarWarning('No more stock'.tr);
                }
              } else {
                //** Not manage stock */

                Map data = {
                  'product_id': widget.productModel.skus.first.id,
                  'qty': 1,
                  'price': getPriceForCart(),
                  'seller_id': widget.productModel.userId,
                  'product_type': 'product',
                  'checked': true,
                };

                print(data);
                await cartController.addToCart(data).then((value) {
                  if (value) {
                    Future.delayed(Duration(seconds: 3), () {
                      print(Get.isBottomSheetOpen);
                    });
                  }
                });
              }
              setState(() {
                _isAddingToCart = false;
              });
            } else {
              setState(() {
                _isAddingToCart = false;
              });
              Get.to(() => ProductDetails(productID: widget.productModel.id),
                  preventDuplicates: false);
            }
          } else {
            setState(() {
              _isAddingToCart = false;
            });
            Get.dialog(LoginPage(), useSafeArea: false);
          }
        } else {
          if (loginController.loggedIn.value) {
            Map data = {
              'product_id': widget.productModel.id,
              'qty': 1,
              'price': getGiftCardPriceForCart(),
              'seller_id': 1,
              'shipping_method_id': 1,
              'product_type': 'gift_card',
            };
            print(data);
            await cartController.addToCart(data);
            setState(() {
              _isAddingToCart = false;
            });
          } else {
            setState(() {
              _isAddingToCart = false;
            });
            Get.dialog(LoginPage(), useSafeArea: false);
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppStyles.pinkColor,
          borderRadius: BorderRadius.circular(5),
        ),
        width: 25,
        height: 25,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: _isAddingToCart
              ? Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1,
                  ),
                )
              : Image.asset(
                  'assets/images/icon_cart_grey.png',
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
