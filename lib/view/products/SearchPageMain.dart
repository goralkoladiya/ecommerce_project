import 'dart:async';

import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/search_controller.dart';
import 'package:amazy_app/model/Category/CategoryData.dart';
import 'package:amazy_app/model/LiveSearchModel.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/RecommendedProductLoadMore.dart';
import 'package:amazy_app/view/products/category/ProductsByCategory.dart';
import 'package:amazy_app/view/products/product/product_details.dart';
import 'package:amazy_app/widgets/BuildIndicatorBuilder.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:amazy_app/widgets/single_product_widgets/GridViewProductWidget.dart';
import 'package:amazy_app/widgets/cart_icon_widget.dart';
import 'package:amazy_app/widgets/custom_input_border.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'dart:math' as math;

import 'tags/ProductsByTags.dart';

class SearchPageMain extends StatefulWidget {
  @override
  _SearchPageMainState createState() => _SearchPageMainState();
}

class _SearchPageMainState extends State<SearchPageMain> {
  final SearchController _searchController = Get.put(SearchController());

  Timer debounce;

  final keywordFocus = FocusNode();

  RecommendedProductsLoadMore source;

  onSearchChanged(String text) {
    print(text);
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 1000), () async {
      await _searchController.getData(
          keyword: _searchController.keywordCtrl.value.text, catId: "0");
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          keywordFocus.unfocus();
        },
        child: LoadingMoreCustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Color(0xff6E0200),
              titleSpacing: 0,
              expandedHeight: MediaQuery.of(context).size.height * 0.08,
              automaticallyImplyLeading: false,
              stretch: false,
              pinned: true,
              floating: false,
              forceElevated: false,
              elevation: 0,
              actions: [
                Container(),
              ],
              centerTitle: true,
              title: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 40,
                      child: TextField(
                        controller: _searchController.keywordCtrl.value,
                        autofocus: true,
                        enabled: true,
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        onChanged: onSearchChanged,
                        cursorColor: AppStyles.pinkColor,
                        decoration: CustomInputBorder()
                            .inputDecorationAppBar(
                              '${AppConfig.appName}',
                            )
                            .copyWith(
                              alignLabelWithHint: true,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _searchController.keywordCtrl.value.clear();
                                  _searchController.liveSearchModel.value =
                                      LiveSearchModel();
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  size: 16,
                                  color: AppStyles.lightGreyColor,
                                ),
                              ),
                              prefixIcon: CustomGradientOnChild(
                                child: Icon(
                                  Icons.search,
                                  color: AppStyles.pinkColor,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(8),
                            ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CartIconWidget(),
                  SizedBox(width: 8),
                ],
              ),
            ),
            Obx(() {
              if (_searchController.isLoading.value) {
                return SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomLoadingWidget(),
                    ],
                  ),
                );
              } else {
                if (_searchController.liveSearchModel.value.tags == null) {
                  return LoadingMoreSliverList<ProductModel>(
                    SliverListConfig<ProductModel>(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      indicatorBuilder: BuildIndicatorBuilder(
                        source: source,
                        isSliver: true,
                        name: 'Products'.tr,
                      ).buildIndicator,
                      extendedListDelegate:
                          SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
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
                  );
                } else {
                  return SliverFillRemaining(
                    child: _searchController
                                    .liveSearchModel.value.tags.length >
                                0 ||
                            _searchController
                                    .liveSearchModel.value.products.length >
                                0 ||
                            _searchController
                                    .liveSearchModel.value.categories.length >
                                0
                        ? ListView(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(bottom: 50),
                            children: [
                              _searchController
                                          .liveSearchModel.value.tags.length >
                                      0
                                  ? Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10),
                                      color: AppStyles.textFieldFillColor,
                                      child: Text(
                                        "Popular suggestions".tr,
                                        style: context.textTheme.titleMedium,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    separatorBuilder: (context, index) {
                                      return Divider(
                                        color: AppStyles.lightGreyColor,
                                      );
                                    },
                                    itemCount: _searchController
                                        .liveSearchModel.value.tags.length,
                                    itemBuilder: (context, tagIndex) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () async {
                                                  Get.to(() => ProductsByTags(
                                                        tagName:
                                                            _searchController
                                                                .liveSearchModel
                                                                .value
                                                                .tags[tagIndex]
                                                                .name,
                                                        tagId: _searchController
                                                            .liveSearchModel
                                                            .value
                                                            .tags[tagIndex]
                                                            .id,
                                                      ));
                                                },
                                                child: Container(
                                                  width: context.width,
                                                  height: 30,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: _searchController
                                                          .highlightOccurrences(
                                                              _searchController
                                                                  .liveSearchModel
                                                                  .value
                                                                  .tags[
                                                                      tagIndex]
                                                                  .name,
                                                              _searchController
                                                                  .keywordCtrl
                                                                  .value
                                                                  .text),
                                                      style: AppStyles
                                                          .appFontMedium
                                                          .copyWith(
                                                        fontSize: 14,
                                                        color: AppStyles
                                                            .greyColorLight,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                _searchController.keywordCtrl
                                                        .value.text =
                                                    _searchController
                                                        .liveSearchModel
                                                        .value
                                                        .tags[tagIndex]
                                                        .name;

                                                await _searchController.getData(
                                                    keyword: _searchController
                                                        .keywordCtrl.value.text,
                                                    catId: "0");
                                              },
                                              child: Transform.rotate(
                                                angle: math.pi * 0.3,
                                                child: Icon(
                                                  Icons.arrow_back,
                                                  color:
                                                      AppStyles.greyColorLight,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                              _searchController.liveSearchModel.value.categories
                                          .length >
                                      0
                                  ? Container(
                                      margin: EdgeInsets.only(top: 10),
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10),
                                      color: AppStyles.textFieldFillColor,
                                      child: Text(
                                        "Category suggestions".tr,
                                        style: context.textTheme.titleMedium,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              _searchController.liveSearchModel.value.categories
                                          .length >
                                      0
                                  ? Container(
                                      padding: EdgeInsets.only(top: 10),
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              color: AppStyles.lightGreyColor,
                                            );
                                          },
                                          itemCount: _searchController
                                              .liveSearchModel
                                              .value
                                              .categories
                                              .length,
                                          itemBuilder: (context, catIndex) {
                                            CategoryData category =
                                                _searchController
                                                    .liveSearchModel
                                                    .value
                                                    .categories[catIndex];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    child: FancyShimmerImage(
                                                      imageUrl:
                                                          "${category.categoryImage}",
                                                      boxFit: BoxFit.contain,
                                                      errorWidget:
                                                          FancyShimmerImage(
                                                        imageUrl:
                                                            "${AppConfig.assetPath}/backend/img/default.png",
                                                        boxFit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Get.to(() =>
                                                            ProductsByCategory(
                                                              categoryId:
                                                                  category.id,
                                                            ));
                                                      },
                                                      child: Container(
                                                        width: context.width,
                                                        height: 30,
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: RichText(
                                                          text: TextSpan(
                                                            children: _searchController
                                                                .highlightOccurrences(
                                                                    category
                                                                        .name,
                                                                    _searchController
                                                                        .keywordCtrl
                                                                        .value
                                                                        .text),
                                                            style: AppStyles
                                                                .appFontMedium
                                                                .copyWith(
                                                              fontSize: 14,
                                                              color: AppStyles
                                                                  .greyColorLight,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(
                                height: 10,
                              ),
                              _searchController
                                          .liveSearchModel.value.tags.length >
                                      0
                                  ? Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10),
                                      color: AppStyles.textFieldFillColor,
                                      child: Text(
                                        "Products".tr,
                                        style: context.textTheme.titleMedium,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              Container(
                                padding: EdgeInsets.only(top: 10),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    separatorBuilder: (context, index) {
                                      return Divider(
                                        color: AppStyles.lightGreyColor,
                                      );
                                    },
                                    itemCount: _searchController
                                        .liveSearchModel.value.products.length,
                                    itemBuilder: (context, productIndex) {
                                      SearchedProductModel product =
                                          _searchController.liveSearchModel
                                              .value.products[productIndex];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              child: FancyShimmerImage(
                                                imageUrl: "${product.thumbImg}",
                                                boxFit: BoxFit.contain,
                                                errorWidget: FancyShimmerImage(
                                                  imageUrl:
                                                      "${AppConfig.assetPath}/backend/img/default.png",
                                                  boxFit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () async {
                                                  Get.to(() => ProductDetails(
                                                      productID: product.id.toString()));
                                                },
                                                child: Container(
                                                  width: context.width,
                                                  height: 30,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: _searchController
                                                          .highlightOccurrences(
                                                              product
                                                                  .productName,
                                                              _searchController
                                                                  .keywordCtrl
                                                                  .value
                                                                  .text),
                                                      style: AppStyles
                                                          .appFontMedium
                                                          .copyWith(
                                                        fontSize: 14,
                                                        color: AppStyles
                                                            .greyColorLight,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Nothing found for'.tr,
                                    style: context.textTheme.titleMedium.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: " ",
                                      ),
                                      TextSpan(
                                        text: "\"",
                                        style: context.textTheme.titleMedium
                                            .copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "${_searchController.keywordCtrl.value.text}",
                                        style: context.textTheme.titleMedium
                                            .copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "\"",
                                        style: context.textTheme.titleMedium
                                            .copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  );
                }
              }
            }),
          ],
        ),
      ),
    );
  }
}
