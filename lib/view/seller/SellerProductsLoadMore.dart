import 'package:amazy_app/controller/seller_profile_controller.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/model/Seller/SellerProductApi.dart';
import 'package:amazy_app/model/Seller/SellerProfileModel.dart';
import 'package:amazy_app/model/SellerFilterModel.dart';
import 'package:amazy_app/network/config.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

class SellerProductsLoadMore extends LoadingMoreBase<ProductModel> {
  final int sellerId;

  SellerProductsLoadMore(this.sellerId);

  bool isSorted;
  String sortKey = 'new';
  bool isFilter;

  SellerProfileController controller;

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
    print('loading....');
    controller = Get.put(SellerProfileController(sellerId));
    Dio _dio = Dio();

    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      await Future.delayed(Duration(milliseconds: 500));
      var result;
      var source;

      if (!isSorted && !isFilter) {
        if (this.length == 0) {
          result = await _dio.get(URLs.SELLER_PROFILE + '/$sellerId');
        } else {
          result = await _dio
              .get(URLs.SELLER_PROFILE + '/$sellerId', queryParameters: {
            'page': pageIndex,
          });
        }
        print('URI IS ${result.realUri}');
        final data = new Map<String, dynamic>.from(result.data);
        source = SellerProfileModel.fromJson(data);
        productsLength = source.seller.sellerProductsApi.total;
        print('INITIALIZED PRODUCT LENGTH $productsLength');
      } 
      if (isSorted && !isFilter) {
        if (this.length == 0) {
          result = await _dio.get(URLs.SORT_PRODUCTS, queryParameters: {
            'sort_by': sortKey,
            'paginate': 9,
            'requestItem': sellerId,
            'requestItemType': 'seller',
          });
        } else {
          result = await _dio.get(URLs.SORT_PRODUCTS, queryParameters: {
            'sort_by': sortKey,
            'paginate': 9,
            'requestItem': sellerId,
            'requestItemType': 'seller',
            'page': pageIndex,
          });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = SellerProductsApi.fromJson(data);
        productsLength = data['meta']['total'];
        print('SORT BY PRODUCT LENGTH $productsLength');
      } 
      if (isFilter && isSorted) {
        controller.sellerFilter.value.filterType.removeWhere((element) =>
            element.filterTypeValue.length == 0 &&
            element.filterTypeId != 'cat');

        controller.sellerFilter.value.sortBy =
            controller.filterSortKey.value.toString();

        controller.sellerFilter.value.page = pageIndex;

        print(sellerFilterModelToJson(controller.sellerFilter.value));

        if (this.length == 0) {
          print(controller.sellerFilter.toJson());
          result = await _dio.post(
            URLs.FILTER_SELLER_PRODUCTS,
            data: sellerFilterModelToJson(controller.sellerFilter.value),
          );
        } else {
          print(controller.sellerFilter.toJson());
          result = await _dio.post(
            URLs.FILTER_SELLER_PRODUCTS,
            data: sellerFilterModelToJson(controller.sellerFilter.value),
          );
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = SellerProductsApi.fromJson(data['products']);
        productsLength = data['products']['total'];
        print('FILTERED $productsLength');
      }

      if (pageIndex == 1) {
        this.clear();
      }

      if (!isSorted && !isFilter) {
        for (var item in source.seller.sellerProductsApi.data) {
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
        _hasMore = source.seller.sellerProductsApi.data != 0;
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