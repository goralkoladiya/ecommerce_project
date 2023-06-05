import 'dart:developer';

import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/model/FilterFromCatModel.dart';
import 'package:amazy_app/model/Brand/SingleBrandModel.dart';
import 'package:amazy_app/model/Product/AllProducts.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/model/SortingModel.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/brand/brand_controller.dart';
import 'package:amazy_app/widgets/BuildIndicatorBuilder.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/single_product_widgets/GridViewProductWidget.dart';
import 'package:amazy_app/widgets/single_product_widgets/ListViewProductWidget.dart';
import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'BrandFilterDrawer.dart';

// ignore: must_be_immutable
class ProductsByBrands extends StatefulWidget {
  final int brandId;

  ProductsByBrands({this.brandId});

  @override
  _ProductsByBrandsState createState() => _ProductsByBrandsState();
}

class _ProductsByBrandsState extends State<ProductsByBrands> {
  BrandController _brandController;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.put(CartController());

  Sorting _selectedSort;

  bool filterSelected = false;

  BrandProductsLoadMore source;

  @override
  void initState() {
    _brandController = Get.put(BrandController(bId: widget.brandId));
    source = BrandProductsLoadMore(widget.brandId);
    source.isSorted = false;
    source.isFilter = false;

    super.initState();
  }

  @override
  void dispose() {
    source.dispose();

    super.dispose();
  }

  Future<void> onRefresh() async {
    print('onref');
    _brandController.allBrandProducts.clear();
    _brandController.brandPageNumber.value = 1;
    _brandController.lastBrandPage.value = false;
    await _brandController.getBrandProducts();
  }

  final ScrollController scrollController = ScrollController();

