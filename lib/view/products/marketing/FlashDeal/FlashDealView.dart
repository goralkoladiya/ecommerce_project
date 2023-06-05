import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/controller/home_controller.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';

import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/marketing/FlashDeal/flash_deal_controller.dart';
import 'package:amazy_app/widgets/BuildIndicatorBuilder.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/single_product_widgets/GridViewProductWidget.dart';

import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:amazy_app/model/FlashDeals/FlashDealModel.dart';
import 'package:loading_more_list/loading_more_list.dart';

class FlashDealView extends StatefulWidget {
  @override
  State<FlashDealView> createState() => _FlashDealViewState();
}

class _FlashDealViewState extends State<FlashDealView> {
  FlashDealProductsLoadMore source;
  final FlashDealController controller = Get.put(FlashDealController());

  @override
  void initState() {
    source = FlashDealProductsLoadMore();
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
      body: LoadingMoreCustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBarWidget(true, true),
          SliverToBoxAdapter(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                Obx(() {
                  if (controller.flashProductData.length <= 0) {
                    if (controller.isFlashDealProductsLoading.value) {
                      return Container();
                    }
                    return Container();
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        controller.flashDealImage.value == null
                            ? Container()
                            : FancyShimmerImage(
                                height: 150,
                                imageUrl: AppConfig.assetPath +
                                    "/" +
                                    controller.flashDealImage.value,
                                boxFit: BoxFit.cover,
                                errorWidget: FancyShimmerImage(
                                  imageUrl:
                                      "${AppConfig.assetPath}/backend/img/default.png",
                                  boxFit: BoxFit.contain,
                                ),
                              ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            children: [
                              Text(
                                controller.flashDealTitle.value.toUpperCase(),
                                style: AppStyles.kFontWhite14w5.copyWith(
                                  color: Color(
                                    controller.textColor.value,
                                  ),
                                  fontSize: 18,
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    gradient: AppStyles.gradient,
                                    borderRadius: BorderRadius.circular(5)),
                                child: CountdownTimer(
                                  endTime: controller.endTime.value,
                                  widgetBuilder:
                                      (_, CurrentRemainingTime time) {
                                    return Text(
                                      '${time.days}d-${time.hours}h-${time.min}m-${time.sec}s',
                                      style: AppStyles.appFontLight.copyWith(
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
          LoadingMoreSliverList<ProductModel>(
            SliverListConfig<ProductModel>(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
              itemBuilder: (BuildContext c, ProductModel prod, int index) {
                return GridViewProductWidget(
                  productModel: prod,
                );
              },
              sourceList: source,
            ),
          ),
        ],
      ),
    );
  }
}

class FlashDealProductsLoadMore extends LoadingMoreBase<ProductModel> {
  final HomeController controller = Get.put(HomeController());

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
      FlashDealModel source;

      if (this.length == 0) {
        result = await _dio.get(
          URLs.FLASH_DEALS,
        );
      } else {
        result = await _dio.get(URLs.FLASH_DEALS, queryParameters: {
          'page': pageIndex,
        });
      }
      final data = new Map<String, dynamic>.from(result.data);
      source = FlashDealModel.fromJson(data);
      productsLength = source.flashDeal.allProducts.total;

      if (pageIndex == 1) {
        this.clear();
      }
      for (var item in source.flashDeal.allProducts.data) {
        this.add(item.product);
      }

      _hasMore = source.flashDeal.allProducts.data.length != 0;
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
