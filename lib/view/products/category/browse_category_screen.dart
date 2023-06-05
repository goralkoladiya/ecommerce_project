import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/model/Category/CategoryData.dart';
import 'package:amazy_app/model/Category/CategoryMain.dart';
import 'package:amazy_app/model/Category/ParentCategory.dart';
import 'package:amazy_app/model/Category/SingleCategory.dart';
import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/category/ProductsByCategory.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/PinkButtonWidget.dart';
import 'package:amazy_app/widgets/fa_icon_maker/fa_custom_icon.dart';
import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_skeleton/loading_skeleton.dart';
import 'package:loading_more_list/loading_more_list.dart';

class BrowseCategoryScreen extends StatefulWidget {
  @override
  State<BrowseCategoryScreen> createState() => _BrowseCategoryScreenState();
}

class _BrowseCategoryScreenState extends State<BrowseCategoryScreen> {
  int previousCategory = 0;
  int currentCategory = 0;
  int nextCategory = 0;

  Dio _dio = Dio();

  int _selectedIndex = 0;

  Widget backWidget;

  Future<CategoryMain> categoryFuture;

  Future<SingleCategory> subCategoryFuture;

  CategoryLoadMore source;

  Future<CategoryMain> getCategories() async {
    CategoryMain categoryMain;

    try {
      await _dio
          .get(
        URLs.BROWSE_CATEGORY,
      )
          .then((value) {
        var data = new Map<String, dynamic>.from(value.data);
        categoryMain = CategoryMain.fromJson(data);
      });
    } catch (e) {
      print(e.toString());
    }
    return categoryMain;
  }

  Future<SingleCategory> getSubCategory(id) async {
    SingleCategory singleCategory;

    print(URLs.ALL_CATEGORY + "/$id");

    try {
      await _dio
          .get(
        URLs.ALL_CATEGORY + "/$id",
      )
          .then((value) {
        var data = new Map<String, dynamic>.from(value.data);
        singleCategory = SingleCategory.fromJson(data);
      });
    } catch (e) {
      print(e.toString());
    }
    return singleCategory;
  }

