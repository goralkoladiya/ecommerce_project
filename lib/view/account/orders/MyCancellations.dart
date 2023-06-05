import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/cancelled_order_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/Order/OrderData.dart';
import 'package:amazy_app/model/Order/Package.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/account/orders/OrderDetails.dart';
import 'package:amazy_app/widgets/AppBarWidget.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:amazy_app/model/Product/ProductType.dart';

class MyCancellations extends StatefulWidget {
  @override
  _MyCancellationsState createState() => _MyCancellationsState();
}

class _MyCancellationsState extends State<MyCancellations> {
  final CancelledOrderController cancelledController =
      Get.put(CancelledOrderController());

  final GeneralSettingsController _currencyController =
      Get.put(GeneralSettingsController());

  String deliverStateName(Package package) {
    var deliveryStatus;
    package.processes.forEach((element) {
      if (package.deliveryStatus == element.id) {
        deliveryStatus = element.name;
      } else if (package.deliveryStatus == 0) {
        deliveryStatus = "";
      }
    });
    return deliveryStatus;
  }

  String orderStatusGet(OrderData order) {
    var orderStatus;

    if (order.isCancelled == 0 &&
        order.isCompleted == 0 &&
        order.isConfirmed == 0 &&
        order.isPaid == 0) {
      orderStatus = 'Pending'.tr;
    } else {
      if (order.isCancelled == 1) {
        orderStatus = "Cancelled".tr;
      } else if (order.isCompleted == 1) {
        orderStatus = 'Completed'.tr;
      } else if (order.isConfirmed == 1) {
        orderStatus = 'Confirmed'.tr;
      } else if (order.isPaid == 1) {
        orderStatus = 'Paid'.tr;
      }
    }
    return orderStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(title: 'Cancelled Orders'.tr),
      body: Obx(
        () {
          if (cancelledController.isAllOrderLoading.value) {
            return Center(
              child: CustomLoadingWidget(),
            );
          } else {
            if (cancelledController.cancelledOrderListModel.value.orders ==
                    null ||
                cancelledController
                        .cancelledOrderListModel.value.orders.length ==
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
                      'No Cancelled Orders'.tr,
                      textAlign: TextAlign.center,
                      style: AppStyles.kFontPink15w5.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    color: AppStyles.appBackgroundColor,
                    height: 5,
                    thickness: 5,
                  );
                },
                itemCount: cancelledController
                    .cancelledOrderListModel.value.orders.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => OrderDetails(
                                  order: cancelledController
                                      .cancelledOrderListModel
                                      .value
                                      .orders[index],
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        cancelledController
                                            .cancelledOrderListModel
                                            .value
                                            .orders[index]
                                            .orderNumber
                                            .capitalizeFirst,
                                        style: AppStyles.appFontMedium.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          size: 10, color: AppStyles.pinkColor),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.2,
                                  ),
                                  Text(
                                    'Placed on'.tr +
                                        ': ' +
                                        cancelledController
                                            .cancelledOrderListModel
                                            .value
                                            .orders[index]
                                            .createdAt
                                            .toLocal()
                                            .toString(),
                                    style: AppStyles.appFontMedium.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.2,
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                '${orderStatusGet(cancelledController.cancelledOrderListModel.value.orders[index])}',
                                style: AppStyles.kFontBlack12w4,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cancelledController
                                .cancelledOrderListModel
                                .value
                                .orders[index]
                                .packages
                                .length,
                            itemBuilder: (context, packageIndex) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                    width: 17,
                                                    height: 17,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(
                                                    cancelledController
                                                        .cancelledOrderListModel
                                                        .value
                                                        .orders[index]
                                                        .packages[packageIndex]
                                                        .packageCode,
                                                    style: AppStyles
                                                        .appFontMedium
                                                        .copyWith(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              _currencyController
                                                          .vendorType.value !=
                                                      "single"
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 26.0, top: 5),
                                                      child: Text(
                                                        'Sold by'.tr +
                                                            ': ' +
                                                            cancelledController
                                                                .cancelledOrderListModel
                                                                .value
                                                                .orders[index]
                                                                .packages[
                                                                    packageIndex]
                                                                .seller
                                                                .firstName,
                                                        style: AppStyles
                                                            .appFontMedium
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox.shrink(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 26.0, top: 5),
                                                child: Text(
                                                  cancelledController
                                                      .cancelledOrderListModel
                                                      .value
                                                      .orders[index]
                                                      .packages[packageIndex]
                                                      .shippingDate,
                                                  style: AppStyles.appFontMedium
                                                      .copyWith(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          deliverStateName(cancelledController
                                              .cancelledOrderListModel
                                              .value
                                              .orders[index]
                                              .packages[packageIndex]),
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontDarkBlue12w5
                                              .copyWith(
                                                  fontStyle: FontStyle.italic),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return Divider(
                                            color: AppStyles.appBackgroundColor,
                                            height: 2,
                                            thickness: 2,
                                          );
                                        },
                                        shrinkWrap: true,
                                        padding: EdgeInsets.only(left: 26.0),
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: cancelledController
                                            .cancelledOrderListModel
                                            .value
                                            .orders[index]
                                            .packages[packageIndex]
                                            .products
                                            .length,
                                        itemBuilder: (context, productIndex) {
                                          if (cancelledController
                                                  .cancelledOrderListModel
                                                  .value
                                                  .orders[index]
                                                  .packages[packageIndex]
                                                  .products[productIndex]
                                                  .type ==
                                              ProductType.GIFT_CARD) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    child: Container(
                                                        height: 60,
                                                        width: 90,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        color:
                                                            Color(0xffF1F1F1),
                                                        child:
                                                            FancyShimmerImage(
                                                          imageUrl: AppConfig
                                                                  .assetPath +
                                                              '/' +
                                                              cancelledController
                                                                  .cancelledOrderListModel
                                                                  .value
                                                                  .orders[index]
                                                                  .packages[
                                                                      packageIndex]
                                                                  .products[
                                                                      productIndex]
                                                                  .giftCard
                                                                  .thumbnailImage,
                                                          boxFit:
                                                              BoxFit.contain,
                                                          errorWidget:
                                                              FancyShimmerImage(
                                                            imageUrl:
                                                                "${AppConfig.assetPath}/backend/img/default.png",
                                                            boxFit:
                                                                BoxFit.contain,
                                                          ),
                                                        )),
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
                                                            cancelledController
                                                                .cancelledOrderListModel
                                                                .value
                                                                .orders[index]
                                                                .packages[
                                                                    packageIndex]
                                                                .products[
                                                                    productIndex]
                                                                .giftCard
                                                                .name,
                                                            style: AppStyles
                                                                .appFontMedium
                                                                .copyWith(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Text(
                                                                '${(cancelledController.cancelledOrderListModel.value.orders[index].packages[packageIndex].products[productIndex].giftCard.sellingPrice * _currencyController.conversionRate.value).toString()}${_currencyController.appCurrency.value}',
                                                                style: AppStyles
                                                                    .appFontMedium
                                                                    .copyWith(
                                                                  fontSize: 12,
                                                                  color: AppStyles
                                                                      .pinkColor,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(),
                                                              ),
                                                            ],
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
                                            );
                                          } else {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    child: Container(
                                                        height: 60,
                                                        width: 90,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        color:
                                                            Color(0xffF1F1F1),
                                                        child:
                                                            FancyShimmerImage(
                                                          imageUrl: AppConfig
                                                                  .assetPath +
                                                              '/' +
                                                              cancelledController
                                                                  .cancelledOrderListModel
                                                                  .value
                                                                  .orders[index]
                                                                  .packages[
                                                                      packageIndex]
                                                                  .products[
                                                                      productIndex]
                                                                  .sellerProductSku
                                                                  .product
                                                                  .product
                                                                  .thumbnailImageSource,
                                                          boxFit:
                                                              BoxFit.contain,
                                                          errorWidget:
                                                              FancyShimmerImage(
                                                            imageUrl:
                                                                "${AppConfig.assetPath}/backend/img/default.png",
                                                            boxFit:
                                                                BoxFit.contain,
                                                          ),
                                                        )),
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
                                                            cancelledController
                                                                .cancelledOrderListModel
                                                                .value
                                                                .orders[index]
                                                                .packages[
                                                                    packageIndex]
                                                                .products[
                                                                    productIndex]
                                                                .sellerProductSku
                                                                .product
                                                                .productName,
                                                            style: AppStyles
                                                                .appFontMedium
                                                                .copyWith(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemCount: cancelledController
                                                                .cancelledOrderListModel
                                                                .value
                                                                .orders[index]
                                                                .packages[
                                                                    packageIndex]
                                                                .products[
                                                                    productIndex]
                                                                .sellerProductSku
                                                                .productVariations
                                                                .length,
                                                            itemBuilder: (context,
                                                                variantIndex) {
                                                              if (cancelledController
                                                                      .cancelledOrderListModel
                                                                      .value
                                                                      .orders[
                                                                          index]
                                                                      .packages[
                                                                          packageIndex]
                                                                      .products[
                                                                          productIndex]
                                                                      .sellerProductSku
                                                                      .productVariations[
                                                                          variantIndex]
                                                                      .attribute
                                                                      .name ==
                                                                  'Color') {
                                                                return Text(
                                                                  'Color'.tr +
                                                                      ': ${cancelledController.cancelledOrderListModel.value.orders[index].packages[packageIndex].products[productIndex].sellerProductSku.productVariations[variantIndex].attributeValue.color.name}',
                                                                  style: AppStyles
                                                                      .appFontMedium
                                                                      .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                );
                                                              } else {
                                                                return Text(
                                                                  'Storage'.tr +
                                                                      ': ${cancelledController.cancelledOrderListModel.value.orders[index].packages[packageIndex].products[productIndex].sellerProductSku.productVariations[variantIndex].attributeValue.value}',
                                                                  style: AppStyles
                                                                      .appFontMedium
                                                                      .copyWith(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        '${_currencyController.appCurrency.value}${(cancelledController.cancelledOrderListModel.value.orders[index].packages[packageIndex].products[productIndex].price * _currencyController.conversionRate.value).toStringAsFixed(2)}',
                                                                        style: AppStyles
                                                                            .appFontMedium
                                                                            .copyWith(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              AppStyles.pinkColor,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        '(${cancelledController.cancelledOrderListModel.value.orders[index].packages[packageIndex].products[productIndex].qty}x)',
                                                                        style: AppStyles
                                                                            .appFontMedium
                                                                            .copyWith(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(),
                                                              ),
                                                              // Text(
                                                              //   '=\$${orderController.orderListModel.value.orders[index].packages[packageIndex].products[productIndex].totalPrice}',
                                                              //   style: AppStyles
                                                              //       .kFontBlack14w5,
                                                              // ),
                                                            ],
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
                                            );
                                          }
                                        }),
                                  ],
                                ),
                              );
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${cancelledController.cancelledOrderListModel.value.orders[index].packages.length} ' +
                                  'Package'.tr +
                                  ',' +
                                  'Total'.tr +
                                  ': ' +
                                  '${_currencyController.appCurrency.value}' +
                                  (cancelledController.cancelledOrderListModel
                                              .value.orders[index].grandTotal *
                                          _currencyController
                                              .conversionRate.value)
                                      .toStringAsFixed(2),
                              style: AppStyles.appFontMedium.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
