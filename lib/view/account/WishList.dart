import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/controller/home_controller.dart';
import 'package:amazy_app/controller/my_wishlist_controller.dart';
import 'package:amazy_app/model/MyWishListModel.dart';
import 'package:amazy_app/model/Product/GiftCardData.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/model/Product/ProductType.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/product/product_details.dart';
import 'package:amazy_app/view/seller/StoreHome.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:amazy_app/widgets/single_product_widgets/add_to_cart_icon.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  final MyWishListController wishListController =
      Get.put(MyWishListController());
  final HomeController controller = Get.put(HomeController());
  final GeneralSettingsController _currencyController =
      Get.put(GeneralSettingsController());

  String calculateGiftCardPrice(WishListProduct productModel) {
    String amountText;

    if (productModel.giftcard.discount > 0) {
      ///percentage - type
      if (productModel.giftcard.discountType == 0) {
        amountText = ((productModel.giftcard.sellingPrice -
                        ((productModel.giftcard.discount / 100) *
                            productModel.giftcard.sellingPrice)) *
                    _currencyController.conversionRate.value)
                .toString() +
            '${_currencyController.appCurrency.value}';
      } else {
        ///minus - type
        ///no variant
        amountText = ((productModel.giftcard.sellingPrice -
                        productModel.giftcard.discount) *
                    _currencyController.conversionRate.value)
                .toString() +
            '${_currencyController.appCurrency.value}';
      }
    } else {
      ///
      ///no discount
      ///
      amountText = (productModel.giftcard.sellingPrice *
                  _currencyController.conversionRate.value)
              .toString() +
          '${_currencyController.appCurrency.value}';
    }
    return amountText;
  }

  double getPriceForCart(ProductModel productModel) {
    return double.parse((productModel.hasDeal != null
            ? productModel.hasDeal.discount > 0
                ? _currencyController.calculatePrice(productModel)
                : _currencyController.calculatePrice(productModel)
            : _currencyController.calculatePrice(productModel))
        .toString());
  }

  double getGiftCardPriceForCart(GiftCardData productModel) {
    dynamic productPrice = 0.0;
    if (productModel.endDate.millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch) {
      productPrice = productModel.sellingPrice;
    } else {
      if (productModel.discountType == 0 || productModel.discountType == "0") {
        productPrice = (productModel.sellingPrice -
            ((productModel.discount / 100) * productModel.sellingPrice));
      } else {
        productPrice = (productModel.sellingPrice - productModel.discount);
      }
    }
    return double.parse(productPrice.toString());
  }

  @override
  void initState() {
    wishListController.getAllWishList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBarWidget(true, true),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "My Wishlist".tr,
                      style: AppStyles.appFontMedium.copyWith(
                        fontSize: 18,
                        color: Color(0xff5C7185),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Obx(() {
                    return Container(
                      child: Text(
                        "${wishListController.wishListCount.value ?? "0"} " +
                            "Products found".tr,
                        style: AppStyles.appFontMedium.copyWith(
                          fontSize: 13,
                          color: Color(0xffC5C5C5),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Obx(() {
              if (wishListController.isLoading.value) {
                return Center(
                  child: CustomLoadingWidget(),
                );
              } else {
                if (wishListController.wishListModel.value.products == null ||
                    wishListController.wishListModel.value.products.length ==
                        0) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.exclamation,
                          color: AppStyles.pinkColor,
                          size: 25,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No Products found'.tr,
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
                  );
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: wishListController
                          .wishListModel.value.products.length,
                      itemBuilder: (context, index) {
                        List<WishListProduct> value = wishListController
                            .wishListModel.value.products.values
                            .elementAt(index);
                        return Column(
                          children: [
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  _currencyController.vendorType.value ==
                                          "single"
                                      ? SizedBox.shrink()
                                      : InkWell(
                                          onTap: () {
                                            print(
                                                'Seller id: ${value[0].seller.id}');
                                            Get.to(() => StoreHome(
                                                  sellerId: value[0].seller.id,
                                                ));
                                          },
                                          child: Container(
                                            height: 40,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    value[0].seller.firstName,
                                                    style: AppStyles
                                                        .appFontMedium
                                                        .copyWith(
                                                      color:
                                                          AppStyles.blackColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  height: 70,
                                                  child: Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                  Column(
                                    children: List.generate(value.length,
                                        (prodIndex) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (value[prodIndex].type ==
                                              ProductType.PRODUCT) {
                                            Get.to(
                                              () => ProductDetails(
                                                productID:
                                                    value[prodIndex].product.id.toString(),
                                              ),
                                            );
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            prodIndex == 0
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0),
                                                    child: Container())
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 8.0),
                                                    child: Divider(
                                                      color: AppStyles
                                                          .appBackgroundColor,
                                                      thickness: 2,
                                                      height: 0,
                                                    ),
                                                  ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Container(
                                                    height: 60,
                                                    width: 90,
                                                    padding: EdgeInsets.all(5),
                                                    color: Color(0xffF1F1F1),
                                                    child: value[prodIndex]
                                                                .type ==
                                                            ProductType.PRODUCT
                                                        ? FancyShimmerImage(
                                                            imageUrl: AppConfig
                                                                    .assetPath +
                                                                '/' +
                                                                value[prodIndex]
                                                                    .product
                                                                    .product
                                                                    .thumbnailImageSource,
                                                            boxFit:
                                                                BoxFit.contain,
                                                            errorWidget:
                                                                FancyShimmerImage(
                                                              imageUrl:
                                                                  "${AppConfig.assetPath}/backend/img/default.png",
                                                              boxFit: BoxFit
                                                                  .contain,
                                                            ),
                                                          )
                                                        : FancyShimmerImage(
                                                            imageUrl: AppConfig
                                                                    .assetPath +
                                                                '/' +
                                                                value[prodIndex]
                                                                    .giftcard
                                                                    .thumbnailImage,
                                                            boxFit:
                                                                BoxFit.contain,
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
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          value[prodIndex]
                                                                      .type ==
                                                                  ProductType
                                                                      .PRODUCT
                                                              ? value[prodIndex]
                                                                  .product
                                                                  .productName
                                                                  .capitalizeFirst
                                                              : value[prodIndex]
                                                                  .giftcard
                                                                  .name
                                                                  .capitalizeFirst,
                                                          style: AppStyles
                                                              .appFontMedium
                                                              .copyWith(
                                                            color: AppStyles
                                                                .blackColor,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              value[prodIndex]
                                                                          .type ==
                                                                      ProductType
                                                                          .PRODUCT
                                                                  ? _currencyController
                                                                      .calculatePrice(
                                                                          value[prodIndex]
                                                                              .product)
                                                                  : calculateGiftCardPrice(
                                                                      value[
                                                                          prodIndex]),
                                                              style: AppStyles
                                                                  .appFontMedium
                                                                  .copyWith(
                                                                color: AppStyles
                                                                    .pinkColor,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              value[prodIndex]
                                                                          .type ==
                                                                      ProductType
                                                                          .PRODUCT
                                                                  ? double.parse(value[prodIndex].product.discount) >
                                                                          0
                                                                      ? '(' +
                                                                          'Price dropped'
                                                                              .tr +
                                                                          ')'
                                                                      : ''
                                                                  : value[prodIndex]
                                                                              .giftcard
                                                                              .discount >
                                                                          0
                                                                      ? '(' +
                                                                          'Price dropped'
                                                                              .tr +
                                                                          ')'
                                                                      : '',
                                                              style: AppStyles
                                                                  .appFontMedium
                                                                  .copyWith(
                                                                color: Color(
                                                                    0xff5C7185),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          value[prodIndex].type == ProductType.PRODUCT
                                                              ? _currencyController.calculateMainPrice(value[prodIndex].product)
                                                              : _currencyController
                                                                  .calculateWishListGiftcardPrice(value[prodIndex].giftcard),
                                                          style: AppStyles
                                                              .appFontMedium
                                                              .copyWith(
                                                            color: AppStyles
                                                                .greyColorDark,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            decorationColor:
                                                                AppStyles
                                                                    .pinkColor,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  print(value[
                                                                          prodIndex]
                                                                      .id);
                                                                  wishListController
                                                                      .deleteWishListProduct(
                                                                          value[prodIndex]
                                                                              .id);
                                                                },
                                                                child: Container(
                                                                    height: 20,
                                                                    width: 20,
                                                                    child: Image
                                                                        .asset(
                                                                            'assets/images/wishlist_delete.png')),
                                                              ),
                                                              CartIcon(value[
                                                                      prodIndex]
                                                                  .product),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      });
                }
              }
            }),
          ),
        ],
      ),
    );
  }
}
