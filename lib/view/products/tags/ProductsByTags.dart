import 'dart:developer';

import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/controller/tag_controller.dart';
import 'package:amazy_app/model/FilterFromCatModel.dart';
import 'package:amazy_app/model/Product/AllProducts.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';

import 'package:amazy_app/model/SortingModel.dart';
import 'package:amazy_app/model/Tags/TagProductsModel.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/tags/TagFilterDrawer.dart';
import 'package:amazy_app/widgets/BuildIndicatorBuilder.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/single_product_widgets/GridViewProductWidget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ProductsByTags extends StatefulWidget {
  final String tagName;
  final int tagId;

  ProductsByTags({this.tagName, this.tagId});

  @override
  _ProductsByTagsState createState() => _ProductsByTagsState();
}

class _ProductsByTagsState extends State<ProductsByTags> {
  final TagController controller = Get.put(TagController());
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.put(CartController());

  final TagController tagController = Get.put(TagController());

  Sorting _selectedSort;

  bool filterSelected = false;

  TagProductsLoadMore source;

  @override
  void initState() {
    getTagProducts();

    source = TagProductsLoadMore(widget.tagName, widget.tagId);
    source.isSorted = false;
    source.isFilter = false;

    super.initState();
  }

  Future getTagProducts() async {
    await tagController.getTagProducts(widget.tagId);
    if (controller.dataFilterCat.value.filterDataFromCat != null) {
      controller.dataFilterCat.value.filterDataFromCat.filterType
          .forEach((element) {
        if (element.filterTypeId == 'brand' || element.filterTypeId == 'cat') {
          print(element.filterTypeId);
          element.filterTypeValue.clear();
        }
      });
    }

    controller.filterRating.value = 0.0;
  }

  @override
  void dispose() {
    source.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppStyles.appBackgroundColor,
        endDrawer: TagFilterDrawer(
          tagId: widget.tagId,
          scaffoldKey: _scaffoldKey,
          source: source,
        ),
        body: LoadingMoreCustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomSliverAppBarWidget(true, true),
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: Obx(() {
                if (tagController.isTagLoading.value) {
                  return SliverToBoxAdapter(child: Container());
                } else {
                  if (tagController.tagAllData.value.products.total == 0) {
                    return SliverToBoxAdapter(child: Container());
                  } else {
                    return SliverAppBar(
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      centerTitle: false,
                      titleSpacing: 0,
                      toolbarHeight: 5,
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
                                            source.sortKey = newValue.sortKey;
                                            source.isSorted = true;
                                            source.isFilter = false;
                                            source.refresh(true);
                                          });
                                        });
                                      },
                                      items: Sorting.sortingData.map((sort) {
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
                                        setState(() {
                                          _selectedSort = newValue;
                                          setState(() {
                                            source.isSorted = true;
                                            source.isFilter = true;
                                            controller.filterSortKey.value =
                                                _selectedSort.sortKey;
                                            source.refresh(true);
                                          });
                                        });
                                      },
                                      items: Sorting.sortingData.map((sort) {
                                        return DropdownMenuItem(
                                          child: Text(sort.sortName),
                                          value: sort,
                                        );
                                      }).toList(),
                                    ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    filterSelected = true;
                                    _selectedSort = Sorting.sortingData.first;
                                  });
                                  _scaffoldKey.currentState.openEndDrawer();
                                },
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                    bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  Obx(() {
                    if (controller.isTagLoading.value) {
                      return SizedBox.shrink();
                    } else {
                      if (tagController.tagAllData.value.products.total == 0) {
                        return SizedBox.shrink();
                      } else {
                        return Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  "${controller.tagAllData.value.tag.name.capitalizeFirst}",
                                  style: AppStyles.appFontMedium.copyWith(
                                    fontSize: 18,
                                    color: Color(0xff5C7185),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Container(
                                child: Text(
                                  "${controller.tagAllData.value.products.total} " +
                                      "Products found".tr,
                                  style: AppStyles.appFontMedium.copyWith(
                                    fontSize: 13,
                                    color: Color(0xffC5C5C5),
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
            LoadingMoreSliverList<ProductModel>(
              SliverListConfig<ProductModel>(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                indicatorBuilder: BuildIndicatorBuilder(
                        source: source, isSliver: true, name: 'Products'.tr)
                    .buildIndicator,
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
            ),
          ],
        ));
  }
}

class TagProductsLoadMore extends LoadingMoreBase<ProductModel> {
  final String tagName;
  final int tagId;

  TagProductsLoadMore(this.tagName, this.tagId);

  bool isSorted;
  String sortKey = 'new';
  bool isFilter;

  final TagController controller = Get.put(TagController());

  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int productsLength = 0;

  @override
  bool get hasMore => (_hasMore && (length < productsLength)) || forceRefresh;

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
    Dio _dio = Dio();

    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      await Future.delayed(Duration(milliseconds: 500));
      var result;
      dynamic source;
      print(
          'TAG NAME $tagName -> URL : ${URLs.SINGLE_TAG_PRODUCTS + '/$tagId'}');
      if (!isSorted && !isFilter) {
        if (this.length == 0) {
          result = await _dio.get(URLs.SINGLE_TAG_PRODUCTS + '/$tagId');
        } else {
          result = await _dio
              .get(URLs.SINGLE_TAG_PRODUCTS + '/$tagId', queryParameters: {
            'page': pageIndex,
          });
        }
        print(result.data);
        final data = new Map<String, dynamic>.from(result.data);
        source = TagProductsModel.fromJson(data);
        productsLength = source.products.total;
      }

      if (isSorted && !isFilter) {
        if (this.length == 0) {
          result = await _dio.get(URLs.SORT_PRODUCTS, queryParameters: {
            'requestItem': tagName,
            'requestItemType': 'tag',
            'sort_by': sortKey,
          });
        } else {
          result = await _dio.get(URLs.SORT_PRODUCTS, queryParameters: {
            'requestItem': tagName,
            'requestItemType': 'tag',
            'sort_by': sortKey,
            'page': pageIndex,
          });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
        productsLength = data['meta']['total'];
      }

      if (isSorted && isFilter) {
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
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
        productsLength = data['meta']['total'];
        print('FILTERED $productsLength');
      }

      if (pageIndex == 1) {
        this.clear();
      }
      if (!isSorted && !isFilter) {
        for (var item in source.products.data) {
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
        _hasMore = source.products.data.length != 0;
      }
      if (isSorted && !isFilter) {
        _hasMore = source.total != 0;
      }
      if (isSorted && isFilter) {
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
