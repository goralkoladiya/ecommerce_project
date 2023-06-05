import 'package:amazy_app/controller/home_controller.dart';
import 'package:amazy_app/controller/seller_profile_controller.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/model/SortingModel.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/seller/SellerProductsLoadMore.dart';
import 'package:amazy_app/widgets/BuildIndicatorBuilder.dart';
import 'package:amazy_app/widgets/single_product_widgets/GridViewProductWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

class StoreAllProductsPage extends StatefulWidget {
  final int sellerId;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final SellerProductsLoadMore source;
  StoreAllProductsPage({this.sellerId, this.scaffoldKey, this.source});
  @override
  _StoreAllProductsPageState createState() => _StoreAllProductsPageState();
}

class _StoreAllProductsPageState extends State<StoreAllProductsPage> {

  SellerProfileController controller;

  final HomeController homeController = Get.put(HomeController());

  Sorting _selectedSort;

  bool filterSelected = false;

  @override
  void initState() {
    controller = Get.put(SellerProfileController(widget.sellerId));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // const Key('Tab2'),
      key: Key('Tab2'),
      child: Container(
        child: LoadingMoreCustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: Obx(() {
                if (controller.isLoading.value) {
                  return SliverToBoxAdapter(child: Container());
                } else {
                  if (controller
                          .seller.value.seller.sellerProductsApi.data.length ==
                      0) {
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
                                            widget.source.sortKey = newValue.sortKey;
                                            widget.source.isSorted = true;
                                            widget.source.isFilter = false;
                                            widget.source.refresh(true);
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
                                            widget.source.isSorted = true;
                                            widget.source.isFilter = true;
                                            controller.filterSortKey.value =
                                                _selectedSort.sortKey;
                                            widget.source.refresh(true);
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
                                  widget.scaffoldKey.currentState
                                      .openEndDrawer();
                                },
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(width: 5),
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
            LoadingMoreSliverList<ProductModel>(
              SliverListConfig<ProductModel>(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 50, top: 10),
                indicatorBuilder: BuildIndicatorBuilder(
                  source: widget.source,
                  isSliver: true,
                  name: 'Products'.tr,
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
                sourceList: widget.source,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
