import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/Order/OrderData.dart';
import 'package:amazy_app/model/Order/Package.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/account/orders/OrderDetails.dart';
import 'package:amazy_app/widgets/CustomDate.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amazy_app/model/Product/ProductType.dart';

class OrderAllToPayListDataWidget extends StatelessWidget {
  OrderAllToPayListDataWidget({this.order});
  final OrderData order;

  final GeneralSettingsController currencyController =
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
      }
      if (order.isCompleted == 1) {
        orderStatus = 'Completed'.tr;
      }
      if (order.isConfirmed == 1) {
        orderStatus = 'Confirmed'.tr;
      }
      if (order.isPaid == 1) {
        orderStatus = 'Paid'.tr;
      }
    }
    return orderStatus;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => OrderDetails(
              order: order,
            ));
      },
      child: Container(
        color: context.theme.cardColor,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order.orderNumber.capitalizeFirst,
                          style: AppStyles.appFontBook.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: AppStyles.pinkColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.2,
                    ),
                    Text(
                      'Placed on'.tr +
                          ': ' +
                          CustomDate().formattedDateTime(order.createdAt),
                      style: AppStyles.appFontBook.copyWith(
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(
                      height: 5.2,
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Text(
                  '${orderStatusGet(order)}',
                  style: AppStyles.appFontBook.copyWith(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: order.packages.length,
                itemBuilder: (context, packageIndex) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                        order
                                            .packages[packageIndex].packageCode,
                                        style: AppStyles.appFontBook.copyWith(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  currencyController.vendorType.value ==
                                          "single"
                                      ? SizedBox.shrink()
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              left: 24.0, top: 5),
                                          child: Text(
                                            'Sold by'.tr +
                                                ': ' +
                                                order.packages[packageIndex]
                                                    .seller.firstName,
                                            style:
                                                AppStyles.appFontBook.copyWith(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 24.0, top: 5),
                                    child: Text(
                                      order.packages[packageIndex].shippingDate,
                                      style: AppStyles.appFontBook.copyWith(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              deliverStateName(order.packages[packageIndex]),
                              textAlign: TextAlign.center,
                              style: AppStyles.kFontDarkBlue12w5
                                  .copyWith(fontStyle: FontStyle.italic),
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
                            itemCount:
                                order.packages[packageIndex].products.length,
                            itemBuilder: (context, productIndex) {
                              if (order.packages[packageIndex]
                                      .products[productIndex].type ==
                                  ProductType.GIFT_CARD) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        child: Container(
                                            height: 60,
                                            width: 90,
                                            padding: EdgeInsets.all(5),
                                            color: Color(0xffF1F1F1),
                                            child: FancyShimmerImage(
                                              imageUrl: AppConfig.assetPath +
                                                  '/' +
                                                  order
                                                      .packages[packageIndex]
                                                      .products[productIndex]
                                                      .giftCard
                                                      .thumbnailImage,
                                              boxFit: BoxFit.contain,
                                              errorWidget: FancyShimmerImage(
                                                imageUrl:
                                                    "${AppConfig.assetPath}/backend/img/default.png",
                                                boxFit: BoxFit.contain,
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
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order
                                                    .packages[packageIndex]
                                                    .products[productIndex]
                                                    .giftCard
                                                    .name,
                                                style: AppStyles.appFontBook
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
                                                    '${(order.packages[packageIndex].products[productIndex].price * currencyController.conversionRate.value).toString()}${currencyController.appCurrency.value}',
                                                    style: AppStyles.appFontBook
                                                        .copyWith(
                                                      fontSize: 12,
                                                      color:
                                                          AppStyles.pinkColor,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(),
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
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        child: Container(
                                            height: 60,
                                            width: 90,
                                            padding: EdgeInsets.all(5),
                                            color: Color(0xffF1F1F1),
                                            child: FancyShimmerImage(
                                              imageUrl: order
                                                          .packages[
                                                              packageIndex]
                                                          .products[
                                                              productIndex]
                                                          .sellerProductSku
                                                          .sku
                                                          .variantImage !=
                                                      null
                                                  ? '${AppConfig.assetPath}/${order.packages[packageIndex].products[productIndex].sellerProductSku.sku.variantImage}'
                                                  : '${AppConfig.assetPath}/${order.packages[packageIndex].products[productIndex].sellerProductSku.product.product.thumbnailImageSource}',
                                              boxFit: BoxFit.contain,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order
                                                    .packages[packageIndex]
                                                    .products[productIndex]
                                                    .sellerProductSku
                                                    .product
                                                    .productName,
                                                style: AppStyles.appFontBook
                                                    .copyWith(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: order
                                                    .packages[packageIndex]
                                                    .products[productIndex]
                                                    .sellerProductSku
                                                    .productVariations
                                                    .length,
                                                itemBuilder:
                                                    (context, variantIndex) {
                                                  if (order
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
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Text(
                                                        'Color: ${order.packages[packageIndex].products[productIndex].sellerProductSku.productVariations[variantIndex].attributeValue.color.name}',
                                                        style: AppStyles
                                                            .appFontBook
                                                            .copyWith(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Text(
                                                        '${order.packages[packageIndex].products[productIndex].sellerProductSku.productVariations[variantIndex].attribute.name}: ${order.packages[packageIndex].products[productIndex].sellerProductSku.productVariations[variantIndex].attributeValue.value}',
                                                        style: AppStyles
                                                            .appFontBook
                                                            .copyWith(
                                                          fontSize: 10,
                                                        ),
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
                                                        MainAxisAlignment.start,
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
                                                                .center,
                                                        children: [
                                                          Text(
                                                            '${(order.packages[packageIndex].products[productIndex].price * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                            style: AppStyles
                                                                .appFontBook
                                                                .copyWith(
                                                              fontSize: 12,
                                                              color: AppStyles
                                                                  .pinkColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            '(${order.packages[packageIndex].products[productIndex].qty}x)',
                                                            style: AppStyles
                                                                .appFontBook
                                                                .copyWith(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Container(),
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
                  '${order.packages.length} ' +
                      'Package'.tr +
                      ',' +
                      'Total'.tr +
                      ': ' +
                      (order.grandTotal *
                              currencyController.conversionRate.value)
                          .toStringAsFixed(2) +
                      '${currencyController.appCurrency.value}',
                  style: AppStyles.appFontBook.copyWith(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
