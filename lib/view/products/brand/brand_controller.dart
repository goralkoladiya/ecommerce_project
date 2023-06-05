import 'package:amazy_app/model/Brand/BrandData.dart';
import 'package:amazy_app/model/Brand/SingleBrandModel.dart';
import 'package:amazy_app/model/Category/CategoryData.dart';
import 'package:amazy_app/model/Category/ParentCategory.dart';
import 'package:amazy_app/model/Filter/FilterAttributeValue.dart';
import 'package:amazy_app/model/Filter/FilterColor.dart';
import 'package:amazy_app/model/FilterFromCatModel.dart';
import 'package:amazy_app/model/Product/AllProducts.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/network/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandController extends GetxController {
  BrandController({this.bId});
  final int bId;
  Dio _dio = Dio();

  var allBrands = <BrandData>[].obs;

  var allBrandProducts = <ProductModel>[].obs;
  var isBrandsLoading = false.obs;
  var isBrandsProductsLoading = false.obs;
  var brandTitle = "".obs;
  var brandId = 0.obs;
  var brandImage = "".obs;
  var lastBrandPage = false.obs;
  var brandPageNumber = 1.obs;
  var isMoreBrandLoading = false.obs;
  var dataFilterCat = FilterFromCatModel().obs;
  var filterPageNumber = 1.obs;
  var filterSortKey = 'new'.obs;
  var filterRating = 0.0.obs;
  var subCatsInBrands = <CategoryData>[].obs;
  List<FilterAttributeValue> selectedAttribute = [];

  List<FilterColorValue> selectedColorValue = [];
  var subCatFilter = FilterType(filterTypeId: 'cat', filterTypeValue: []).obs;
  var brandFilter = FilterType(filterTypeId: 'brand', filterTypeValue: []).obs;
  var attributeFilter = FilterType(filterTypeId: '', filterTypeValue: []).obs;

  var attFilters = <FilterType>[].obs;

  var selectedSubCat = <ParentCategory>[].obs;
  var selectedBrandCat = <CategoryData>[].obs;
  List<FilterAttributeValue> selectedBrandAttribute = [];
  List<FilterColorValue> selectedBrandColorValue = [];

  var brandAllData = SingleBrandModel().obs;
  final TextEditingController lowRangeBrandCtrl = TextEditingController();
  final TextEditingController highRangeBrandCtrl = TextEditingController();

  /// -----------------
  /// ----- BRAND -----
  /// -----------------
  ///
  ///

  Future<List<ProductModel>> getBrandProducts() async {
    BrandData allBrandModelDatum = BrandData();
    try {
      isBrandsProductsLoading(true);
      isMoreBrandLoading(true);
      await _dio.get(URLs.ALL_BRAND + '/$brandId', queryParameters: {
        'page': brandPageNumber,
      }).then((value) {
        print('Brand Query: ${value.realUri}');
        final data = new Map<String, dynamic>.from(value.data);

        brandAllData.value = SingleBrandModel.fromJson(value.data);

        print('Brand ID ${brandId.value.toString()}');

        dataFilterCat.value = FilterFromCatModel(
          filterDataFromCat: FilterDataFromCat(
            requestItem: brandId.value.toString(),
            requestItemType: 'brand',
            filterType: [],
          ),
          requestItemType: 'brand',
          requestItem: brandId.value.toString(),
          sortBy: filterSortKey.value.toString(),
          page: filterPageNumber.value.toString(),
        );

        if (brandAllData.value.attributes != null &&
            brandAllData.value.attributes.length > 0) {
          brandAllData.value.attributes.forEach((element) {
            dataFilterCat.value.filterDataFromCat.filterType.add(FilterType(
                filterTypeId: element.id.toString(), filterTypeValue: []));
          });
        }

        if (brandAllData.value.categories != null &&
            brandAllData.value.categories.length > 0) {
          dataFilterCat.value.filterDataFromCat.filterType
              .add(FilterType(filterTypeId: 'cat', filterTypeValue: []));
        }

        if (brandAllData.value.heightPrice != null &&
            brandAllData.value.lowestPrice != null) {
          dataFilterCat.value.filterDataFromCat.filterType.add(
              FilterType(filterTypeId: 'price_range', filterTypeValue: []));
        }

        dataFilterCat.value.filterDataFromCat.filterType
            .add(FilterType(filterTypeId: 'rating', filterTypeValue: []));

        lowRangeBrandCtrl.text = brandAllData.value.lowestPrice == null
            ? 0.toString()
            : brandAllData.value.lowestPrice.toString();
        highRangeBrandCtrl.text = brandAllData.value.heightPrice == null
            ? 0.toString()
            : brandAllData.value.heightPrice.toString();

        allBrandModelDatum = BrandData.fromJson(data['data']);
        print(allBrandModelDatum);
        brandTitle.value = allBrandModelDatum.name;
        brandId.value = allBrandModelDatum.id;
        brandImage.value = allBrandModelDatum.logo;
        if (allBrandModelDatum.allProducts.data.length == 0) {
          isMoreBrandLoading(false);
          lastBrandPage(true);
        } else {
          isMoreBrandLoading(true);
          allBrandProducts.addAll(allBrandModelDatum.allProducts.data);
        }
      });
    } catch (e) {
      isBrandsProductsLoading(false);
      print(e.toString());
    } finally {
      isBrandsProductsLoading(false);
      isMoreBrandLoading(false);
    }
    return allBrandProducts;
  }

  Future<SingleBrandModel> getBrandFilterData() async {
    try {
      await _dio.get(URLs.ALL_BRAND + '/$brandId', queryParameters: {
        'page': brandPageNumber,
      }).then((value) {
        print('URL: ${value.realUri.queryParameters}');
        brandAllData.value = SingleBrandModel.fromJson(value.data);

        print('Filter Brand ID ${brandId.value.toString()}');

        if (brandAllData.value.categories.length != 0) {
          brandAllData.value.categories.forEach((element) {
            subCatsInBrands.add(element);
          });
        }
      });
    } catch (e) {
      // isProductsLoading(false);
      print(e.toString());
    } finally {
      // isProductsLoading(false);
      // isMoreLoading(false);
    }
    return brandAllData.value;
  }

  Future<List<ProductModel>> filterBrandProducts() async {
    // print(filterFromCatModelToJson(dataFilter.value));

    dataFilterCat.value.filterDataFromCat.filterType.removeWhere((element) =>
        element.filterTypeValue.length == 0 && element.filterTypeId != 'cat');

    dataFilterCat.value.page = filterPageNumber.value.toString();

    dataFilterCat.value.sortBy = filterSortKey.value.toString();

    print(filterFromCatModelToJson(dataFilterCat.value));

    print(URLs.FILTER_ALL_PRODUCTS);
    AllProducts parentCategoryElement = AllProducts();
    try {
      isBrandsProductsLoading(true);
      isMoreBrandLoading(true);
      await _dio
          .post(URLs.FILTER_ALL_PRODUCTS,
              data: filterFromCatModelToJson(dataFilterCat.value))
          .then((value) {
        parentCategoryElement = AllProducts.fromJson(value.data);
        print(parentCategoryElement.data.length);

        if (parentCategoryElement.data.length == 0) {
          isMoreBrandLoading(false);
          lastBrandPage(true);
        } else {
          isMoreBrandLoading(true);
          allBrandProducts.addAll(parentCategoryElement.data);
        }
      });
    } catch (e) {
      isBrandsProductsLoading(false);
      print(e.toString());
    } finally {
      isBrandsProductsLoading(false);
      isMoreBrandLoading(false);
    }
    return allBrandProducts;
  }

  Future addBrandFilterAttribute(
      {FilterAttributeValue value,
      typeId,
      bool isColor,
      FilterColorValue colorValue}) async {
    if (isColor) {
      final addAttributeData = dataFilterCat.value.filterDataFromCat.filterType
          .firstWhere(
              (element) => element.filterTypeId.toString() == typeId.toString(),
              orElse: addIfNoBrandAttribute(
                  isColor: true, colorValue: colorValue, typeId: typeId));
      addAttributeData.filterTypeValue.add(colorValue.id.toString());
    } else {
      final addAttributeData = dataFilterCat.value.filterDataFromCat.filterType
          .firstWhere(
              (element) => element.filterTypeId.toString() == typeId.toString(),
              orElse: addIfNoBrandAttribute(
                  value: value, typeId: typeId, isColor: false));
      addAttributeData.filterTypeValue.add(value.id.toString());
    }

    print('ADD ${dataFilterCat.value.toJson()}');
  }

  addIfNoBrandAttribute(
      {FilterAttributeValue value,
      typeId,
      FilterColorValue colorValue,
      bool isColor}) {
    dataFilterCat.value.filterDataFromCat.filterType
        .add(FilterType(filterTypeId: typeId.toString(), filterTypeValue: []));
  }

  Future removeBrandFilterAttribute(
      {FilterAttributeValue value,
      typeId,
      bool isColor,
      FilterColorValue colorValue}) async {
    if (isColor) {
      dataFilterCat.value.filterDataFromCat.filterType.forEach((element) {
        if (element.filterTypeId == typeId.toString()) {
          element.filterTypeValue.remove(colorValue.id.toString());
        }
      });
    } else {
      dataFilterCat.value.filterDataFromCat.filterType.forEach((element) {
        if (element.filterTypeId == typeId.toString()) {
          element.filterTypeValue.remove(value.id.toString());
        }
      });
    }

    print('REMOVE ${dataFilterCat.value.toJson()}');
  }

  @override
  void onInit() {
    brandId.value = bId;
    allBrandProducts.clear();
    subCatsInBrands.clear();
    lastBrandPage.value = false;
    brandPageNumber.value = 1;
    getBrandProducts();
    getBrandFilterData();

    if (dataFilterCat.value.filterDataFromCat != null) {
      dataFilterCat.value.filterDataFromCat.filterType.forEach((element) {
        if (element.filterTypeId == 'brand' || element.filterTypeId == 'cat') {
          print(element.filterTypeId);
          element.filterTypeValue.clear();
        }
      });
    }

    super.onInit();
  }
}
