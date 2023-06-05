import 'dart:developer';

import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/model/Brand/BrandData.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/model/SellerFilterModel.dart';
import 'package:amazy_app/model/Seller/SellerProfileModel.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SellerProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final int sellerId;

  SellerProfileController(this.sellerId);

  var isLoading = false.obs;

  var seller = SellerProfileModel().obs;

  var recentProductsList = <ProductModel>[].obs;

  var scaffoldKey = GlobalKey<ScaffoldState>().obs;

  final TextEditingController lowRangeCatCtrl = TextEditingController();
  final TextEditingController highRangeCatCtrl = TextEditingController();

  var filterPageNumber = 1.obs;
  var filterSortKey = 'new'.obs;
  var filterRating = 1.0.obs;

  var sellerFilter = SellerFilterModel().obs;
  var subCatFilter = FilterType(filterTypeId: 'cat', filterTypeValue: []).obs;
  var brandFilter = FilterType(filterTypeId: 'brand', filterTypeValue: []).obs;

  List<String> listCategories = [];
  List<String> listBrands = [];

  var attFilters = <FilterType>[].obs;

  var selectedSubCat = <CategoryList>[].obs;

  var selectedBrand = <BrandData>[].obs;

  var sellerRating = 0.0.obs;

  void updateFiltering() {
    if (listBrands.length == 0) {
      sellerFilter.value.filterType
          .removeWhere((element) => element.filterTypeId == "brand");
    } else {
      brandFilter.value.filterTypeValue = listBrands;
      sellerFilter.value.filterType.add(brandFilter.value);
    }
    if (listCategories.length == 0) {
      sellerFilter.value.filterType
          .removeWhere((element) => element.filterTypeId == "cat");
    } else {
      subCatFilter.value.filterTypeValue = listCategories;
      sellerFilter.value.filterType.add(subCatFilter.value);
    }

    update();
  }

  Future fetchSellerProfile(id) async {
    log("${URLs.SELLER_PROFILE + '/$id'}");
    try {
      Uri userData = Uri.parse(URLs.SELLER_PROFILE + '/$id');
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      return sellerProfileModelFromJson(response.body.toString());
    } catch (e) {
      print(e);
    }
    // return ProductDetailsModel();
  }

  Future getSellerProfile(id) async {
    try {
      isLoading(true);
      var data = await fetchSellerProfile(id);
      if (data != null) {
        seller.value = data;

        recentProductsList
            .addAll(seller.value.seller.sellerProductsApi.data.reversed);

        sellerFilter.value = SellerFilterModel(
          filterType: [],
          sellerId: seller.value.seller.id,
          sortBy: filterSortKey.value,
          paginate: 10,
          page: filterPageNumber.value,
        );

        if (seller.value.heightPrice != null &&
            seller.value.lowestPrice != null) {
          sellerFilter.value.filterType.add(
              FilterType(filterTypeId: 'price_range', filterTypeValue: []));
        }

        sellerFilter.value.filterType
            .add(FilterType(filterTypeId: 'rating', filterTypeValue: []));

        lowRangeCatCtrl.text = seller.value.lowestPrice == null
            ? 0.toString()
            : seller.value.lowestPrice.toString();
        highRangeCatCtrl.text = seller.value.heightPrice == null
            ? 0.toString()
            : seller.value.heightPrice.toString();

        var rating = 0.0;
        seller.value.seller.sellerReviews.forEach((element) {
          rating += element.rating;
        });
        sellerRating.value = rating;
      } else {
        seller.value = SellerProfileModel();
      }
    } catch (e) {
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  TabController tabController;

  final List<Tab> myTabs = <Tab>[
    Tab(
      child: Text(
        'Homepage'.tr,
        style: AppStyles.appFontBook,
      ),
    ),
    Tab(
      child: Text(
        'All Products'.tr,
        style: AppStyles.appFontBook,
      ),
    ),
    Tab(
      child: Text(
        'Profile'.tr,
        style: AppStyles.appFontBook,
      ),
    ),
    // Tab(text: 'Quiz'.tr),
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: myTabs.length);

    tabController.index = 0;
    getSellerProfile(sellerId);

    // if (sellerFilter.value.filterType != null) {
    //   sellerFilter.value.filterType.forEach((element) {
    //     if (element.filterTypeId == 'brand' || element.filterTypeId == 'cat') {
    //       print(element.filterTypeId);
    //       element.filterTypeValue.clear();
    //     }
    //   });
    // }
    filterRating.value = 1.0;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