  @override
  void initState() {
    source = CategoryLoadMore();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    categoryFuture = getCategories();
    categoryFuture.then((value) {
      setState(() {
        currentCategory =
            value.data.data.where((element) => element.parentId == 0).first.id;

        subCategoryFuture = getSubCategory(
            value.data.data.where((element) => element.parentId == 0).first.id);

        print('previous $previousCategory --- current $currentCategory');
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          CustomSliverAppBarWidget(false, false),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)),
                ),
              ),
              child: Text(
                "Browse Categories",
                style: AppStyles.appFontMedium.copyWith(
                  fontSize: 18,
                  color: Color(0xff5C7185),
                ),
              ),
            ),
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
          SliverFillRemaining(
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          source.refresh();
                        },
                        child: LoadingMoreList<CategoryData>(
                          ListConfig<CategoryData>(
                            indicatorBuilder: CategoryLoadIndicator(
                              source: source,
                              isSliver: false,
                              name: 'Products'.tr,
                            ).buildIndicator,
                            padding: EdgeInsets.only(bottom: 30),
                            itemBuilder: (BuildContext c, CategoryData category,
                                int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: _selectedIndex == index
                                      ? Border(
                                          left: BorderSide(
                                            width: 6,
                                            color: Colors.black,
                                          ),
                                        )
                                      : null,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      subCategoryFuture =
                                          getSubCategory(category.id);
                                      _selectedIndex = index;

                                      currentCategory = category.id;
                                      previousCategory = 0;
                                    });
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        padding: EdgeInsets.all(4),
                                        child: category.categoryImage == null
                                            ? category.icon != null
                                                ? Container(
                                                    child: Icon(
                                                      FaCustomIcon
                                                          .getFontAwesomeIcon(
                                                              category.icon),
                                                      size: 30,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : Container(
                                                    child: Icon(
                                                      Icons.list_alt_outlined,
                                                      size: 30,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                            : FancyShimmerImage(
                                                imageUrl:
                                                    "${AppConfig.assetPath}/${category.categoryImage.image}",
                                                boxFit: BoxFit.contain,
                                                errorWidget: FancyShimmerImage(
                                                  imageUrl:
                                                      "${AppConfig.assetPath}/backend/img/default.png",
                                                  boxFit: BoxFit.contain,
                                                ),
                                              ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                          category.name ?? "",
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: AppStyles.appFontBold.copyWith(
                                            color: _selectedIndex == index
                                                ? AppStyles.pinkColor
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            sourceList: source,
                          ),
                        ),
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      color: Colors.white,
                      child: FutureBuilder<SingleCategory>(
                          future: subCategoryFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemCount: 6,
                                itemBuilder: (context, subIndex) {
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        LoadingSkeleton(
                                          width: 65,
                                          height: 65,
                                          child: SizedBox(),
                                          colors: [
                                            Colors.black.withOpacity(0.1),
                                            Colors.black.withOpacity(0.2),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        LoadingSkeleton(
                                          width: 65,
                                          height: 10,
                                          child: SizedBox(),
                                          colors: [
                                            Colors.black.withOpacity(0.1),
                                            Colors.black.withOpacity(0.2),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else if (!snapshot.hasData) {
                              return SizedBox.shrink();
                            } else {
                              final List<ParentCategory> subCategoryList =
                                  snapshot.data.data.subCategories.toList();

                              final CategoryData parentCategory =
                                  snapshot.data.data;

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  previousCategory != 0
                                      ? InkWell(
                                          onTap: () {
                                            setState(() {
                                              subCategoryFuture =
                                                  getSubCategory(
                                                      previousCategory);

                                              subCategoryFuture.then((value) {
                                                currentCategory = value.data.id;

                                                previousCategory =
                                                    value.data.parentId;
                                              });
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 10),
                                            child: Text("Back"),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  Flexible(
                                    child: GridView.builder(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 15,
                                        mainAxisExtent: 120,
                                      ),
                                      itemCount: subCategoryList.length + 1,
                                      itemBuilder: (context, subIndex) {
                                        if (subIndex == 0) {
                                          return InkWell(
                                            onTap: () {
                                              Get.to(() => ProductsByCategory(
                                                    categoryId:
                                                        parentCategory.id,
                                                  ));
                                            },
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    height: 70,
                                                    alignment: Alignment.center,
                                                    child: parentCategory
                                                                .categoryImage ==
                                                            null
                                                        ? parentCategory.icon !=
                                                                null
                                                            ? Container(
                                                                child: Icon(
                                                                  FaCustomIcon.getFontAwesomeIcon(
                                                                      parentCategory
                                                                          .icon),
                                                                  size: 30,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )
                                                            : Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .list_alt_outlined,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )
                                                        : FancyShimmerImage(
                                                            imageUrl:
                                                                "${AppConfig.assetPath}/${parentCategory.categoryImage.image}",
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
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "${parentCategory.name}",
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          AppStyles.appFontBold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          final ParentCategory subCategory =
                                              subCategoryList[subIndex - 1];

                                          return InkWell(
                                            onTap: () {
                                              if (subCategory
                                                      .subCategories.length >
                                                  0) {
                                                setState(() {
                                                  previousCategory =
                                                      currentCategory;
                                                  currentCategory =
                                                      subCategory.id;
                                                  subCategoryFuture =
                                                      getSubCategory(
                                                          subCategory.id);
                                                });
                                              } else {
                                                Get.to(() => ProductsByCategory(
                                                      categoryId:
                                                          subCategory.id,
                                                    ));
                                              }
                                            },
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    height: 70,
                                                    alignment: Alignment.center,
                                                    child: subCategory
                                                                .categoryImage ==
                                                            null
                                                        ? subCategory.icon !=
                                                                null
                                                            ? Container(
                                                                child: Icon(
                                                                  FaCustomIcon.getFontAwesomeIcon(
                                                                      subCategory
                                                                          .icon),
                                                                  size: 30,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )
                                                            : Container(
                                                                child: Icon(
                                                                  Icons
                                                                      .list_alt_outlined,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )
                                                        : FancyShimmerImage(
                                                            imageUrl:
                                                                "${AppConfig.assetPath}/${subCategory.categoryImage.image}",
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
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "${subCategory.name}",
                                                      maxLines: 2,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:
                                                          AppStyles.appFontBold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
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

class CategoryLoadMore extends LoadingMoreBase<CategoryData> {
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
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
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
      // await Future.delayed(Duration(milliseconds: 500));
      var result;
      CategoryMain source;

      if (this.length == 0) {
        result = await _dio.get(URLs.BROWSE_CATEGORY);
      } else {
        result = await _dio.get(URLs.BROWSE_CATEGORY, queryParameters: {
          'page': pageIndex,
        });
      }
      print(result.realUri);
      final data = new Map<String, dynamic>.from(result.data);
      source = CategoryMain.fromJson(data);
      productsLength = source.data.total;

      if (pageIndex == 1) {
        this.clear();
      }
      for (var item in source.data.data) {
        this.add(item);
      }

      _hasMore = source.data.data.length != 0;
      pageIndex++;
      isSuccess = true;
    } catch (exception, _) {
      isSuccess = false;
      print(exception);
      print(_);
    }
    return isSuccess;
  }
}

class CategoryLoadIndicator {
  final dynamic source;
  final bool isSliver;
  final String name;

  CategoryLoadIndicator({this.source, this.isSliver, this.name});

  Widget buildIndicator(BuildContext context, IndicatorStatus status) {
    Widget widget;
    switch (status) {
      case IndicatorStatus.none:
        widget = Container(height: 0.0);
        break;
      case IndicatorStatus.loadingMoreBusying:
        widget = Center(child: SizedBox(width: 50));
        break;
      case IndicatorStatus.fullScreenBusying:
        widget = Container(
          margin: EdgeInsets.only(right: 0.0),
          child: SizedBox.shrink(),
        );
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.error:
        widget = Text('Error', style: AppStyles.kFontBlack14w5);

        widget = GestureDetector(
          onTap: () {
            source.errorRefresh();
          },
          child: widget,
        );

        break;
      case IndicatorStatus.fullScreenError:
        widget = ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              child: Image.asset(
                AppConfig.appLogo,
                width: 30,
                height: 30,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '- No $name found - ',
              style: AppStyles.kFontBlack17w5,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: PinkButtonWidget(
                btnOnTap: () {
                  source.errorRefresh();
                },
                btnText: 'Reload',
              ),
            ),
          ],
        );
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.noMoreLoad:
        widget = SizedBox.shrink();
        break;
      case IndicatorStatus.empty:
        widget = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              color: AppStyles.pinkColor,
              child: Image.asset(
                AppConfig.appLogo,
                width: 30,
                height: 30,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '- No $name Found - ',
              style: AppStyles.kFontBlack17w5,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: PinkButtonWidget(
                btnOnTap: () {
                  Get.back();
                },
                btnText: 'Continue Shopping',
              ),
            ),
          ],
        );
        if (isSliver) {
          widget = SliverToBoxAdapter(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
    }
    return widget;
  }
}
