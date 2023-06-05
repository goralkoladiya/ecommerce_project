import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/home_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/HomePage/HomePageModel.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/RecommendedProductLoadMore.dart';
import 'package:amazy_app/view/products/brand/AllBrandsPage.dart';
import 'package:amazy_app/view/products/brand/ProductsByBrands.dart';
import 'package:amazy_app/view/products/marketing/AllTopPickProducts.dart';
import 'package:amazy_app/widgets/BuildIndicatorBuilder.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/HomeTitlesWidget.dart';
import 'package:amazy_app/widgets/fa_icon_maker/fa_custom_icon.dart';
import 'package:amazy_app/widgets/flutter_swiper/flutter_swiper.dart';
import 'package:amazy_app/widgets/single_product_widgets/GridViewProductWidget.dart';
import 'package:amazy_app/widgets/single_product_widgets/HorizontalProductWidget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:loading_skeleton/loading_skeleton.dart';
import 'package:supercharged/supercharged.dart';

import 'products/category/ProductsByCategory.dart';
import 'products/marketing/FlashDeal/FlashDealView.dart';
import 'products/marketing/NewUserZone/NewUserZonePage.dart';
import 'products/product/product_details.dart';
import 'products/tags/ProductsByTags.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController scrollController = ScrollController();

  final HomeController _homeController = Get.find<HomeController>();

  final GeneralSettingsController _settingsController =
      Get.find<GeneralSettingsController>();

  bool isScrolling = false;

  RecommendedProductsLoadMore source;

  Future<void> refresh() async {
    await _homeController.getHomePage();
    // source.refresh(true);
  }

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

  LinearGradient selectColor(int position) {
    LinearGradient c;
    if (position % 8 == 0)
      c = LinearGradient(
        colors: [Color(0xfffd4949), Color(0xffd20000)],
        stops: [0, 1],
        begin: Alignment(-0.71, -0.71),
        end: Alignment(0.71, 0.71),
      );
    if (position % 8 == 1)
      c = LinearGradient(
        colors: [Color(0xff786ef9), Color(0xffc76cdc)],
        stops: [0, 1],
        begin: Alignment(0.71, 0.71),
        end: Alignment(-0.71, -0.71),
      );
    if (position % 8 == 2)
      c = LinearGradient(
        colors: [Color(0xff2da6f7), Color(0xff9fd8ff)],
        stops: [0, 1],
        begin: Alignment(0.72, 0.69),
        end: Alignment(-0.72, -0.69),
      );
    if (position % 8 == 3)
      c = LinearGradient(
        colors: [Color(0xff3cd47f), Color(0xff94ffc4)],
        stops: [0, 1],
        begin: Alignment(0.71, 0.71),
        end: Alignment(-0.71, -0.71),
      );
    if (position % 8 == 4)
      c = LinearGradient(
        colors: [Color(0xfffd4949), Color(0xffd20000)],
        stops: [0, 1],
        begin: Alignment(-0.71, -0.71),
        end: Alignment(0.71, 0.71),
      );
    if (position % 8 == 5)
      c = LinearGradient(
        colors: [Color(0xff786ef9), Color(0xffc76cdc)],
        stops: [0, 1],
        begin: Alignment(0.71, 0.71),
        end: Alignment(-0.71, -0.71),
      );
    if (position % 8 == 6)
      c = LinearGradient(
        colors: [Color(0xff2da6f7), Color(0xff9fd8ff)],
        stops: [0, 1],
        begin: Alignment(0.72, 0.69),
        end: Alignment(-0.72, -0.69),
      );
    if (position % 8 == 7)
      c = LinearGradient(
        colors: [Color(0xff3cd47f), Color(0xff94ffc4)],
        stops: [0, 1],
        begin: Alignment(0.71, 0.71),
        end: Alignment(-0.71, -0.71),
      );
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: isScrolling
              ? Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: FloatingActionButton.small(
                    backgroundColor: AppStyles.pinkColor,
                    onPressed: () {
                      scrollController.animateTo(0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    child: Icon(
                      Icons.arrow_upward,
                      size: 20,
                    ),
                  ),
                )
              : Container(),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: RefreshIndicator(
            onRefresh: refresh,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                FocusScope.of(context).unfocus();
                if (scrollController.offset > 0) {
                  setState(() {
                    isScrolling = true;
                  });
                } else {
                  setState(() {
                    isScrolling = false;
                  });
                }
                return false;
              },
              child: LoadingMoreCustomScrollView(
                controller: scrollController,
                slivers: [
                  CustomSliverAppBarWidget(false, false),

                  SliverToBoxAdapter(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ///** SLIDER */
                        Obx(() {
                          if (_homeController.isHomePageLoading.value) {
                            return Container(
                              padding: EdgeInsets.all(1),
                              child: LoadingSkeleton(
                                height: 215,
                                width: Get.width,
                                colors: [
                                  Colors.black.withOpacity(0.1),
                                  Colors.black.withOpacity(0.2),
                                ],
                              ),
                            );
                          } else {
                            if (_homeController.homePageModel.value.sliders.isNotEmpty)
                              return Container(
                                height: 215,
                                child: Swiper(
                                  itemCount: _homeController
                                      .homePageModel.value.sliders.length,
                                  autoplay: true,
                                  autoplayDelay: 5000,
                                  itemBuilder:
                                      (BuildContext context, int sliderIndex) {
                                    HomePageSlider slider = _homeController
                                        .homePageModel
                                        .value
                                        .sliders[sliderIndex];
                                    return FancyShimmerImage(
                                      imageUrl: AppConfig.assetPath +
                                          '/' +
                                          slider.sliderImage,
                                      boxFit: BoxFit.cover,
                                      width: Get.width,
                                      errorWidget: FancyShimmerImage(
                                        imageUrl:
                                            "${AppConfig.assetPath}/backend/img/default.png",
                                        boxFit: BoxFit.contain,
                                        errorWidget: FancyShimmerImage(
                                          imageUrl:
                                              "${AppConfig.assetPath}/backend/img/default.png",
                                          boxFit: BoxFit.contain,
                                        ),
                                      ),
                                    );
                                  },
                                  onTap: (sliderIndex) {
                                    HomePageSlider slider = _homeController
                                        .homePageModel
                                        .value
                                        .sliders[sliderIndex];
                                    if (slider.dataType ==
                                        SliderDataType.PRODUCT) {
                                      Get.to(() => ProductDetails(
                                            productID: slider.dataId,
                                          ));
                                    } else if (slider.dataType ==
                                        SliderDataType.CATEGORY) {
                                      Get.to(() => ProductsByCategory(
                                            categoryId: slider.dataId,
                                          ));
                                    } else if (slider.dataType ==
                                        SliderDataType.BRAND) {
                                      Get.to(() => ProductsByBrands(
                                            brandId: slider.dataId,
                                          ));
                                    } else if (slider.dataType ==
                                        SliderDataType.TAG) {
                                      Get.to(() => ProductsByTags(
                                            tagName: slider.tag.name,
                                            tagId: slider.tag.id,
                                          ));
                                    }
                                  },
                                  pagination: SwiperPagination(
                                      margin: EdgeInsets.all(5.0),
                                      builder: SwiperCustomPagination(builder:
                                          (BuildContext context,
                                              SwiperPluginConfig config) {
                                        return Align(
                                          alignment: Alignment.bottomCenter,
                                          child: RectSwiperPaginationBuilder(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            activeColor: Colors.white,
                                            size: Size(5.0, 5.0),
                                            activeSize: Size(20.0, 5.0),
                                          ).build(context, config),
                                        );
                                      })),
                                ),
                              );
                            else
                              return SizedBox.shrink();
                          }
                        }),

                        /// ** FEATURES*/

                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, left: 15, right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/Shipping.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Free Shipping".tr,
                                        style: AppStyles.appFontBold.copyWith(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        "Free All Shipping".tr,
                                        style: AppStyles.appFontBook.copyWith(
                                          fontSize: 9,
                                          color: Color(0xff5C7185),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/help.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 5
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Help Center".tr,
                                        style: AppStyles.appFontBold.copyWith(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        "24/7 Support".tr,
                                        style: AppStyles.appFontBook.copyWith(
                                          fontSize: 9,
                                          color: Color(0xff5C7185),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 20
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/money.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Money Back".tr,
                                        style: AppStyles.appFontBold.copyWith(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        "Back in 30 days".tr,
                                        style: AppStyles.appFontBook.copyWith(
                                          fontSize: 9,
                                          color: Color(0xff5C7185),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),

                        ///** CATEGORY */

                        Container(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 30.0),
                          child: Obx(() {
                            if (!_homeController.isHomePageLoading.value &&
                                _homeController.homePageModel.value
                                        .topCategories.length >
                                    0) {
                              return Container(
                                height: 100,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      width: 20,
                                    );
                                  },
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: _homeController
                                      .homePageModel.value.topCategories.length,
                                  itemBuilder: (context, index) {
                                    CategoryBrand category = _homeController
                                        .homePageModel
                                        .value
                                        .topCategories[index];

                                    return Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      width: 50,
                                      child: ListView(
                                        padding: EdgeInsets.zero,
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            child: InkWell(
                                              customBorder: CircleBorder(),
                                              onTap: () async {
                                                Get.to(() => ProductsByCategory(
                                                      categoryId: category.id,
                                                    ));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: selectColor(index),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: category.icon != null
                                                    ? Icon(
                                                        FaCustomIcon
                                                            .getFontAwesomeIcon(
                                                                category.icon),
                                                        color: Colors.white,
                                                        size: 20,
                                                      )
                                                    : Icon(
                                                        Icons.list_alt_outlined,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            category.name,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: AppStyles.appFontMedium
                                                .copyWith(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Container(
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 10.0,
                                    mainAxisExtent: 80,
                                  ),
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          child: LoadingSkeleton(
                                            width: 55,
                                            height: 55,
                                            child: SizedBox(),
                                            colors: [
                                              Colors.black.withOpacity(0.1),
                                              Colors.black.withOpacity(0.2),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            }
                          }),
                        ),

                        /// ** FLASH SALE
                        Container(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 0.0),
                          child: Obx(() {
                            if (_homeController.isHomePageLoading.value) {
                              return ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  Container(
                                    height: 240,
                                    child: ListView.separated(
                                        itemCount: 4,
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        scrollDirection: Axis.horizontal,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            width: 5,
                                          );
                                        },
                                        itemBuilder: (context, flashIndex) {
                                          return Container(
                                            width: 150,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x1a000000),
                                                  offset: Offset(0, 3),
                                                  blurRadius: 6,
                                                  spreadRadius: 0,
                                                )
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: LoadingSkeleton(
                                                height: 210,
                                                width: 150,
                                                child: SizedBox(),
                                                colors: [
                                                  Colors.white.withOpacity(0.1),
                                                  Colors.black.withOpacity(0.1),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              );
                            } else {
                              if (_homeController.hasDeal.value) {
                                return ListView(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    HomeTitlesWidget(
                                      title: 'Flash Sale',
                                      btnOnTap: () {
                                        Get.to(() => FlashDealView());
                                      },
                                      endTime: _homeController.endTime.value,
                                      showDeal: true,
                                    ),
                                    Container(
                                      height: 240,
                                      child: ListView.separated(
                                          itemCount: _homeController
                                              .homePageModel
                                              .value
                                              .flashDeal
                                              .allProducts
                                              .length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                              width: 5,
                                            );
                                          },
                                          itemBuilder: (context, flashIndex) {
                                            FlashDealAllProduct flashDeal =
                                                _homeController
                                                    .homePageModel
                                                    .value
                                                    .flashDeal
                                                    .allProducts[flashIndex];
                                            return HorizontalProductWidget(
                                              productModel: flashDeal.product,
                                            );
                                          }),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }
                          }),
                        ),

                        /// ** NEW USER ZONE
                        Container(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 10.0),
                          child: Obx(() {
                            if (_homeController.isHomePageLoading.value) {
                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    clipBehavior: Clip.antiAlias,
                                    child: Container(
                                      height: 80,
                                      alignment: Alignment.center,
                                      color: AppStyles.pinkColor,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Container(
                                            width: 50,
                                            height: 50,
                                            child: Image.asset(
                                              'assets/images/icon_gift_alt.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'New Users Zone!'.tr,
                                                style: AppStyles.kFontWhite14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                              Text(
                                                '',
                                                maxLines: 1,
                                                style: AppStyles.kFontWhite14w5
                                                    .copyWith(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Container(
                                            height: 35,
                                            width: 35,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 14,
                                              color: AppStyles.pinkColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    child: Container(
                                      height: 150,
                                      padding: EdgeInsets.all(4),
                                      color: AppStyles.lightBlueColorAlt,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children:
                                                  List.generate(2, (index) {
                                                return Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 4,
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            LoadingSkeleton(
                                                              height: 70,
                                                              width: 80,
                                                              colors: [
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.1),
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.2),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            LoadingSkeleton(
                                                              height: 20,
                                                              width: 80,
                                                              colors: [
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.1),
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.2),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            child: Container(
                                              width: Get.width * 0.35,
                                              decoration: BoxDecoration(
                                                color: AppStyles.pinkColor,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Discount'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: AppStyles
                                                        .kFontWhite14w5
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      // Get.to(() =>
                                                      //     NewUserZonePage());
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 30,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffFFD600),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          25))),
                                                      child: Text(
                                                        'Shop Now'.tr,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppStyles
                                                            .appFontLight
                                                            .copyWith(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
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
                            } else {
                              if (_homeController
                                      .homePageModel.value.newUserZone !=
                                  null) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => NewUserZonePage());
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        clipBehavior: Clip.antiAlias,
                                        child: Container(
                                          height: 80,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            gradient: AppStyles.gradient,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Container(
                                                width: 50,
                                                height: 50,
                                                child: Image.asset(
                                                  'assets/images/icon_gift_alt.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'New Users Zone!'.tr,
                                                    style: AppStyles
                                                        .kFontWhite14w5
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${_homeController.homePageModel.value.newUserZone.title ?? ""}',
                                                    maxLines: 1,
                                                    style: AppStyles
                                                        .kFontWhite14w5
                                                        .copyWith(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Container(
                                                height: 35,
                                                width: 35,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 14,
                                                  color: AppStyles.pinkColor,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10
                                    ),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: Container(
                                        height: 150,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 2),
                                        color: AppStyles.lightBlueColorAlt,
                                        child: Row(
                                          children: [
                                            if (_homeController
                                                .homePageModel
                                                .value
                                                .newUserZone
                                                .allProducts
                                                .isNotEmpty)
                                              SizedBox(),
                                            if (_homeController
                                                .homePageModel
                                                .value
                                                .newUserZone
                                                .allProducts
                                                .isNotEmpty)
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  children: List.generate(
                                                      _homeController
                                                          .homePageModel
                                                          .value
                                                          .newUserZone
                                                          .allProducts
                                                          .length, (index) {
                                                    return Expanded(
                                                      child: GestureDetector(
                                                        behavior:
                                                            HitTestBehavior
                                                                .translucent,
                                                        onTap: () async {
                                                          Get.to(() => ProductDetails(
                                                              productID: _homeController
                                                                  .homePageModel
                                                                  .value
                                                                  .newUserZone
                                                                  .allProducts[
                                                                      index]
                                                                  .product
                                                                  .id));
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 4,
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          FancyShimmerImage(
                                                                        imageUrl:
                                                                            '${AppConfig.assetPath}/${_homeController.homePageModel.value.newUserZone.allProducts[index].product.product.thumbnailImageSource}',
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        errorWidget:
                                                                            FancyShimmerImage(
                                                                          imageUrl:
                                                                              "${AppConfig.assetPath}/backend/img/default.png",
                                                                          boxFit:
                                                                              BoxFit.contain,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              4.0),
                                                                      child:
                                                                          Wrap(
                                                                        crossAxisAlignment:
                                                                            WrapCrossAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "${_settingsController.calculatePrice(_homeController.homePageModel.value.newUserZone.allProducts[index].product)}+${ _settingsController.appCurrency.value}",
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                AppStyles.kFontPink15w5.copyWith(fontSize: 12),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                3,
                                                                          ),
                                                                          Text(
                                                                            _settingsController.calculateMainPrice(_homeController.homePageModel.value.newUserZone.allProducts[index].product),
                                                                            style:
                                                                                AppStyles.kFontGrey12w5.copyWith(
                                                                              decoration: TextDecoration.lineThrough,
                                                                              fontSize: 12,
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
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                            SizedBox(
                                              width: 4
                                            ),
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  // Get.to(() => NewUserZonePage());
                                                },
                                                child: Container(
                                                  width: Get.width * 0.35,
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        AppStyles.gradient,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${_homeController.homePageModel.value.newUserZone.coupon.discount}% ' +
                                                            'OFF'.tr,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppStyles
                                                            .kFontWhite14w5
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${_homeController.homePageModel.value.newUserZone.coupon.title}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppStyles
                                                            .appFontLight
                                                            .copyWith(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          // Get.to(() =>
                                                          //     NewUserZonePage());
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 30,
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xffFFD600),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          25))),
                                                          child: Text(
                                                            'Shop Now'.tr,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: AppStyles
                                                                .appFontLight
                                                                .copyWith(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4
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
                              } else {
                                return SizedBox.shrink();
                              }
                            }
                          }),
                        ),

                        //** BRANDS

                        Container(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 10.0),
                          child: Obx(() {
                            if (_homeController.isHomePageLoading.value) {
                              return ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  HomeTitlesWidget(
                                    title: 'Brands'.tr,
                                    btnOnTap: () {
                                      // Get.to(() => AllBrandsPage());
                                    },
                                    showDeal: false,
                                  ),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: Container(
                                      color: AppStyles.lightBlueColorAlt,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          child: GridView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              mainAxisSpacing: 10.0,
                                              crossAxisSpacing: 10.0,
                                              mainAxisExtent: 90,
                                            ),
                                            itemCount: 8,
                                            itemBuilder: (context, index) {
                                              return ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                child: LoadingSkeleton(
                                                  width: 50,
                                                  height: 40,
                                                  colors: [
                                                    Colors.black
                                                        .withOpacity(0.1),
                                                    Colors.black
                                                        .withOpacity(0.2),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                children: [
                                  HomeTitlesWidget(
                                    title: 'Brands'.tr,
                                    btnOnTap: () {
                                      Get.to(() => AllBrandsPage());
                                    },
                                    showDeal: false,
                                  ),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: Container(
                                      color: AppStyles.lightBlueColorAlt,
                                      child: Container(
                                        height: _homeController
                                                    .chunkedBrands.length >
                                                4
                                            ? 230
                                            : 130,
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          child: Swiper.children(
                                            children: _homeController
                                                .chunkedBrands
                                                .chunked(8)
                                                .map((e) {
                                              return GridView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4,
                                                  mainAxisSpacing: 10.0,
                                                  crossAxisSpacing: 10.0,
                                                  mainAxisExtent: 90,
                                                ),
                                                itemBuilder: (context, index) {
                                                  CategoryBrand brand =
                                                      e[index];
                                                  return InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          ProductsByBrands(
                                                            brandId: brand.id,
                                                          ));
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: Column(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: brand.logo !=
                                                                        null
                                                                    ? Container(
                                                                        child:
                                                                            FancyShimmerImage(
                                                                          imageUrl:
                                                                              AppConfig.assetPath + '/' + brand.logo ?? '',
                                                                          boxFit:
                                                                              BoxFit.contain,
                                                                          errorWidget:
                                                                              FancyShimmerImage(
                                                                            imageUrl:
                                                                                "${AppConfig.assetPath}/backend/img/default.png",
                                                                            boxFit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        child: Icon(
                                                                            Icons.list_alt)),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical:
                                                                      brand.name.length <
                                                                              10
                                                                          ? 1.0
                                                                          : 0.0,
                                                                  horizontal:
                                                                      4),
                                                              child: Text(
                                                                brand.name,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: AppStyles
                                                                    .appFontLight
                                                                    .copyWith(
                                                                  fontSize: 12,
                                                                  color: AppStyles
                                                                      .blackColor,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                itemCount: e.length,
                                              );
                                            }).toList(),
                                            loop: false,
                                            // pagination: FractionPaginationBuilder(
                                            //   fontSize: 1,
                                            //   activeColor: Colors.transparent,
                                            // ),
                                            pagination: SwiperPagination(
                                                margin: EdgeInsets.zero,
                                                builder: SwiperCustomPagination(
                                                    builder:
                                                        (BuildContext context,
                                                            SwiperPluginConfig
                                                                config) {
                                                  return Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child:
                                                        RectSwiperPaginationBuilder(
                                                      color: Colors.white
                                                          .withOpacity(0.5),
                                                      activeColor: Colors.pink,
                                                      size: Size(5.0, 5.0),
                                                      activeSize:
                                                          Size(20.0, 5.0),
                                                    ).build(context, config),
                                                  );
                                                },),),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
                        ),

                        ///** TOP PICKS
                        Container(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 12.0, top: 10.0),
                          child: Obx(() {
                            if (_homeController.isHomePageLoading.value) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    child: Container(
                                      child: LoadingSkeleton(
                                        height: 150,
                                        width: Get.width,
                                        colors: [
                                          Colors.black.withOpacity(0.1),
                                          Colors.black.withOpacity(0.2),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  HomeTitlesWidget(
                                    title: 'Top Picks'.tr,
                                    btnOnTap: () {
                                      Get.to(() => AllTopPickProducts());
                                    },
                                    showDeal: false,
                                  ),
                                  _homeController
                                      .homePageModel.value.topPicks.length!=0?Container(
                                    height: 220,
                                    child: ListView.separated(
                                        itemCount: _homeController
                                            .homePageModel.value.topPicks
                                            .take(8)
                                            .length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        physics: BouncingScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            width: 5,
                                          );
                                        },
                                        itemBuilder: (context, topPickIndex) {
                                          ProductModel prod = _homeController
                                              .homePageModel
                                              .value
                                              .topPicks[topPickIndex];

                                          return HorizontalProductWidget(
                                            productModel: prod,
                                          );
                                        }),
                                  ):SizedBox(),
                                ],
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),

                  ///** RECOMMENDED

                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                      child: Text(
                        'You might like'.tr,
                        textAlign: TextAlign.left,
                        style: AppStyles.appFontBold.copyWith(
                          fontSize: 20,
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
                      itemBuilder:
                          (BuildContext c, ProductModel prod, int index) {
                        return GridViewProductWidget(
                          productModel: prod,
                        );
                      },
                      sourceList: source,
                    ),
                    key: const Key('homePageLoadMoreKey'),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
