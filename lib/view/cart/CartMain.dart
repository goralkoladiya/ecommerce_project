import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/Cart/MyCartModel.dart';
import 'package:amazy_app/model/Product/ProductType.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/cart/checkout/checkout_page_1.dart';
import 'package:amazy_app/view/products/product/product_details.dart';
import 'package:amazy_app/view/seller/StoreHome.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/StarCounterWidget.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CartMain extends StatefulWidget {
  final bool hasMargin;
  final bool showBack;

  CartMain(this.hasMargin, this.showBack);

  @override
  _CartMainState createState() => _CartMainState();
}

class _CartMainState extends State<CartMain> {
  bool _anonymous = false;
  bool _cart = false;

  final CartController cartController = Get.put(CartController());

  ScrollController _scrollController = ScrollController();

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  bool checked(List<MyCart> cartItems) {
    var list = [];
    cartItems.forEach((element) {
      if (element.isSelect == 1) {
        list.add(element.isSelect);
      }
    });
    if (list.length == cartItems.length) {
      return !_anonymous;
    } else {
      return _anonymous;
    }
  }

  bool checkedAll() {
    var list1 = [];
    var count = 0;
    cartController.cartListModel.value.carts.forEach((key, value) {
      count += value.length;
      value.forEach((element) {
        if (element.isSelect == 1) {
          list1.add(element.isSelect);
        }
      });
    });
    // print('list len ${list1.length} == Count $count');
    // print('list $list1');
    if (list1.length == count) {
      return !_cart;
    } else {
      return _cart;
    }
  }

