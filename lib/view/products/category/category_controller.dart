import 'package:amazy_app/model/Brand/BrandData.dart';
import 'package:amazy_app/model/Category/CategoryData.dart';
import 'package:amazy_app/model/Category/ParentCategory.dart';
import 'package:amazy_app/model/Category/SingleCategory.dart';
import 'package:amazy_app/model/Filter/FilterAttributeValue.dart';
import 'package:amazy_app/model/Filter/FilterColor.dart';
import 'package:amazy_app/model/FilterFromCatModel.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/network/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  CategoryController(this.cId);
  final int cId;

  ScrollController scrollController = ScrollController();

  Rx<bool> forceR = false.obs;

  Dio _dio = Dio();

  ///Category vars
  var allCategory = <CategoryData>[].obs;

  var allCategoryList = <CategoryData>[].obs;

  // ignore: deprecated_member_use
  var category = CategoryData().obs;
  var catAllData = SingleCategory().obs;
  var dataFilterCat = FilterFromCatModel().obs;
  var dataFilterBrand = FilterFromCatModel().obs;
  var filterTypeList = <FilterType>[].obs;

  var allProds = <ProductModel>[].obs;
  var isLoading = false.obs;
  var isProductsLoading = false.obs;
  var categoryTitle = "".obs;
  var categoryId = 0.obs;
  var categoryImage = "".obs;
  var lastPage = false.obs;
  var pageNumber = 1.obs;
  var isMoreLoading = false.obs;
  var categoryIdBeforeFilter = 0.obs;

  var subCats = <ParentCategory>[].obs;

  var subCatsInBrands = <CategoryData>[].obs;

  var subCatFilter = FilterType(filterTypeId: 'cat', filterTypeValue: []).obs;
  var brandFilter = FilterType(filterTypeId: 'brand', filterTypeValue: []).obs;
  var attributeFilter = FilterType(filterTypeId: '', filterTypeValue: []).obs;

  var attFilters = <FilterType>[].obs;

  var selectedSubCat = <ParentCategory>[].obs;

  var selectedBrands = <BrandData>[].obs;
  var filterPageNumber = 1.obs;
  var filterSortKey = 'new'.obs;
  var filterRating = 0.0.obs;

  List<FilterAttributeValue> selectedAttribute = [];

  List<FilterColorValue> selectedColorValue = [];

  var selectedBrandCat = <CategoryData>[].obs;
  List<FilterAttributeValue> selectedBrandAttribute = [];
  List<FilterColorValue> selectedBrandColorValue = [];

  final TextEditingController lowRangeCatCtrl = TextEditingController();
  final TextEditingController highRangeCatCtrl = TextEditingController();

  Future addFilterAttribute(
      {FilterAttributeValue value,
      typeId,
      bool isColor,
      FilterColorValue colorValue}) async {
    if (isColor) {
      final addAttributeData = dataFilterCat.value.filterDataFromCat.filterType
          .firstWhere(
              (element) => element.filterTypeId.toString() == typeId.toString(),
              orElse: addIfNoAttribute(
                  isColor: true, colorValue: colorValue, typeId: typeId));
      addAttributeData.filterTypeValue.add(colorValue.id.toString());
    } else {
      final addAttributeData = dataFilterCat.value.filterDataFromCat.filterType
          .firstWhere(
              (element) => element.filterTypeId.toString() == typeId.toString(),
              orElse: addIfNoAttribute(
                  value: value, typeId: typeId, isColor: false));
      addAttributeData.filterTypeValue.add(value.id.toString());
    }

    print('ADD ${dataFilterCat.value.toJson()}');
  }

  addIfNoAttribute(
      {FilterAttributeValue value,
      typeId,
      FilterColorValue colorValue,
      bool isColor}) {
    dataFilterCat.value.filterDataFromCat.filterType
        .add(FilterType(filterTypeId: typeId.toString(), filterTypeValue: []));
  }

  Future removeFilterAttribute(
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

  Future<List<ProductModel>> getCategoryProducts() async {
    CategoryData parentCategoryElement = CategoryData();
    try {
      isProductsLoading(true);
      isMoreLoading(true);
      await _dio.get(URLs.ALL_CATEGORY + '/$categoryId', queryParameters: {
        'page': pageNumber,
      }).then((value) {
        print('URL: ${value.realUri}');
        final data = new Map<String, dynamic>.from(value.data);
        catAllData.value = SingleCategory.fromJson(value.data);

        print('catAllData.value ${catAllData.value}');

        print(
            'catAllData.value len  ${catAllData.value.data.allProducts.data.length}');

        print('Cat ID ${categoryId.value.toString()}');

        dataFilterCat.value = FilterFromCatModel(
          filterDataFromCat: FilterDataFromCat(
            requestItem: categoryId.value.toString(),
            requestItemType: 'category',
            filterType: [],
          ),
          requestItemType: 'category',
          requestItem: categoryId.value.toString(),
          sortBy: filterSortKey.value.toString(),
          page: filterPageNumber.value.toString(),
        );

        if (catAllData.value.attributes.length > 0) {
          catAllData.value.attributes.forEach((element) {
            dataFilterCat.value.filterDataFromCat.filterType.add(FilterType(
                filterTypeId: element.id.toString(), filterTypeValue: []));
          });
        }

        if (catAllData.value.brands.length > 0) {
          dataFilterCat.value.filterDataFromCat.filterType
              .add(FilterType(filterTypeId: 'brand', filterTypeValue: []));
        }
        if (catAllData.value.data.subCategories.length > 0) {
          dataFilterCat.value.filterDataFromCat.filterType
              .add(FilterType(filterTypeId: 'cat', filterTypeValue: []));
        }

        if (catAllData.value.heightPrice != null &&
            catAllData.value.lowestPrice != null) {
          dataFilterCat.value.filterDataFromCat.filterType.add(
              FilterType(filterTypeId: 'price_range', filterTypeValue: []));
        }

        dataFilterCat.value.filterDataFromCat.filterType
            .add(FilterType(filterTypeId: 'rating', filterTypeValue: []));

        lowRangeCatCtrl.text = catAllData.value.lowestPrice == null
            ? 0.toString()
            : catAllData.value.lowestPrice.toString();
        highRangeCatCtrl.text = catAllData.value.heightPrice == null
            ? 0.toString()
            : catAllData.value.heightPrice.toString();

        parentCategoryElement = CategoryData.fromJson(data['data']);
        category.value = parentCategoryElement;
        categoryTitle.value = parentCategoryElement.name;
        categoryId.value = parentCategoryElement.id;
        categoryImage.value = parentCategoryElement.categoryImage.image;
        if (parentCategoryElement.allProducts.data.length == 0) {
          isMoreLoading(false);
          lastPage(true);
        } else {
          isMoreLoading(true);
          allProds.addAll(parentCategoryElement.allProducts.data);
        }
        if (parentCategoryElement.subCategories.length == 0) {
          isMoreLoading(false);
          lastPage(true);
        } else {
          isMoreLoading(true);
        }
      });
    } catch (e) {
      isProductsLoading(false);
      print(e.toString());
    } finally {
      isProductsLoading(false);
      isMoreLoading(false);
    }
    return allProds;
  }

  Future<SingleCategory> getCategoryFilterData() async {
    try {
      // isProductsLoading(true);
      // isMoreLoading(true);
      await _dio.get(URLs.ALL_CATEGORY + '/$categoryId', queryParameters: {
        'page': pageNumber,
      }).then((value) {
        print('URL: ${value.realUri.queryParameters}');
        print('URL: ${value.realUri}');
        catAllData.value = SingleCategory.fromJson(value.data);

        print('Filter Cat ID ${categoryId.value.toString()}');

        catAllData.value.data.subCategories.forEach((element) {
          subCats.add(element);
          element.subCategories.forEach((element2) {
            subCats.add(element2);
          });
        });
      });
    } catch (e) {
      // isProductsLoading(false);
      print(e.toString());
    } finally {
      // isProductsLoading(false);
      // isMoreLoading(false);
    }
    return catAllData.value;
  }

  @override
  void onInit() {
    categoryId.value = cId;
    categoryIdBeforeFilter.value = cId;
    allProds.clear();
    subCats.clear();
    lastPage.value = false;
    pageNumber.value = 1;
    category.value = CategoryData();
    catAllData.value = SingleCategory();
    // controller.dataFilter.value =
    //     FilterFromCatModel();
    getCategoryProducts();
    getCategoryFilterData();
    if (dataFilterCat.value.filterDataFromCat != null) {
      dataFilterCat.value.filterDataFromCat.filterType.forEach((element) {
        if (element.filterTypeId == 'brand' || element.filterTypeId == 'cat') {
          print(element.filterTypeId);
          element.filterTypeValue.clear();
        }
      });
    }
    filterRating.value = 0.0;
    super.onInit();
  }
  
}
