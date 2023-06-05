import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/controller/new_user_zone_controller.dart';
import 'package:amazy_app/model/NewUserZoneModel.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/widgets/BuildIndicatorBuilder.dart';
import 'package:amazy_app/widgets/single_product_widgets/GridViewProductWidget.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:loading_more_list/loading_more_list.dart';

class NewUserZoneProducts extends StatefulWidget {
  @override
  _NewUserZoneProductsState createState() => _NewUserZoneProductsState();
}

class _NewUserZoneProductsState extends State<NewUserZoneProducts> {
  final NewUserZoneController newUserZoneController =
      Get.put(NewUserZoneController());

  NewUserZoneAllProductsLoadMore source;

  @override
  void initState() {
    source = NewUserZoneAllProductsLoadMore();
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
      // const Key('products'),
      key: Key('products'),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              newUserZoneController
                  .newZone.value.newUserZone.productSlogan.capitalizeFirst,
              style: AppStyles.appFontMedium.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: LoadingMoreList<NewUserZoneDatum>(
              ListConfig<NewUserZoneDatum>(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                indicatorBuilder: BuildIndicatorBuilder(
                  source: source,
                  isSliver: false,
                  name: 'Products'.tr,
                ).buildIndicator,
                showGlowLeading: true,
                extendedListDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder:
                    (BuildContext c, NewUserZoneDatum prod, int index) {
                  return GridViewProductWidget(productModel: prod.product);
                },
                sourceList: source,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewUserZoneAllProductsLoadMore extends LoadingMoreBase<NewUserZoneDatum> {
  final NewUserZoneController newUserZoneController =
      Get.put(NewUserZoneController());

  int pageindex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;

  @override
  bool get hasMore =>
      (_hasMore &&
          length <
              newUserZoneController
                  .newZone.value.newUserZone.allProducts.total) ||
      forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageindex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    final NewUserZoneController newUserZoneController =
        Get.put(NewUserZoneController());

    Dio _dio = Dio();

    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      // await Future.delayed(Duration(milliseconds: 500));
      var result;

      var encoded = Uri.encodeFull(URLs.fetchNewUserProductData(
          newUserZoneController.newUserZoneSlug.value));
      if (this.length == 0) {
        result = await _dio.get(Uri.decodeFull(encoded), queryParameters: {
          'item': 'product',
        });
      } else {
        result = await _dio.get(Uri.decodeFull(encoded), queryParameters: {
          'page': pageindex,
          'item': 'product',
        });
      }
      print(result.realUri);

      final data = new Map<String, dynamic>.from(result.data);
      var source = NewUserZoneAllProducts.fromJson(data);

      if (pageindex == 1) {
        this.clear();
      }
      for (var item in source.data) {
        this.add(item);
      }

      _hasMore = source.data.length != 0;
      pageindex++;
      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}