  double totalPrice() {
    var count = 0.0;

    cartController.cartListModel.value.carts.forEach((key, value) {
      value.forEach((element) {
        if (element.isSelect == 1) {
          print("element.totalPrice : ${element.totalPrice}");
          count += element.totalPrice * currencyController.conversionRate.value;
        }
      });
    });
    // print(count);
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cartController.isLoading.value) {
        return Scaffold(
          body: Center(
            child: CustomLoadingWidget(),
          ),
        );
      } else if (cartController.cartListModel.value.carts == null ||
          cartController.cartListModel.value.carts.length == 0) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              CustomSliverAppBarWidget(widget.showBack ? true : false, false),
              SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        child: Image.asset(
                          AppConfig.appLogo,
                          width: 30,
                          height: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Cart is Empty'.tr,
                        textAlign: TextAlign.center,
                        style: AppStyles.kFontPink15w5.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: [
              CustomSliverAppBarWidget(widget.showBack ? true : false, false),
              SliverFillRemaining(
                child: Scrollbar(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Text(
                              "My Cart List",
                              style: AppStyles.appFontMedium
                                  .copyWith(fontSize: 18),
                            ),
                            Expanded(child: Container()),
                            Obx(() {
                              return InkWell(
                                onTap: () {
                                  cartController.deleteSelected.value =
                                      !cartController.deleteSelected.value;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: AppStyles.gradient,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Text(
                                    cartController.deleteSelected.value
                                        ? 'Complete'.tr
                                        : "Delete".tr,
                                    style: AppStyles.appFontMedium.copyWith(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount:
                                cartController.cartListModel.value.carts.length,
                            itemBuilder: (context, index) {
                              List<MyCart> cartItems = cartController
                                  .cartListModel.value.carts.values
                                  .elementAt(index);
                              return Container(
                                child: Column(
                                  children: [
                                    currencyController.vendorType.value !=
                                            "single"
                                        ? Row(
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    print(
                                                        cartItems[0].seller.id);
                                                    Get.to(() => StoreHome(
                                                          sellerId: cartItems[0]
                                                              .seller
                                                              .id,
                                                        ));
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            "${cartItems[0].seller.name}",
                                                            style: AppStyles
                                                                .appFontMedium
                                                                .copyWith(
                                                              color: AppStyles
                                                                  .blackColor,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        SizedBox(
                                                          height: 70,
                                                          child: Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            size: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : SizedBox(
                                            height: 10,
                                          ),
                                    Column(
                                      children: List.generate(cartItems.length,
                                          (prodIndex) {
                                        return Column(
                                          children: [
                                            Obx(() {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 10,
                                                  horizontal: 20,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    cartController
                                                            .deleteSelected
                                                            .value
                                                        ? Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: 20,
                                                              bottom: 20,
                                                              right: 10,
                                                            ),
                                                            child: InkWell(
                                                              onTap: () {
                                                                if (cartController
                                                                    .cartItemDelete
                                                                    .contains(
                                                                        cartItems[
                                                                            prodIndex])) {
                                                                  cartController
                                                                      .cartItemDelete
                                                                      .remove(cartItems[
                                                                          prodIndex]);
                                                                } else {
                                                                  cartController
                                                                      .cartItemDelete
                                                                      .add(cartItems[
                                                                          prodIndex]);
                                                                }
                                                              },
                                                              child: Icon(
                                                                cartController
                                                                        .cartItemDelete
                                                                        .contains(cartItems[
                                                                            prodIndex])
                                                                    ? FontAwesomeIcons
                                                                        .solidCircleCheck
                                                                    : FontAwesomeIcons
                                                                        .circle,
                                                                color: AppStyles
                                                                    .pinkColor,
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox.shrink(),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: Container(
                                                        height: 60,
                                                        width: 90,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        color:
                                                            Color(0xffF1F1F1),
                                                        child: cartItems[
                                                                        prodIndex]
                                                                    .productType ==
                                                                ProductType
                                                                    .GIFT_CARD
                                                            ? FancyShimmerImage(
                                                                imageUrl: AppConfig
                                                                        .assetPath +
                                                                    '/' +
                                                                    cartItems[
                                                                            prodIndex]
                                                                        .giftCard
                                                                        .thumbnailImage,
                                                                boxFit: BoxFit
                                                                    .contain,
                                                                errorWidget:
                                                                    FancyShimmerImage(
                                                                  imageUrl:
                                                                      "${AppConfig.assetPath}/backend/img/default.png",
                                                                  boxFit: BoxFit
                                                                      .contain,
                                                                ),
                                                              )
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  Get.to(
                                                                      () => ProductDetails(
                                                                          productID: cartItems[prodIndex]
                                                                              .product
                                                                              .productId),
                                                                      preventDuplicates:
                                                                          false);
                                                                },
                                                                child:
                                                                    FancyShimmerImage(
                                                                  imageUrl: AppConfig
                                                                          .assetPath +
                                                                      '/' +
                                                                      (cartItems[prodIndex].product.sku.variantImage ==
                                                                              null
                                                                          ? cartItems[prodIndex]
                                                                              .product
                                                                              .product
                                                                              .product
                                                                              .thumbnailImageSource
                                                                          : cartItems[prodIndex]
                                                                              .product
                                                                              .sku
                                                                              .variantImage),
                                                                  boxFit: BoxFit
                                                                      .contain,
                                                                  errorWidget:
                                                                      FancyShimmerImage(
                                                                    imageUrl:
                                                                        "${AppConfig.assetPath}/backend/img/default.png",
                                                                    boxFit: BoxFit
                                                                        .contain,
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            cartItems[prodIndex]
                                                                        .productType ==
                                                                    ProductType
                                                                        .GIFT_CARD
                                                                ? cartItems[
                                                                        prodIndex]
                                                                    .giftCard
                                                                    .name
                                                                    .capitalizeFirst
                                                                : cartItems[
                                                                        prodIndex]
                                                                    .product
                                                                    .product
                                                                    .productName
                                                                    .capitalizeFirst,
                                                            style: AppStyles
                                                                .appFontBold
                                                                .copyWith(
                                                                    fontSize:
                                                                        14),
                                                          ),

                                                          //** RATING */

                                                          SizedBox(
                                                            height: 5,
                                                          ),

                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              cartItems[prodIndex]
                                                                          .productType ==
                                                                      ProductType
                                                                          .PRODUCT
                                                                  ? double.parse(cartItems[prodIndex].product.product.avgRating )>
                                                                          0
                                                                      ? StarCounterWidget(
                                                                          value: cartItems[prodIndex]
                                                                              .product
                                                                              .product
                                                                              .avgRating
                                                                              .toDouble(),
                                                                          color:
                                                                              AppStyles.pinkColor,
                                                                          size:
                                                                              14,
                                                                        )
                                                                      : StarCounterWidget(
                                                                          value:
                                                                              0,
                                                                          color:
                                                                              AppStyles.pinkColor,
                                                                          size:
                                                                              14,
                                                                        )
                                                                  : cartItems[prodIndex]
                                                                              .giftCard
                                                                              .avgRating >
                                                                          0
                                                                      ? StarCounterWidget(
                                                                          value: cartItems[prodIndex]
                                                                              .giftCard
                                                                              .avgRating
                                                                              .toDouble(),
                                                                          color:
                                                                              AppStyles.pinkColor,
                                                                          size:
                                                                              14,
                                                                        )
                                                                      : StarCounterWidget(
                                                                          value:
                                                                              0,
                                                                          color:
                                                                              AppStyles.pinkColor,
                                                                          size:
                                                                              14,
                                                                        ),
                                                              SizedBox(
                                                                width: 2,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            1.0),
                                                                child: cartItems[prodIndex]
                                                                            .productType ==
                                                                        ProductType
                                                                            .PRODUCT
                                                                    ? double.parse(cartItems[prodIndex].product.product.avgRating )>
                                                                            0
                                                                        ? Text(
                                                                            '(${cartItems[prodIndex].product.product.avgRating.toString()})',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                AppStyles.appFontBook.copyWith(
                                                                              color: AppStyles.greyColorDark,
                                                                              fontSize: 10,
                                                                            ),
                                                                          )
                                                                        : Text(
                                                                            '(0)',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                AppStyles.appFontBook.copyWith(
                                                                              color: AppStyles.greyColorDark,
                                                                              fontSize: 10,
                                                                            ),
                                                                          )
                                                                    : cartItems[prodIndex].giftCard.avgRating >
                                                                            0
                                                                        ? Text(
                                                                            '(${cartItems[prodIndex].giftCard.avgRating.toString()})',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                AppStyles.appFontBook.copyWith(
                                                                              color: AppStyles.greyColorDark,
                                                                              fontSize: 10,
                                                                            ),
                                                                          )
                                                                        : Text(
                                                                            '(0)',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                AppStyles.appFontBook.copyWith(
                                                                              color: AppStyles.greyColorDark,
                                                                              fontSize: 10,
                                                                            ),
                                                                          ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),

                                                          Wrap(
                                                            runSpacing: 5,
                                                            children: [
                                                              Text(
                                                                currencyController.appCurrency.value +
                                                                    (double.parse(cartItems[prodIndex].totalPrice )*
                                                                            currencyController.conversionRate.value).toStringAsFixed(2),
                                                                style: AppStyles
                                                                    .appFontBold
                                                                    .copyWith(
                                                                  fontSize: 12,
                                                                  color: AppStyles
                                                                      .pinkColor,
                                                                ),
                                                              ),

                                                              //** VARIATIONS */
                                                              cartItems[prodIndex]
                                                                          .productType ==
                                                                      ProductType
                                                                          .GIFT_CARD
                                                                  ? SizedBox
                                                                      .shrink()
                                                                  : cartItems[prodIndex]
                                                                              .product
                                                                              .productVariations
                                                                              .length >
                                                                          0
                                                                      ? Wrap(
                                                                          children: List.generate(
                                                                              cartItems[prodIndex].product.productVariations.length,
                                                                              (variationIndex) {
                                                                            if (cartItems[prodIndex].product.productVariations[variationIndex].attribute.name ==
                                                                                'Color') {
                                                                              return Row(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Text(
                                                                                    '${cartItems[prodIndex].product.productVariations[variationIndex].attribute.name}: ${cartItems[prodIndex].product.productVariations[variationIndex].attributeValue.color.name}',
                                                                                    style: AppStyles.kFontGrey12w5,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  Text(
                                                                                    variationIndex == cartItems[prodIndex].product.productVariations.length - 1 ? '' : ', ',
                                                                                    style: AppStyles.kFontGrey12w5,
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            }
                                                                            return Row(
                                                                              children: [
                                                                                Text(
                                                                                  '${cartItems[prodIndex].product.productVariations[variationIndex].attribute.name}: ${cartItems[prodIndex].product.productVariations[variationIndex].attributeValue.value}',
                                                                                  style: AppStyles.kFontGrey12w5,
                                                                                ),
                                                                                Text(
                                                                                  variationIndex == cartItems[prodIndex].product.productVariations.length - 1 ? '' : ', ',
                                                                                  style: AppStyles.kFontGrey12w5,
                                                                                ),
                                                                              ],
                                                                            );
                                                                          }),
                                                                        )
                                                                      : SizedBox
                                                                          .shrink(),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      height: 80,
                                                      width: 35,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    253,
                                                                    188,
                                                                    188)),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      child: Column(
                                                        children: [
                                                          cartItems[prodIndex]
                                                                      .productType ==
                                                                  ProductType
                                                                      .PRODUCT
                                                              ? cartItems[prodIndex]
                                                                          .product
                                                                          .product
                                                                          .stockManage ==
                                                                      1
                                                                  ? cartItems[prodIndex]
                                                                              .qty ==
                                                                          cartItems[prodIndex]
                                                                              .product
                                                                              .productStock
                                                                      ? Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              AppStyles.greyColorLight,
                                                                          size:
                                                                              20,
                                                                        )
                                                                      : InkWell(
                                                                          child:
                                                                              Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                AppStyles.greyColorDark,
                                                                            size:
                                                                                20,
                                                                          ),
                                                                          onTap:
                                                                              () async {
                                                                            var qty =
                                                                                cartItems[prodIndex].qty;

                                                                            Map data =
                                                                                {
                                                                              "id": cartItems[prodIndex].id,
                                                                              "qty": int.parse(qty) + 1,
                                                                              "p_id": cartItems[prodIndex].productId,
                                                                            };

                                                                            await cartController.updateCartQuantity(data);
                                                                          })
                                                                  : cartItems[prodIndex]
                                                                              .qty ==
                                                                          cartItems[prodIndex]
                                                                              .product
                                                                              .product
                                                                              .product
                                                                              .maxOrderQty
                                                                      ? Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              AppStyles.greyColorLight,
                                                                          size:
                                                                              20,
                                                                        )
                                                                      : InkWell(
                                                                          child:
                                                                              Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                AppStyles.greyColorDark,
                                                                            size:
                                                                                20,
                                                                          ),
                                                                          onTap:
                                                                              () async {
                                                                            var qty =
                                                                                cartItems[prodIndex].qty;

                                                                            Map data =
                                                                                {
                                                                              "id": cartItems[prodIndex].id,
                                                                              "qty": int.parse(qty) + 1,
                                                                              "p_id": cartItems[prodIndex].productId,
                                                                            };

                                                                            await cartController.updateCartQuantity(data);
                                                                          })
                                                              : InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    var qty =
                                                                        cartItems[prodIndex]
                                                                            .qty;

                                                                    Map data = {
                                                                      "id": cartItems[
                                                                              prodIndex]
                                                                          .id,
                                                                      "qty":
                                                                      int.parse(qty) + 1,
                                                                      "p_id": cartItems[
                                                                              prodIndex]
                                                                          .productId,
                                                                    };

                                                                    await cartController
                                                                        .updateCartQuantity(
                                                                            data);
                                                                  },
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: AppStyles
                                                                        .greyColorLight,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              '${cartItems[prodIndex].qty.toString()}',
                                                              style: AppStyles
                                                                  .appFontMedium
                                                                  .copyWith(
                                                                fontSize: 17,
                                                                color: AppStyles
                                                                    .pinkColor,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: cartItems[
                                                                            prodIndex]
                                                                        .productType ==
                                                                    ProductType
                                                                        .PRODUCT
                                                                ? cartItems[prodIndex]
                                                                            .qty ==
                                                                        cartItems[prodIndex]
                                                                            .product
                                                                            .product
                                                                            .product
                                                                            .minimumOrderQty
                                                                    ? Icon(
                                                                        Icons
                                                                            .remove,
                                                                        color: AppStyles
                                                                            .lightGreyColor,
                                                                        size:
                                                                            20,
                                                                      )
                                                                    : InkWell(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .remove,
                                                                          color:
                                                                              AppStyles.greyColorDark,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                        onTap:
                                                                            () async {
                                                                          var qty =
                                                                              cartItems[prodIndex].qty;
                                                                          Map data =
                                                                              {
                                                                            "id":
                                                                                cartItems[prodIndex].id,
                                                                            "qty":
                                                                            int.parse(qty) - 1,
                                                                            "p_id":
                                                                                cartItems[prodIndex].productId,
                                                                          };
                                                                          await cartController
                                                                              .updateCartQuantity(data);
                                                                        },
                                                                      )
                                                                : InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      var qty =
                                                                          cartItems[prodIndex]
                                                                              .qty;
                                                                      Map data =
                                                                          {
                                                                        "id": cartItems[prodIndex]
                                                                            .id,
                                                                        "qty":
                                                                        int.parse(qty) -
                                                                                1,
                                                                        "p_id":
                                                                            cartItems[prodIndex].productId,
                                                                      };
                                                                      await cartController
                                                                          .updateCartQuantity(
                                                                              data);
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: AppStyles
                                                                          .lightGreyColor,
                                                                      size: 20,
                                                                    ),
                                                                  ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                            prodIndex == cartItems.length - 1
                                                ? SizedBox.shrink()
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20.0),
                                                    child: Divider(),
                                                  ),
                                          ],
                                        );
                                      }),
                                    ),
                                    index ==
                                            cartController.cartListModel.value
                                                    .carts.length -
                                                1
                                        ? SizedBox.shrink()
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Divider(),
                                          ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          resizeToAvoidBottomInset: true,
          extendBody: false,
          bottomNavigationBar: Container(
            height: 100,
            margin: EdgeInsets.only(bottom: widget.hasMargin ? 100 : 0),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Obx(() {
              return cartController.deleteSelected.value
                  ? Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () async {
                            cartController.cartItemDelete
                                .forEach((element) async {
                              Map data = {
                                'id': element.id,
                              };
                              await cartController.removeFromCart(data);
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: AppStyles.gradient,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "Delete".tr,
                              style: AppStyles.appFontMedium.copyWith(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount'.tr,
                              style: AppStyles.appFontMedium.copyWith(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(child: Container()),
                            Text(
                              '${double.parse((totalPrice() + (cartController.cartListModel.value.shippingCharge * currencyController.conversionRate.value)).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                              style: AppStyles.appFontMedium.copyWith(
                                fontSize: 16,
                                color: AppStyles.pinkColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => CheckoutPageOne());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: AppStyles.gradient,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.all(12),
                            child: Text(
                              "Checkout".tr,
                              style: AppStyles.appFontMedium.copyWith(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            }),
          ),
        );
      }
    });
  }
}
