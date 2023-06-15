import 'dart:developer';

import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/checkout_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/Cart/FlatGst.dart';
import 'package:amazy_app/model/Cart/MyCheckoutModel.dart';
import 'package:amazy_app/model/Product/ProductType.dart';
import 'package:amazy_app/model/ShippingMethodModel.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/cart/checkout/checkout_page_3.dart';
import 'package:amazy_app/view/cart/checkout/checkout_widgets.dart';
import 'package:amazy_app/widgets/CustomDate.dart';
import 'package:amazy_app/widgets/CustomExpansionTileCard.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/PinkButtonWidget.dart';
import 'package:amazy_app/widgets/StarCounterWidget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutPageTwo extends StatefulWidget {
  @override
  State<CheckoutPageTwo> createState() => _CheckoutPageTwoState();
}

class _CheckoutPageTwoState extends State<CheckoutPageTwo> {
  final CheckoutController _checkoutController = Get.put(CheckoutController());
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  Map _checkoutPage2Data = {};

  void removeValueToMap<K, V>(Map<K, List<V>> map, K key, V value) {
    map.update(key, (list) => list..remove(value), ifAbsent: () => [value]);
  }

  void addValueToMap<K, V>(Map<K, V> map, K key, V value) {
    map.update(key, (v) => value, ifAbsent: () => value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          CustomSliverAppBarWidget(true, false),
          SliverToBoxAdapter(
            child: LinearProgressIndicator(
              value: 0.5,
              color: AppStyles.pinkColor,
              backgroundColor: Colors.white,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CheckoutTimelineWidget(
                    isActive: true,
                    text: "Address",
                  ),
                  CheckoutTimelineLineWidget(),
                  CheckoutTimelineWidget(
                    isActive: true,
                    text: "Shipping",
                  ),
                  CheckoutTimelineLineWidget(),
                  CheckoutTimelineWidget(
                    isActive: false,
                    text: "Payment",
                  ),
                  CheckoutTimelineLineWidget(),
                  CheckoutTimelineWidget(
                    isActive: false,
                    text: "Summary",
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                Builder(builder: (context) {
                  if (_checkoutController.checkoutModel.value.packages !=
                      null) {
                    // var taxes = [];
                    // var pTaxes = [];
                    var additionalShipping = 0.0;

                    return ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _checkoutController
                            .checkoutModel.value.packages.values.length,
                        itemBuilder: (context, index) {
                          // var packageTax = 0.0;
                          // packageInd++;
                          var qty = 0;
                          var price = 0.0;

                          var totalWeight = 0.0;
                          var totalHeight = 0.0;
                          var totalLength = 0.0;
                          var totalBreadth = 0.0;

                          print("Additional $additionalShipping");

                          _checkoutController
                              .checkoutModel.value.packages.values
                              .elementAt(index)
                              .items
                              .forEach((element) {
                            qty += element.qty;
                          });
                          _checkoutController
                              .checkoutModel.value.packages.values
                              .elementAt(index)
                              .items
                              .forEach((element) {
                            price += element.totalPrice;
                          });

                          _checkoutController
                              .checkoutModel.value.packages.values
                              .elementAt(index)
                              .items
                              .forEach((element) {
                            if (element.productType == ProductType.PRODUCT) {
                              totalWeight +=
                                  double.parse(element.product.sku.weight)
                                      .toDouble();
                              totalHeight +=
                                  double.parse(element.product.sku.height)
                                      .toDouble();
                              totalLength +=
                                  double.parse(element.product.sku.length)
                                      .toDouble();
                              totalBreadth +=
                                  double.parse(element.product.sku.breadth)
                                      .toDouble();
                            }
                          });

                          final Map<dynamic, dynamic> packageWiseWeightMap =
                              _checkoutController
                                  .orderData['package_wise_weight'];
                          final Map<dynamic, dynamic> packageWiseHeightMap =
                              _checkoutController
                                  .orderData['package_wise_height'];
                          final Map<dynamic, dynamic> packageWiseLengthMap =
                              _checkoutController
                                  .orderData['package_wise_length'];
                          final Map<dynamic, dynamic> packageWiseBreadthMap =
                              _checkoutController
                                  .orderData['package_wise_breadth'];

                          final Map<dynamic, dynamic> packageWiseTaxMap =
                              _checkoutController.orderData['packagewiseTax'];

                          _checkoutController.checkoutModel.value.packages
                              .forEach((key, value) {
                            addValueToMap(
                                packageWiseWeightMap, '$index', totalWeight);
                            addValueToMap(
                                packageWiseHeightMap, '$index', totalHeight);
                            addValueToMap(
                                packageWiseLengthMap, '$index', totalLength);
                            addValueToMap(
                                packageWiseBreadthMap, '$index', totalBreadth);
                          });

                          var gst = 0.0;
                          var gstS = '';
                          var gstShowList = [];
                          var gstID = [];
                          var gstAmount = [];
                          if (_checkoutController
                                  .checkoutModel.value.isGstModuleEnable ==
                              1) {
                            log("gst module enabled");
                            _checkoutController
                                .checkoutModel.value.packages.values
                                .elementAt(index)
                                .items
                                .forEach((element) {
                              gstShowList.clear();
                              gstID.clear();
                              gstAmount.clear();

                              if (_checkoutController
                                      .checkoutModel.value.isGstEnable ==
                                  1) {
                                log('enabled gst');
                                if (currencyController
                                        .settingsModel.value.vendorType ==
                                    "single") {
                                  if (element
                                          .customer.customerShippingAddress !=
                                      null) {
                                    if (element.customer.customerShippingAddress
                                            .state ==
                                        currencyController.settingsModel.value
                                            .settings.stateId
                                            .toString()) {
                                      _checkoutController
                                          .checkoutModel.value.sameStateGstList
                                          .forEach((same) {
                                        gst = double.parse(
                                                ((price * same.taxPercentage) /
                                                        100)
                                                    .toString())
                                            .toPrecision(2);
                                        gstS =
                                            '${same.name}(${same.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
                                        gstShowList.add(gstS);
                                        gstID.add(same.id);
                                        gstAmount.add(gst);
                                      });

                                      addValueToMap(packageWiseTaxMap, '$index',
                                          gstAmount);
                                    } else {
                                      _checkoutController.checkoutModel.value
                                          .differantStateGstList
                                          .forEach((diff) {
                                        gst = double.parse(
                                                ((price * diff.taxPercentage) /
                                                        100)
                                                    .toString())
                                            .toPrecision(2);

                                        gstS =
                                            '${diff.name}(${diff.taxPercentage} %) : $gst${currencyController.appCurrency.value} ';
                                        gstShowList.add(gstS);
                                        gstID.add(diff.id);
                                        gstAmount.add(gst);
                                      });
                                      addValueToMap(packageWiseTaxMap, '$index',
                                          gstAmount);
                                    }
                                  }
                                } else {
                                  if ((element.customer
                                                  .customerShippingAddress !=
                                              null &&
                                          element.seller
                                                  .sellerBusinessInformation !=
                                              null) &&
                                      element.customer.customerShippingAddress
                                              .state ==
                                          element
                                              .seller
                                              .sellerBusinessInformation
                                              .businessState) {
                                    _checkoutController
                                        .checkoutModel.value.sameStateGstList
                                        .forEach((same) {
                                      gst = (price * same.taxPercentage) / 100;
                                      gstS =
                                          '${same.name}(${same.taxPercentage} %) : $gst${currencyController.appCurrency.value} ';
                                      gstShowList.add(gstS);
                                      gstID.add(same.id);
                                      gstAmount.add(gst);
                                    });
                                    addValueToMap(
                                        packageWiseTaxMap, '$index', gstAmount);
                                  } else {
                                    if (element
                                            .seller.sellerBusinessInformation ==
                                        null) {
                                      gst = (price *
                                              _checkoutController
                                                  .checkoutModel
                                                  .value
                                                  .flatGst
                                                  .taxPercentage) /
                                          100;

                                      gstS =
                                          '${_checkoutController.checkoutModel.value.flatGst.name}(${_checkoutController.checkoutModel.value.flatGst.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
                                      gstShowList.add(gstS);
                                      gstAmount.add(gst);

                                      addValueToMap(packageWiseTaxMap, '$index',
                                          gstAmount);
                                    } else {
                                      _checkoutController.checkoutModel.value
                                          .differantStateGstList
                                          .forEach((diff) {
                                        gst =
                                            (price * diff.taxPercentage) / 100;
                                        gstS =
                                            '${diff.name}(${diff.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
                                        gstShowList.add(gstS);
                                        gstID.add(diff.id);
                                        gstAmount.add(gst);
                                      });
                                      addValueToMap(packageWiseTaxMap, '$index',
                                          gstAmount);
                                    }
                                  }
                                }
                              } else {
                                ///
                                ///not enable gst
                                ///
                                log("not enable gst");
                                FlatGst flatGST = _checkoutController
                                    .checkoutModel.value.flatGst;
                                gst = (price * flatGST.taxPercentage) / 100;
                                gstS =
                                    '${flatGST.name}(${flatGST.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
                                gstShowList.add(gstS);
                                gstID.add(flatGST.id);
                                gstAmount.add(gst);

                                addValueToMap(
                                    packageWiseTaxMap, '$index', gstAmount);
                              }
                            });
                          }
                          if (currencyController.vendorType.value == 'single') {
                            return Obx(() {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _checkoutController
                                              .verticalGroupValue.value ==
                                          "Home Delivery"
                                      ? Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Select Shipping Method".tr,
                                                style: AppStyles.appFontMedium
                                                    .copyWith(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            ShippingDropDown(
                                              shippingValue: _checkoutController
                                                  .checkoutModel
                                                  .value
                                                  .packages
                                                  .values
                                                  .elementAt(index)
                                                  .shipping
                                                  .first,
                                              shippings: _checkoutController
                                                  .checkoutModel
                                                  .value
                                                  .packages
                                                  .values
                                                  .elementAt(index)
                                                  .shipping,
                                              packageIndex: index,
                                              price: price,
                                              totalWeight: totalWeight,
                                              orderData:
                                                  _checkoutController.orderData,
                                            ),
                                          ],
                                        )
                                      : Builder(builder: (context) {
                                          final Map<dynamic, dynamic>
                                              shippingCostMap =
                                              _checkoutController
                                                  .orderData['shipping_cost'];

                                          final Map<dynamic, dynamic>
                                              deliveryDateMap =
                                              _checkoutController
                                                  .orderData['delivery_date'];

                                          final Map<dynamic, dynamic>
                                              shippingMethodMap =
                                              _checkoutController
                                                  .orderData['shipping_method'];
                                          addValueToMap(shippingCostMap,
                                              index.toString(), "0");
                                          addValueToMap(
                                              deliveryDateMap,
                                              index.toString(),
                                              "Pick up from ${_checkoutController.selectedPickupValue.value.name}");
                                          addValueToMap(
                                              shippingMethodMap,
                                              index.toString(),
                                              "Pick up from ${_checkoutController.selectedPickupValue.value.name}");

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Pickup Location".tr,
                                                  style: AppStyles.appFontMedium
                                                      .copyWith(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "${_checkoutController.selectedPickupValue.value.name}"
                                                    .tr,
                                                textAlign: TextAlign.left,
                                                style: AppStyles.appFontBook,
                                              ),
                                              Text(
                                                "${_checkoutController.selectedPickupValue.value.address}"
                                                    .tr,
                                                textAlign: TextAlign.left,
                                                style: AppStyles.appFontBook,
                                              ),
                                            ],
                                          );
                                        }),
                                ],
                              );
                            });
                          } else {
                            return Container(
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Select Shipping Method".tr,
                                      textAlign: TextAlign.left,
                                      style: AppStyles.appFontMedium.copyWith(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ExpansionTileCard(
                                    contentPadding: EdgeInsets.zero,
                                    title: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/images/icon_delivery-parcel.png',
                                                    color: AppStyles.pinkColor,
                                                    width: 17,
                                                    height: 17,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Package'.tr +
                                                        ' ${index + 1}/${_checkoutController.packageCount.value}',
                                                    style: AppStyles.appFontBook
                                                        .copyWith(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 22.0),
                                                child: additionalShipping > 0.0
                                                    ? Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            'Additional Shipping'
                                                                    .tr +
                                                                ': ${(additionalShipping * currencyController.conversionRate.value)}${currencyController.appCurrency.value}',
                                                            style: AppStyles
                                                                .appFontLight
                                                                .copyWith(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : SizedBox.shrink(),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 22.0),
                                                child: Text(
                                                  'Sold by'.tr +
                                                      ': ${_checkoutController.checkoutModel.value.packages.entries.first.value.items.first.seller.name}',
                                                  style: AppStyles.appFontLight
                                                      .copyWith(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      ListView.separated(
                                          separatorBuilder: (contxt, index) {
                                            return Divider(
                                              height: 2,
                                            );
                                          },
                                          padding:
                                              const EdgeInsets.only(left: 22.0),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: _checkoutController
                                              .checkoutModel
                                              .value
                                              .packages
                                              .values
                                              .elementAt(index)
                                              .items
                                              .length,
                                          itemBuilder: (context, productIndex) {
                                            List<CheckoutItem> checkoutItem =
                                                _checkoutController
                                                    .checkoutModel
                                                    .value
                                                    .packages
                                                    .values
                                                    .elementAt(index)
                                                    .items;

                                            return Column(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          child: Container(
                                                            height: 60,
                                                            width: 90,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            color: Color(
                                                                0xffF1F1F1),
                                                            child: checkoutItem[
                                                                            productIndex]
                                                                        .productType ==
                                                                    ProductType
                                                                        .PRODUCT
                                                                ? checkoutItem[productIndex]
                                                                            .product
                                                                            .sku
                                                                            .variantImage !=
                                                                        null
                                                                    ? FancyShimmerImage(
                                                                        imageUrl: AppConfig.assetPath +
                                                                            '/' +
                                                                            checkoutItem[productIndex].product.sku.variantImage,
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        errorWidget:
                                                                            FancyShimmerImage(
                                                                          imageUrl:
                                                                              "${AppConfig.assetPath}/backend/img/default.png",
                                                                          boxFit:
                                                                              BoxFit.contain,
                                                                        ),
                                                                      )
                                                                    : FancyShimmerImage(
                                                                        imageUrl: AppConfig.assetPath +
                                                                            '/' +
                                                                            checkoutItem[productIndex].product.product.product.thumbnailImageSource,
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        errorWidget:
                                                                            FancyShimmerImage(
                                                                          imageUrl:
                                                                              "${AppConfig.assetPath}/backend/img/default.png",
                                                                          boxFit:
                                                                              BoxFit.contain,
                                                                        ),
                                                                      )
                                                                : FancyShimmerImage(
                                                                    imageUrl: AppConfig
                                                                            .assetPath +
                                                                        '/' +
                                                                        checkoutItem[productIndex]
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
                                                                  ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      checkoutItem[productIndex].productType ==
                                                                              ProductType.PRODUCT
                                                                          ? Text(
                                                                              checkoutItem[productIndex].product.product.product.productName,
                                                                              style: AppStyles.appFontBold.copyWith(fontSize: 13),
                                                                            )
                                                                          : Text(
                                                                              checkoutItem[productIndex].giftCard.name,
                                                                              style: AppStyles.appFontBold.copyWith(fontSize: 13),
                                                                            ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          checkoutItem[productIndex].productType == ProductType.PRODUCT
                                                                              ? checkoutItem[productIndex].product.product.avgRating > 0
                                                                                  ? StarCounterWidget(
                                                                                      value: checkoutItem[productIndex].product.product.avgRating.toDouble(),
                                                                                      color: AppStyles.pinkColor,
                                                                                      size: 14,
                                                                                    )
                                                                                  : StarCounterWidget(
                                                                                      value: 0,
                                                                                      color: AppStyles.pinkColor,
                                                                                      size: 14,
                                                                                    )
                                                                              : checkoutItem[productIndex].giftCard.avgRating > 0
                                                                                  ? StarCounterWidget(
                                                                                      value: checkoutItem[productIndex].giftCard.avgRating.toDouble(),
                                                                                      color: AppStyles.pinkColor,
                                                                                      size: 14,
                                                                                    )
                                                                                  : StarCounterWidget(
                                                                                      value: 0,
                                                                                      color: AppStyles.pinkColor,
                                                                                      size: 14,
                                                                                    ),
                                                                          SizedBox(
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          checkoutItem[productIndex].productType == ProductType.PRODUCT
                                                                              ? checkoutItem[productIndex].product.product.avgRating > 0
                                                                                  ? Text(
                                                                                      '(${checkoutItem[productIndex].product.product.avgRating.toString()})',
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: AppStyles.appFontBook.copyWith(
                                                                                        color: AppStyles.greyColorDark,
                                                                                        fontSize: 10,
                                                                                      ),
                                                                                    )
                                                                                  : Text(
                                                                                      '(0)',
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: AppStyles.appFontBook.copyWith(
                                                                                        color: AppStyles.greyColorDark,
                                                                                        fontSize: 10,
                                                                                      ),
                                                                                    )
                                                                              : checkoutItem[productIndex].giftCard.avgRating > 0
                                                                                  ? Text(
                                                                                      '(${checkoutItem[productIndex].giftCard.avgRating.toString()})',
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: AppStyles.appFontBook.copyWith(
                                                                                        color: AppStyles.greyColorDark,
                                                                                        fontSize: 10,
                                                                                      ),
                                                                                    )
                                                                                  : Text(
                                                                                      '(0)',
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: AppStyles.appFontBook.copyWith(
                                                                                        color: AppStyles.greyColorDark,
                                                                                        fontSize: 10,
                                                                                      ),
                                                                                    ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Wrap(
                                                                        runSpacing:
                                                                            5,
                                                                        children: [
                                                                          Text(
                                                                            currencyController.appCurrency.value +
                                                                                (checkoutItem[productIndex].totalPrice * currencyController.conversionRate.value).toStringAsFixed(2),
                                                                            style:
                                                                                AppStyles.appFontBold.copyWith(
                                                                              fontSize: 12,
                                                                              color: AppStyles.pinkColor,
                                                                            ),
                                                                          ),

                                                                          //** VARIATIONS */
                                                                          checkoutItem[productIndex].productType == ProductType.GIFT_CARD
                                                                              ? SizedBox.shrink()
                                                                              : checkoutItem[productIndex].product.productVariations.length > 0
                                                                                  ? Row(
                                                                                      children: List.generate(checkoutItem[productIndex].product.productVariations.length, (variationIndex) {
                                                                                      if (checkoutItem[productIndex].product.productVariations[variationIndex].attribute.name == 'Color') {
                                                                                        return Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              '${checkoutItem[productIndex].product.productVariations[variationIndex].attribute.name}: ${checkoutItem[productIndex].product.productVariations[variationIndex].attributeValue.color.name}',
                                                                                              style: AppStyles.kFontGrey12w5,
                                                                                            ),
                                                                                            Text(
                                                                                              variationIndex == checkoutItem[productIndex].product.productVariations.length - 1 ? '' : ', ',
                                                                                              style: AppStyles.kFontGrey12w5,
                                                                                            ),
                                                                                          ],
                                                                                        );
                                                                                      }
                                                                                      return Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            '${checkoutItem[productIndex].product.productVariations[variationIndex].attribute.name}: ${checkoutItem[productIndex].product.productVariations[variationIndex].attributeValue.value}',
                                                                                            style: AppStyles.kFontGrey12w5,
                                                                                          ),
                                                                                          Text(
                                                                                            variationIndex == checkoutItem[productIndex].product.productVariations.length - 1 ? '' : ', ',
                                                                                            style: AppStyles.kFontGrey12w5,
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    }))
                                                                                  : SizedBox.shrink(),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  'Qty'.tr +
                                                                      ': ${checkoutItem[productIndex].qty}',
                                                                  style: AppStyles
                                                                      .kFontBlack12w4,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          }),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 22.0),
                                              child: Divider(
                                                color: AppStyles.greyColorAlt,
                                                height: 1,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '$qty ' +
                                                      'Item(s), Total: '.tr +
                                                      '${double.parse((price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                  style: AppStyles.appFontBook
                                                      .copyWith(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 22.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Shipping".tr + ": ",
                                        textAlign: TextAlign.left,
                                        style: AppStyles.appFontBook.copyWith(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 22.0),
                                    child: ShippingDropDown(
                                      shippingValue: _checkoutController
                                          .checkoutModel.value.packages.values
                                          .elementAt(index)
                                          .shipping
                                          .first,
                                      shippings: _checkoutController
                                          .checkoutModel.value.packages.values
                                          .elementAt(index)
                                          .shipping,
                                      packageIndex: index,
                                      price: price,
                                      totalWeight: totalWeight,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        });
                  } else {
                    return SizedBox.shrink();
                  }
                }),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: Get.width,
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppStyles.pinkColor,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 10,
                            ),
                            child: Text(
                              "Back",
                              textAlign: TextAlign.center,
                              style: AppStyles.appFontBook.copyWith(
                                color: AppStyles.pinkColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: PinkButtonWidget(
                        btnOnTap: () {
                          _checkoutController.orderData
                              .addAll(_checkoutPage2Data);

                          _checkoutController.orderData.addAll({
                            'shipping_total':
                                _checkoutController.shipping.value,
                            'grand_total': _checkoutController.grandTotal.value,
                          });

                          log(_checkoutController.orderData
                              .toJson()
                              .toString());

                          Get.to(() => CheckoutPageThree());
                        },
                        height: 45,
                        width: Get.width,
                        btnText: "Next",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ShippingDropDown extends StatefulWidget {
  Shipping shippingValue;
  final int packageIndex;
  final double price;

  final double totalWeight;
  final List<Shipping> shippings;
  Map orderData;

  ShippingDropDown({
    this.shippingValue,
    this.packageIndex,
    this.shippings,
    this.price,
    this.totalWeight,
    this.orderData,
  });

  @override
  _ShippingDropDownState createState() => _ShippingDropDownState();
}

class _ShippingDropDownState extends State<ShippingDropDown> {
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  final CheckoutController checkoutController = Get.put(CheckoutController());

  void addValueToMap<K, V>(Map<K, V> map, K key, V value) {
    map.update(key, (v) => value, ifAbsent: () => value);
  }

  double shippingCost2 = 0.0;

  double additionalShipping;

  String calculateArrival(shipmentTime) {
    var arr = shipmentTime;
    if (arr.contains('days')) {
      arr = arr.replaceAll(' days', '');
      arr = 'Est. Arrival Date: ' +
          CustomDate().formattedDateOnly(DateTime.now()
              .add(Duration(days: int.parse(arr.split('-').first)))) +
          '-' +
          CustomDate().formattedDateOnly(DateTime.now()
              .add(Duration(days: int.parse(arr.split('-').last))));
    } else {
      arr = 'Est. Arrival Time: ' + arr;
    }
    return arr;
  }

  @override
  void initState() {
    additionalShipping = 0.0;
    checkoutController.checkoutModel.value.packages.forEach((key, value) {
      value.items.forEach((CheckoutItem itemEl) {
        if (itemEl.productType == ProductType.PRODUCT) {
          additionalShipping += itemEl.product.sku.additionalShipping;
        }
      });
    });

    if (widget.shippingValue.costBasedOn == 'Price') {
      if (widget.price > 0) {
        shippingCost2 = (widget.price / 100) * double.parse( widget.shippingValue.cost) +
            additionalShipping;
      }
    } else if (widget.shippingValue.costBasedOn == 'Weight') {
      if (widget.totalWeight > 0) {
        shippingCost2 = (widget.totalWeight / 100) * double.parse(widget.shippingValue.cost )+
            additionalShipping;
      }
    } else {
      if (double.parse(widget.shippingValue.cost ) > 0) {
        shippingCost2 = double.parse(widget.shippingValue.cost ) + additionalShipping;
      }
    }

    final Map<dynamic, dynamic> shippingCostMap =
        checkoutController.orderData['shipping_cost'];

    final Map<dynamic, dynamic> deliveryDateMap =
        checkoutController.orderData['delivery_date'];

    final Map<dynamic, dynamic> shippingMethodMap =
        checkoutController.orderData['shipping_method'];
    addValueToMap(shippingCostMap, '${widget.packageIndex}', shippingCost2);
    addValueToMap(deliveryDateMap, '${widget.packageIndex}',
        calculateArrival(widget.shippingValue.shipmentTime));
    addValueToMap(
        shippingMethodMap, '${widget.packageIndex}', widget.shippingValue.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(
          color: Color.fromARGB(45, 253, 73, 73),
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: DropdownButton<Shipping>(
        elevation: 1,
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: Container(),
        value: widget.shippingValue,
        itemHeight: 100,
        items: widget.shippings.map((e) {
          String basedOn = '';
          double shippingCost = 0.0;

          if (e.costBasedOn == "Price") {
            basedOn = "Based on Per Hundred".tr;
          } else if (e.costBasedOn == "Weight") {
            basedOn = "Based on Per 100 Gm".tr;
          } else {
            basedOn = "Based on Flat Rate".tr;
          }

          if (e.costBasedOn == 'Price') {
            if (widget.price > 0) {
              shippingCost =
                  ((widget.price / 100) * double.parse(e.cost)) + additionalShipping;
            }
          } else if (e.costBasedOn == 'Weight') {
            if (widget.totalWeight > 0) {
              shippingCost =
                  ((widget.totalWeight / 100) * double.parse(e.cost)) + additionalShipping;
            }
          } else {
            if (double.parse(e.cost) > 0) {
              shippingCost = double.parse(e.cost) + additionalShipping;
            }
          }

          return DropdownMenuItem<Shipping>(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${e.methodName}",
                        style: AppStyles.kFontBlack14w5.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${double.parse("${shippingCost * currencyController.conversionRate.value}").toStringAsFixed(2)}${currencyController.appCurrency.value}",
                        style: AppStyles.kFontBlack14w5.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "[${e.shipmentTime} - ($basedOn)]",
                    style: AppStyles.kFontBlack14w5,
                  ),
                  currencyController.vendorType.value == "single"
                      ? Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            "Minimum shopping amount (without shipping cost): ${double.parse("${double.parse(e.minimumShopping) * currencyController.conversionRate.value}").toStringAsFixed(2)}${currencyController.appCurrency.value}",
                            style:
                                AppStyles.kFontBlack14w5.copyWith(fontSize: 12),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            value: e,
          );
        }).toList(),
        onChanged: (Shipping value) {
          if (currencyController.vendorType.value == "single") {
            if (!(double.parse(value.minimumShopping) >= checkoutController.subTotal.value)) {
              setState(() {
                widget.shippingValue = value;

                checkoutController.selectedShipping[widget.packageIndex] =
                    value;

                double shippingCost = 0.0;

                if (widget.shippingValue.costBasedOn == 'Price') {
                  if (widget.price > 0) {
                    shippingCost =
                        (widget.price / 100) * double.parse( widget.shippingValue.cost) +
                            additionalShipping;
                  }
                } else if (widget.shippingValue.costBasedOn == 'Weight') {
                  if (widget.totalWeight > 0) {
                    shippingCost =
                        (widget.totalWeight / 100) * double.parse( widget.shippingValue.cost) +
                            additionalShipping;
                  }
                } else {
                  if (double.parse( widget.shippingValue.cost) > 0) {
                    shippingCost =
                        double.parse( widget.shippingValue.cost) + additionalShipping;
                  }
                }

                final Map<dynamic, dynamic> shippingCostMap =
                    checkoutController.orderData['shipping_cost'];

                final Map<dynamic, dynamic> deliveryDateMap =
                    checkoutController.orderData['delivery_date'];

                final Map<dynamic, dynamic> shippingMethodMap =
                    checkoutController.orderData['shipping_method'];

                addValueToMap(
                    shippingCostMap, '${widget.packageIndex}', shippingCost);

                addValueToMap(deliveryDateMap, '${widget.packageIndex}',
                    calculateArrival(value.shipmentTime));

                addValueToMap(
                    shippingMethodMap, '${widget.packageIndex}', value.id);

                double totalShipping = 0.0;

                shippingCostMap.forEach((key, value) {
                  print(value);
                  totalShipping += double.parse(value.toString());
                });

                checkoutController.shipping.value =
                    totalShipping.toPrecision(2);

                checkoutController.grandTotal.value =
                    (checkoutController.subTotal.value +
                                checkoutController.shipping.value +
                                checkoutController.gstTotal.value)
                            .toPrecision(2) -
                        checkoutController.discountTotal.value;
              });
            }
          } else {
            setState(() {
              widget.shippingValue = value;

              checkoutController.selectedShipping[widget.packageIndex] = value;

              double shippingCost = 0.0;

              if (widget.shippingValue.costBasedOn == 'Price') {
                if (widget.price > 0) {
                  shippingCost =
                      (widget.price / 100) * double.parse( widget.shippingValue.cost)+
                          additionalShipping;
                }
              } else if (widget.shippingValue.costBasedOn == 'Weight') {
                if (widget.totalWeight > 0) {
                  shippingCost =
                      (widget.totalWeight / 100) * double.parse(widget.shippingValue.cost) +
                          additionalShipping;
                }
              } else {
                if (double.parse( widget.shippingValue.cost) > 0) {
                  shippingCost = double.parse(widget.shippingValue.cost) + additionalShipping;
                }
              }

              final Map<dynamic, dynamic> shippingCostMap =
                  checkoutController.orderData['shipping_cost'];

              final Map<dynamic, dynamic> deliveryDateMap =
                  checkoutController.orderData['delivery_date'];

              final Map<dynamic, dynamic> shippingMethodMap =
                  checkoutController.orderData['shipping_method'];

              addValueToMap(
                  shippingCostMap, '${widget.packageIndex}', shippingCost);

              addValueToMap(deliveryDateMap, '${widget.packageIndex}',
                  calculateArrival(value.shipmentTime));

              addValueToMap(
                  shippingMethodMap, '${widget.packageIndex}', value.id);

              double totalShipping = 0.0;

              shippingCostMap.forEach((key, value) {
                print(value);
                totalShipping += double.parse(value.toString());
              });

              checkoutController.shipping.value = totalShipping.toPrecision(2);

              checkoutController.grandTotal.value =
                  (checkoutController.subTotal.value +
                              checkoutController.shipping.value +
                              checkoutController.gstTotal.value)
                          .toPrecision(2) -
                      checkoutController.discountTotal.value;
            });
          }
        },
      ),
    );
  }
}