  bool isScrolling = false;
  bool _isList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: BrandFilterDrawer(
          brandId: _brandController.brandId.value,
          scaffoldKey: _scaffoldKey,
          source: source,
        ),
        backgroundColor: AppStyles.appBackgroundColor,
        floatingActionButton: isScrolling
            ? FloatingActionButton(
                backgroundColor: AppStyles.pinkColor,
                onPressed: () {
                  scrollController.animateTo(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
                child: Icon(
                  Icons.arrow_upward_sharp,
                ),
              )
            : Container(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
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
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              slivers: [
                CustomSliverAppBarWidget(true, true),
                SliverPadding(
                  padding: EdgeInsets.zero,
                  sliver: Obx(() {
                    if (_brandController.isBrandsProductsLoading.value) {
                      return SliverToBoxAdapter(child: Container());
                    } else {
                      if (_brandController.brandAllData.value.data.allProducts
                              .data.length ==
                          0) {
                        return SliverToBoxAdapter(child: Container());
                      } else {
                        return SliverAppBar(
                          backgroundColor: Colors.white,
                          automaticallyImplyLeading: false,
                          centerTitle: false,
                          titleSpacing: 0,
                          toolbarHeight: 15,
                          expandedHeight: 0,
                          forceElevated: false,
                          elevation: 0,
                          primary: true,
                          pinned: true,
                          stretch: false,
                          leading: Container(),
                          actions: [
                            Container(
                              width: 50,
                              alignment: Alignment.center,
                              child: Container(),
                            ),
                          ],
                          flexibleSpace: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: !filterSelected
                                      ? DropdownButton(
                                          isExpanded: false,
                                          isDense: false,
                                          hint: Text(
                                            'Sort'.tr,
                                            style: AppStyles.appFontMedium
                                                .copyWith(fontSize: 13),
                                          ),
                                          underline: SizedBox(),
                                          value: _selectedSort,
                                          style: AppStyles.appFontMedium
                                              .copyWith(fontSize: 13),
                                          onChanged: (newValue) async {
                                            setState(() {
                                              _selectedSort = newValue;
                                              setState(() {
                                                source.sortKey =
                                                    newValue.sortKey;
                                                source.isSorted = true;
                                                source.isFilter = false;
                                                source.refresh(true);
                                              });
                                            });
                                          },
                                          items:
                                              Sorting.sortingData.map((sort) {
                                            return DropdownMenuItem(
                                              child: Text(
                                                sort.sortName,
                                                style: AppStyles.appFontMedium
                                                    .copyWith(fontSize: 13),
                                              ),
                                              value: sort,
                                            );
                                          }).toList(),
                                        )
                                      : DropdownButton(
                                          hint: Text(
                                            'Sort'.tr,
                                            style: AppStyles.appFontMedium
                                                .copyWith(fontSize: 13),
                                          ),
                                          underline: Container(),
                                          value: _selectedSort,
                                          style: AppStyles.appFontMedium
                                              .copyWith(fontSize: 13),
                                          onChanged: (newValue) async {
                                            print('SORT AFTER FILTER');
                                            print('SORT AFTER FILTER');
                                            setState(() {
                                              _selectedSort = newValue;
                                              setState(() {
                                                source.isSorted = true;
                                                source.isFilter = true;
                                                _brandController
                                                        .filterSortKey.value =
                                                    _selectedSort.sortKey;
                                                source.refresh(true);
                                              });
                                            });
                                          },
                                          items:
                                              Sorting.sortingData.map((sort) {
                                            return DropdownMenuItem(
                                              child: Text(sort.sortName),
                                              value: sort,
                                            );
                                          }).toList(),
                                        ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isList = !_isList;
                                            });
                                          },
                                          child: Icon(
                                            !_isList
                                                ? FontAwesomeIcons.bars
                                                : FontAwesomeIcons.tableCellsLarge,
                                            size: 20,
                                            color: AppStyles.greyColorBook,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              filterSelected = true;
                                              _selectedSort =
                                                  Sorting.sortingData.first;
                                            });
                                            _scaffoldKey.currentState
                                                .openEndDrawer();
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.filter_alt_outlined,
                                                size: 20,
                                                color: AppStyles.pinkColor,
                                              ),
                                              Text(
                                                'Filter'.tr,
                                                style: AppStyles.appFontMedium
                                                    .copyWith(fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  }),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 1.0, color: Color(0xffEFEFEF)),
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  if (_brandController.isBrandsProductsLoading.value) {
                    return SliverToBoxAdapter(child: Container());
                  } else {
                    return SliverToBoxAdapter(
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        children: [
                          _brandController.brandImage.value == null
                              ? Container()
                              : Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          clipBehavior: Clip.antiAlias,
                                          child: FancyShimmerImage(
                                            imageUrl: AppConfig.assetPath +
                                                "/" +
                                                _brandController
                                                    .brandImage.value,
                                            height: 50,
                                            width: 50,
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
                                        width: 10,
                                      ),
                                      Text(
                                        _brandController.brandTitle.value,
                                        style: AppStyles.appFontMedium.copyWith(
                                          fontSize: 18,
                                          color: Color(0xff5C7185),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Container(
                                        child: Text(
                                          "${_brandController.brandAllData.value.data.allProducts.total} " +
                                              "Products found".tr,
                                          style:
                                              AppStyles.appFontMedium.copyWith(
                                            fontSize: 13,
                                            color: Color(0xffC5C5C5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    );
                  }
                }),
                !_isList
                    ? LoadingMoreSliverList<ProductModel>(
                        SliverListConfig<ProductModel>(
                          indicatorBuilder: BuildIndicatorBuilder(
                            source: source,
                            isSliver: true,
                            name: 'Products'.tr,
                          ).buildIndicator,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
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
                      )
                    : LoadingMoreSliverList<ProductModel>(
                        SliverListConfig<ProductModel>(
                          indicatorBuilder: BuildIndicatorBuilder(
                            source: source,
                            isSliver: true,
                            name: 'Products'.tr,
                          ).buildIndicator,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          itemBuilder:
                              (BuildContext c, ProductModel prod, int index) {
                            return ListViewProductWidget(
                              productModel: prod,
                            );
                          },
                          sourceList: source,
                        ),
                      ),
              ],
            ),
          ),
        ));
  }
}

class BrandProductsLoadMore extends LoadingMoreBase<ProductModel> {
  final int brandId;

  BrandProductsLoadMore(this.brandId);

  bool isSorted;
  String sortKey = 'new';
  bool isFilter;

  BrandController controller;

  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int productsLength = 0;

  @override
  bool get hasMore => (_hasMore && length < productsLength) || forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    controller = Get.put(BrandController(bId: brandId));

    Dio _dio = Dio();

    bool isSuccess = false;
    try {
      await Future.delayed(Duration(milliseconds: 500));
      var result;
      var source;

      if (!isSorted && !isFilter) {
        if (this.length == 0) {
          result = await _dio.get(URLs.ALL_BRAND + '/$brandId');
        } else {
          result =
              await _dio.get(URLs.ALL_BRAND + '/$brandId', queryParameters: {
            'page': pageIndex,
          });
        }
        print('URI IS ${result.realUri}');
        final data = new Map<String, dynamic>.from(result.data);
        source = SingleBrandModel.fromJson(data);
        productsLength = source.data.allProducts.total;
        print('INITIALIZED BRAND LENGTH $productsLength');
      }
      if (isSorted && !isFilter) {
        if (this.length == 0) {
          result = await _dio.get(URLs.SORT_PRODUCTS, queryParameters: {
            'sort_by': sortKey,
            'paginate': 9,
            'requestItem': brandId,
            'requestItemType': 'brand',
          });
        } else {
          result = await _dio.get(URLs.SORT_PRODUCTS, queryParameters: {
            'sort_by': sortKey,
            'paginate': 9,
            'requestItem': brandId,
            'requestItemType': 'brand',
            'page': pageIndex,
          });
        }
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
        productsLength = data['meta']['total'];
      }
      if (isFilter && isSorted) {
        controller.dataFilterCat.value.filterDataFromCat.filterType.removeWhere(
            (element) =>
                element.filterTypeValue.length == 0 &&
                element.filterTypeId != 'cat');

        controller.dataFilterCat.value.sortBy =
            controller.filterSortKey.value.toString();

        controller.dataFilterCat.value.page = pageIndex.toString();

        if (this.length == 0) {
          log(filterFromCatModelToJson(controller.dataFilterCat.value));
          result = await _dio.post(
            URLs.FILTER_ALL_PRODUCTS,
            data: filterFromCatModelToJson(controller.dataFilterCat.value),
          );
        } else {
          log(filterFromCatModelToJson(controller.dataFilterCat.value));
          result = await _dio.post(
            URLs.FILTER_ALL_PRODUCTS,
            data: filterFromCatModelToJson(controller.dataFilterCat.value),
          );
        }
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
        productsLength = data['meta']['total'];
      }

      if (pageIndex == 1) {
        this.clear();
      }

      if (!isSorted && !isFilter) {
        for (var item in source.data.allProducts.data) {
          this.add(item);
        }
      }
      if (isSorted && !isFilter) {
        for (var item in source.data) {
          this.add(item);
        }
      }
      if (isFilter && isSorted) {
        for (var item in source.data) {
          this.add(item);
        }
      }

      if (!isSorted && !isFilter) {
        _hasMore = source.data.allProducts.total != 0;
      }
      if (isSorted && !isFilter) {
        _hasMore = source.total != 0;
      }
      if (isFilter && isSorted) {
        _hasMore = source.total != 0;
      }

      pageIndex++;
      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}
