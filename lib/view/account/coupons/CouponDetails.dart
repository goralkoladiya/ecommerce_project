import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/MyCouponsModel.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/RecommendedProductLoadMore.dart';
import 'package:amazy_app/widgets/BuildIndicatorBuilder.dart';
import 'package:amazy_app/widgets/CustomDate.dart';
import 'package:amazy_app/widgets/single_product_widgets/GridViewProductWidget.dart';
import 'package:amazy_app/widgets/PinkButtonWidget.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:amazy_app/widgets/AppBarWidget.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

class CouponDetails extends StatefulWidget {
  final CouponCoupon coupon;

  CouponDetails({this.coupon});

  @override
  _CouponDetailsState createState() => _CouponDetailsState();
}

class _CouponDetailsState extends State<CouponDetails> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  final GlobalKey<ExpansionTileCardState> cardB = new GlobalKey();

  RecommendedProductsLoadMore source;

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  @override
  void initState() {
    source = RecommendedProductsLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Coupon Details'.tr,
      ),
      body: LoadingMoreCustomScrollView(
        // rebuildCustomScrollView: true,
        showGlowLeading: false,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned.fill(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.asset(
                                    'assets/images/voucher_bg.png',
                                    fit: BoxFit.fill,
                                    color: AppStyles.pinkColorAlt,
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: DottedLine(
                                      direction: Axis.horizontal,
                                      lineLength: double.infinity,
                                      lineThickness: 4.0,
                                      dashLength: 4.0,
                                      dashColor: AppStyles.appBackgroundColor,
                                      dashGapLength: 4.0,
                                      dashGapColor: Colors.transparent,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: DottedLine(
                                      direction: Axis.horizontal,
                                      lineLength: double.infinity,
                                      lineThickness: 4.0,
                                      dashLength: 4.0,
                                      dashColor: AppStyles.appBackgroundColor,
                                      dashGapLength: 4.0,
                                      dashGapColor: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 20,
                              top: 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.coupon.title.capitalizeFirst,
                                    style: AppStyles.appFontBook.copyWith(
                                      color: AppStyles.blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6.0),
                                            child: widget.coupon.discountType ==
                                                    0
                                                ? Text(
                                                    '%',
                                                    style: AppStyles.appFontBook
                                                        .copyWith(
                                                      color:
                                                          AppStyles.pinkColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : Text(
                                                    '${currencyController.appCurrency.value}',
                                                    style: AppStyles.appFontBook
                                                        .copyWith(
                                                      color:
                                                          AppStyles.pinkColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                          ),
                                          widget.coupon.discountType == 0
                                              ? Text(
                                                  widget.coupon.discount
                                                      .toString(),
                                                  style: AppStyles.appFontBook
                                                      .copyWith(
                                                    color: AppStyles.pinkColor,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  double.parse((currencyController
                                                                  .conversionRate
                                                                  .value *
                                                              widget.coupon
                                                                  .discount)
                                                          .toString())
                                                      .toStringAsFixed(2),
                                                  style: AppStyles.appFontBook
                                                      .copyWith(
                                                    color: AppStyles.pinkColor,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 4.0, left: 2),
                                        child: Text(
                                          'OFF'.tr,
                                          style: AppStyles.appFontBook.copyWith(
                                            color: AppStyles.pinkColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 20,
                              bottom: 15,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          PinkButtonWidget(
                                            height: 32,
                                            btnOnTap: () {
                                              FlutterClipboard.copy(
                                                      '${widget.coupon.couponCode}')
                                                  .then((value) {
                                                print(
                                                    'copied: ${widget.coupon.couponCode}');
                                                SnackBars().snackBarSuccess(
                                                    'Coupon Code copied: ${widget.coupon.couponCode}');
                                              });
                                            },
                                            btnText: 'Copy Code'.tr,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Validity'.tr +
                                                ': ${CustomDate().formattedDate(widget.coupon.startDate)} - ${CustomDate().formattedDate(widget.coupon.endDate)}',
                                            style:
                                                AppStyles.appFontBook.copyWith(
                                              color: AppStyles.blackColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.coupon.discountType == 0
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                widget.coupon.minimumShopping != null
                                    ? Text(
                                        'Spend'.tr +
                                            ' ${double.parse((currencyController.conversionRate.value * widget.coupon.minimumShopping).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value} ' +
                                            'get'.tr +
                                            ' ${double.parse((currencyController.conversionRate.value * widget.coupon.maximumDiscount).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value} off',
                                        style: AppStyles.appFontBook.copyWith(
                                          color: AppStyles.pinkColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                          : SizedBox(
                              height: 5,
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'You might like'.tr,
                textAlign: TextAlign.center,
                style: AppStyles.appFontBold.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          LoadingMoreSliverList<ProductModel>(
            SliverListConfig<ProductModel>(
              padding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                bottom: 50,
              ),
              indicatorBuilder: BuildIndicatorBuilder(
                source: source,
                isSliver: true,
                name: 'Recommended Products'.tr,
              ).buildIndicator,
              extendedListDelegate:
                  SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 0,
              ),
              itemBuilder: (BuildContext c, ProductModel prod, int index) {
                return GridViewProductWidget(
                  productModel: prod,
                );
              },
              sourceList: source,
            ),
            key: const Key('homePageLoadMoreKey'),
          ),
        ],
      ),
    );
  }
}
