import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/controller/review_controller.dart';
import 'package:amazy_app/model/Product/ProductType.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/account/reviews/WriteReview2.dart';
import 'package:amazy_app/view/products/product/product_details.dart';
import 'package:amazy_app/widgets/AppBarWidget.dart';
import 'package:amazy_app/widgets/CustomDate.dart';
import 'package:amazy_app/widgets/StarCounterWidget.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class MyReviews extends StatefulWidget {
  final int tabIndex;

  MyReviews({this.tabIndex});

  @override
  _MyReviewsState createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  int index = 0;

  List<Tab> tabs = <Tab>[
    Tab(
      child: Text(
        'Waiting for Review'.tr,
        style: AppStyles.appFontMedium.copyWith(fontSize: 12),
      ),
    ),
    Tab(
      child: Text(
        'Review History'.tr,
        style: AppStyles.appFontMedium.copyWith(fontSize: 12),
      ),
    ),
  ];

  @override
  void initState() {
    index = widget.tabIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: widget.tabIndex,
      child: Builder(builder: (context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {}
        });
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBarWidget(
            title: "My Review",
            bottom: TabBar(
              labelColor: AppStyles.blackColor,
              labelPadding: EdgeInsets.zero,
              tabs: tabs,
              indicatorColor: AppStyles.pinkColor,
              unselectedLabelColor: AppStyles.greyColorDark,
              automaticIndicatorColorAdjustment: true,
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
          body: TabBarView(
            children: [
              getWaitingForReview(),
              getMyReviewList(),
            ],
          ),
        );
      }),
    );
  }

  Widget getWaitingForReview() {
    final ReviewController reviewController = Get.put(ReviewController());

    reviewController.waitingForReviews();

    return Obx(() {
      if (reviewController.isWaitingReviewLoading.value) {
        return Center(
          child: CustomLoadingWidget(),
        );
      } else {
        if (reviewController.waitingReview.value.packages == null ||
            reviewController.waitingReview.value.packages.length == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.check,
                color: Colors.green,
                size: 25,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'All Order reviewed. Thank you!'.tr,
                textAlign: TextAlign.center,
                style: AppStyles.kFontPink15w5.copyWith(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }
      }
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: reviewController.waitingReview.value.packages.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => WriteReview2(
                            package: reviewController
                                .waitingReview.value.packages[index],
                            sellerID: reviewController
                                .waitingReview.value.packages[index].sellerId,
                            orderID: reviewController
                                .waitingReview.value.packages[index].orderId,
                            packageID: reviewController
                                .waitingReview.value.packages[index].id,
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
                                Image.asset(
                                  'assets/images/icon_delivery-parcel.png',
                                  width: 17,
                                  height: 17,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  reviewController.waitingReview.value
                                      .packages[index].packageCode,
                                  style: AppStyles.appFontMedium,
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 26.0, top: 5),
                              child: Text(
                                'Placed on'.tr +
                                    ': ' +
                                    CustomDate()
                                        .formattedDateTime(reviewController
                                            .waitingReview
                                            .value
                                            .packages[index]
                                            .createdAt
                                            .toLocal())
                                        .toString(),
                                style: AppStyles.appFontBook,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                          children: [
                            Text(
                              'Write Review'.tr,
                              style: AppStyles.appFontBook.copyWith(
                                color: AppStyles.pinkColor,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: AppStyles.pinkColor,
                            ),
                          ],
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
                      padding: EdgeInsets.only(left: 24.0),
                      itemCount: reviewController
                          .waitingReview.value.packages[index].products.length,
                      itemBuilder: (context, productsIndex) {
                        if (reviewController.waitingReview.value.packages[index]
                                .products[productsIndex].type ==
                            ProductType.GIFT_CARD) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  child: Container(
                                      height: 60,
                                      width: 90,
                                      padding: EdgeInsets.all(5),
                                      color: Color(0xffF1F1F1),
                                      child: FancyShimmerImage(
                                        imageUrl: AppConfig.assetPath +
                                            '/' +
                                            reviewController
                                                .waitingReview
                                                .value
                                                .packages[index]
                                                .products[productsIndex]
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
                                          reviewController
                                              .waitingReview
                                              .value
                                              .packages[index]
                                              .products[productsIndex]
                                              .giftCard
                                              .name,
                                          style: AppStyles.appFontMedium
                                              .copyWith(fontSize: 12),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${(reviewController.waitingReview.value.packages[index].products[productsIndex].price * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                      style: AppStyles
                                                          .appFontBook
                                                          .copyWith(
                                                        color:
                                                            AppStyles.pinkColor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '(${reviewController.waitingReview.value.packages[index].products[productsIndex].qty}x)',
                                                      style: AppStyles
                                                          .appFontMedium
                                                          .copyWith(
                                                              fontSize: 12),
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
                        return Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                child: Container(
                                    height: 60,
                                    width: 90,
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xffF1F1F1),
                                    child: FancyShimmerImage(
                                      imageUrl: AppConfig.assetPath +
                                          '/' +
                                          reviewController
                                              .waitingReview
                                              .value
                                              .packages[index]
                                              .products[productsIndex]
                                              .sellerProductSku
                                              .product
                                              .product
                                              .thumbnailImageSource,
                                      boxFit: BoxFit.cover,
                                    )),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reviewController
                                            .waitingReview
                                            .value
                                            .packages[index]
                                            .products[productsIndex]
                                            .sellerProductSku
                                            .product
                                            .productName,
                                        style: AppStyles.appFontMedium
                                            .copyWith(fontSize: 12),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: reviewController
                                            .waitingReview
                                            .value
                                            .packages[index]
                                            .products[productsIndex]
                                            .sellerProductSku
                                            .productVariations
                                            .length,
                                        itemBuilder: (context, variantIndex) {
                                          if (reviewController
                                                  .waitingReview
                                                  .value
                                                  .packages[index]
                                                  .products[productsIndex]
                                                  .sellerProductSku
                                                  .productVariations[
                                                      variantIndex]
                                                  .attribute
                                                  .name ==
                                              'Color') {
                                            return Text(
                                              'Color: ${reviewController.waitingReview.value.packages[index].products[productsIndex].sellerProductSku.productVariations[variantIndex].attributeValue.color.name}',
                                              style: AppStyles.kFontBlack12w4,
                                            );
                                          } else {
                                            return Text(
                                              '${reviewController.waitingReview.value.packages[index].products[productsIndex].sellerProductSku.productVariations[variantIndex].attribute.name}: ${reviewController.waitingReview.value.packages[index].products[productsIndex].sellerProductSku.productVariations[variantIndex].attributeValue.value}',
                                              style: AppStyles.kFontBlack12w4,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                    '${(reviewController.waitingReview.value.packages[index].products[productsIndex].price * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                    style: AppStyles.appFontBook
                                                        .copyWith(
                                                      color:
                                                          AppStyles.pinkColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    '(${reviewController.waitingReview.value.packages[index].products[productsIndex].qty}x)',
                                                    style: AppStyles
                                                        .appFontMedium
                                                        .copyWith(fontSize: 12),
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
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget getMyReviewList() {
    final ReviewController reviewController = Get.put(ReviewController());

    reviewController.myReviews();

    return Obx(() {
      if (reviewController.isMyReviewLoading.value) {
        return Center(
          child: CustomLoadingWidget(),
        );
      } else {
        if (reviewController.myReview.value.reviews == null ||
            reviewController.myReview.value.reviews.length == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.check,
                color: Colors.green,
                size: 25,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'No reviews Found'.tr,
                textAlign: TextAlign.center,
                style: AppStyles.kFontPink15w5.copyWith(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }
      }
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemCount: reviewController.myReview.value.reviews.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
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
                                  reviewController.myReview.value.reviews[index]
                                      .packageCode,
                                  style: AppStyles.appFontMedium
                                      .copyWith(fontSize: 12),
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 20.0),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reviewController
                          .myReview.value.reviews[index].reviews.length,
                      itemBuilder: (context, reviewsIndex) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            currencyController.vendorType.value != 'single'
                                ? Text(
                                    'Sold by'.tr +
                                        ' ' +
                                        reviewController
                                            .myReview
                                            .value
                                            .reviews[index]
                                            .reviews[reviewsIndex]
                                            .seller
                                            .firstName,
                                    style: AppStyles.appFontMedium
                                        .copyWith(fontSize: 12),
                                  )
                                : SizedBox.shrink(),
                            GestureDetector(
                              onTap: () {
                                if (reviewController
                                        .myReview
                                        .value
                                        .reviews[index]
                                        .reviews[reviewsIndex]
                                        .type ==
                                    ProductType.PRODUCT) {
                                  Get.to(() => ProductDetails(
                                      productID: reviewController
                                          .myReview
                                          .value
                                          .reviews[index]
                                          .reviews[reviewsIndex]
                                          .product
                                          .id));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: Container(
                                        height: 60,
                                        width: 90,
                                        padding: EdgeInsets.all(5),
                                        color: Color(0xffF1F1F1),
                                        child: reviewController
                                                    .myReview
                                                    .value
                                                    .reviews[index]
                                                    .reviews[reviewsIndex]
                                                    .type ==
                                                ProductType.GIFT_CARD
                                            ? FancyShimmerImage(
                                                imageUrl: AppConfig.assetPath +
                                                    '/' +
                                                    reviewController
                                                        .myReview
                                                        .value
                                                        .reviews[index]
                                                        .reviews[reviewsIndex]
                                                        .giftcard
                                                        .thumbnailImage,
                                                boxFit: BoxFit.cover,
                                                errorWidget: FancyShimmerImage(
                                                  imageUrl:
                                                      "${AppConfig.assetPath}/backend/img/default.png",
                                                  boxFit: BoxFit.contain,
                                                ),
                                              )
                                            : FancyShimmerImage(
                                                imageUrl: AppConfig.assetPath +
                                                    '/' +
                                                    reviewController
                                                        .myReview
                                                        .value
                                                        .reviews[index]
                                                        .reviews[reviewsIndex]
                                                        .product
                                                        .product
                                                        .thumbnailImageSource,
                                                boxFit: BoxFit.contain,
                                                errorWidget: FancyShimmerImage(
                                                  imageUrl:
                                                      "${AppConfig.assetPath}/backend/img/default.png",
                                                  boxFit: BoxFit.contain,
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            reviewController
                                                        .myReview
                                                        .value
                                                        .reviews[index]
                                                        .reviews[reviewsIndex]
                                                        .type ==
                                                    ProductType.GIFT_CARD
                                                ? Text(
                                                    reviewController
                                                        .myReview
                                                        .value
                                                        .reviews[index]
                                                        .reviews[reviewsIndex]
                                                        .giftcard
                                                        .name,
                                                    style: AppStyles
                                                        .appFontMedium
                                                        .copyWith(
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                : Text(
                                                    reviewController
                                                        .myReview
                                                        .value
                                                        .reviews[index]
                                                        .reviews[reviewsIndex]
                                                        .product
                                                        .productName,
                                                    style: AppStyles
                                                        .appFontMedium
                                                        .copyWith(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            StarCounterWidget(
                                              value: reviewController
                                                  .myReview
                                                  .value
                                                  .reviews[index]
                                                  .reviews[reviewsIndex]
                                                  .rating
                                                  .toDouble(),
                                              color: AppStyles.pinkColor,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              reviewController
                                                  .myReview
                                                  .value
                                                  .reviews[index]
                                                  .reviews[reviewsIndex]
                                                  .review,
                                              style: AppStyles.appFontMedium
                                                  .copyWith(
                                                fontSize: 10,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            reviewController
                                                        .myReview
                                                        .value
                                                        .reviews[index]
                                                        .reviews[reviewsIndex]
                                                        .images
                                                        .length !=
                                                    0
                                                ? Wrap(
                                                    alignment:
                                                        WrapAlignment.start,
                                                    runSpacing: 10,
                                                    spacing: 10,
                                                    children: List.generate(
                                                        reviewController
                                                            .myReview
                                                            .value
                                                            .reviews[index]
                                                            .reviews[
                                                                reviewsIndex]
                                                            .images
                                                            .length,
                                                        (imgIndex) {
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5)),
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
                                                                reviewController
                                                                    .myReview
                                                                    .value
                                                                    .reviews[
                                                                        index]
                                                                    .reviews[
                                                                        reviewsIndex]
                                                                    .images[
                                                                        imgIndex]
                                                                    .image,
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
                                                      );
                                                    }),
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        );
                      }),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
