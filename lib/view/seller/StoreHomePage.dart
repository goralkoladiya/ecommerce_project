import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/home_controller.dart';
import 'package:amazy_app/controller/seller_profile_controller.dart';
import 'package:amazy_app/model/Brand/BrandData.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/model/Seller/SellerProfileModel.dart';

import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/RecommendedProductLoadMore.dart';
import 'package:amazy_app/view/products/brand/ProductsByBrands.dart';
import 'package:amazy_app/view/products/category/ProductsByCategory.dart';
import 'package:amazy_app/widgets/BuildIndicatorBuilder.dart';
import 'package:amazy_app/widgets/single_product_widgets/GridViewProductWidget.dart';
import 'package:amazy_app/widgets/HomeTitlesWidget.dart';
import 'package:amazy_app/widgets/single_product_widgets/HorizontalProductWidget.dart';
import 'package:amazy_app/widgets/fa_icon_maker/fa_custom_icon.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:loading_more_list/loading_more_list.dart';

class StoreHomePage extends StatefulWidget {
  final int sellerId;
  StoreHomePage(this.sellerId);
  @override
  _StoreHomePageState createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  SellerProfileController controller;

  final HomeController homeController = Get.put(HomeController());

  RecommendedProductsLoadMore source;

  @override
  void initState() {
    controller = Get.put(SellerProfileController(widget.sellerId));
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
    return SingleChildScrollView(
      // const Key('Tab1'),
      key: Key('Tab1'),
      child: LoadingMoreCustomScrollView(
        // rebuildCustomScrollView: true,
        showGlowLeading: false,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                SizedBox(
                  height: 15,
                ),
                HomeTitlesWidget(
                  title: 'New Arrival'.tr,
                  btnOnTap: () {
                    controller.tabController.animateTo(1);
                  },
                  showDeal: false,
                ),
                Container(
                  height: 220,
                  child: ListView.separated(
                      itemCount: controller.recentProductsList.take(5).length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 10,
                        );
                      },
                      itemBuilder: (context, topPickIndex) {
                        ProductModel prod =
                            controller.recentProductsList[topPickIndex];
                        return HorizontalProductWidget(
                          productModel: prod,
                        );
                      }),
                ),
                controller.seller.value.categoryList.length > 0
                    ? HomeTitlesWidget(
                        title: 'Categories'.tr,
                        btnOnTap: () {
                          controller.tabController.animateTo(1);
                        },
                        showDeal: false,
                      )
                    : SizedBox.shrink(),
                controller.seller.value.categoryList.length > 0
                    ? SizedBox(
                        height: 10,
                      )
                    : SizedBox.shrink(),
                controller.seller.value.categoryList.length > 0
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          color: AppStyles.lightBlueColorAlt,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              height: 100,
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 10,
                                  );
                                },
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount:
                                    controller.seller.value.categoryList.length,
                                itemBuilder: (context, index) {
                                  CategoryList category = controller
                                      .seller.value.categoryList[index];
                                  return InkWell(
                                    onTap: () {
                                      // Get.toNamed('/productsByCategory');
                                      Get.to(() => ProductsByCategory(
                                            categoryId: category.id,
                                          ));
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      width: 80,
                                      child: Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            category.icon != null
                                                ? Container(
                                                    height: 50,
                                                    child: Icon(
                                                      FaCustomIcon
                                                          .getFontAwesomeIcon(
                                                              category.icon),
                                                      size: 30,
                                                    ),
                                                  )
                                                : Container(
                                                    height: 50,
                                                    child: Icon(
                                                      Icons.list_alt_outlined,
                                                      size: 30,
                                                    ),
                                                  ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 5.0,
                                              ),
                                              child: Text(
                                                category.name,
                                                textAlign: TextAlign.center,
                                                style: AppStyles.kFontBlack13w5,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 10,
                ),
                HomeTitlesWidget(
                  title: 'Brands'.tr,
                  btnOnTap: () {
                    controller.tabController.animateTo(1);
                  },
                  showDeal: false,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    color: AppStyles.lightBlueColorAlt,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: 100,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: 10,
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: controller.seller.value.brandList.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            BrandData brand =
                                controller.seller.value.brandList[index];
                            return InkWell(
                              onTap: () {
                                Get.to(() => ProductsByBrands(
                                      brandId: brand.id,
                                    ));
                              },
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                clipBehavior: Clip.antiAlias,
                                child: Container(
                                  color: Colors.white,
                                  width: 80,
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: brand.logo != null
                                                ? Container(
                                                    child: FancyShimmerImage(
                                                      imageUrl:
                                                          AppConfig.assetPath +
                                                                  '/' +
                                                                  brand.logo ??
                                                              '',
                                                      boxFit: BoxFit.contain,
                                                      errorWidget:
                                                          FancyShimmerImage(
                                                        imageUrl:
                                                            "${AppConfig.assetPath}/backend/img/default.png",
                                                        boxFit: BoxFit.contain,
                                                        errorWidget:
                                                            FancyShimmerImage(
                                                          imageUrl:
                                                              "${AppConfig.assetPath}/backend/img/default.png",
                                                          boxFit:
                                                              BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    child:
                                                        Icon(Icons.list_alt)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: brand.name.length < 10
                                                  ? 1.0
                                                  : 0.0,
                                              horizontal: 4),
                                          child: Text(
                                            brand.name,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppStyles.kFontBlack12w4,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
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
                style: AppStyles.appFontMedium.copyWith(
                  color: AppStyles.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          LoadingMoreSliverList<ProductModel>(
            SliverListConfig<ProductModel>(
              padding: EdgeInsets.all(5.0),
              indicatorBuilder: BuildIndicatorBuilder(
                source: source,
                isSliver: true,
                name: 'Recommended Products'.tr,
              ).buildIndicator,
              extendedListDelegate:
                  SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
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
