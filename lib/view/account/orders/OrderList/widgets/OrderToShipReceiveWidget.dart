import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/Order/OrderProductElement.dart';
import 'package:amazy_app/model/Order/Package.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../OrderToShipDetails.dart';

class OrderToShipReceiveWidget extends StatelessWidget {
  OrderToShipReceiveWidget({this.package});
  final Package package;

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

  double calculateTotalProductPrice(List<OrderProductElement> products) {
    double priceTotal = 0.0;
    products.forEach((element) {
      priceTotal = priceTotal + element.totalPrice;
    });
    return priceTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => OrderToShipDetails(
                    package: package,
                  ));
            },
            child: Row(
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
                            package.packageCode,
                            style: AppStyles.appFontBook.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: AppStyles.pinkColor,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 26.0, top: 5),
                        child: Text(
                          package.shippingDate,
                          style: AppStyles.appFontBook.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  deliverStateName(package),
                  textAlign: TextAlign.center,
                  style: AppStyles.kFontDarkBlue12w5
                      .copyWith(fontStyle: FontStyle.italic),
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
              padding: EdgeInsets.symmetric(horizontal: 26),
              itemCount: package.products.length,
              itemBuilder: (context, productIndex) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Container(
                            height: 60,
                            width: 90,
                            padding: EdgeInsets.all(5),
                            color: Color(0xffF1F1F1),
                            child: FancyShimmerImage(
                              imageUrl: package.products[productIndex]
                                          .sellerProductSku.sku.variantImage !=
                                      null
                                  ? '${AppConfig.assetPath}/${package.products[productIndex].sellerProductSku.sku.variantImage}'
                                  : '${AppConfig.assetPath}/${package.products[productIndex].sellerProductSku.product.product.thumbnailImageSource}',
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                package.products[productIndex].sellerProductSku
                                    .product.productName,
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: package.products[productIndex]
                                    .sellerProductSku.productVariations.length,
                                itemBuilder: (context, variantIndex) {
                                  if (package
                                          .products[productIndex]
                                          .sellerProductSku
                                          .productVariations[variantIndex]
                                          .attribute
                                          .name ==
                                      'Color') {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        'Color' +
                                            ': ${package.products[productIndex].sellerProductSku.productVariations[variantIndex].attributeValue.color.name}',
                                        style: AppStyles.appFontBook.copyWith(
                                          fontSize: 12,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        '${package.products[productIndex].sellerProductSku.productVariations[variantIndex].attribute.name}' +
                                            ': ${package.products[productIndex].sellerProductSku.productVariations[variantIndex].attributeValue.value}',
                                        style: AppStyles.appFontBook.copyWith(
                                          fontSize: 12,
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
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${(package.products[productIndex].price * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                            style:
                                                AppStyles.appFontBook.copyWith(
                                              fontSize: 12,
                                              color: AppStyles.pinkColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '(${package.products[productIndex].qty}x)',
                                            style:
                                                AppStyles.appFontBook.copyWith(
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
              }),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${package.products.length} ' +
                    'Products'.tr +
                    ',' +
                    'Total'.tr +
                    ': ' +
                    (package.order.grandTotal *
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
    );
  }
}
