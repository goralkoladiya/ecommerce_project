import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/Brand/BrandData.dart';

import 'package:amazy_app/model/Category/ParentCategory.dart';
import 'package:amazy_app/model/Filter/FilterAttributeValue.dart';
import 'package:amazy_app/model/Filter/FilterColor.dart';

import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/category/category_controller.dart';
import 'package:amazy_app/widgets/PinkButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:amazy_app/widgets/BlueButtonWidget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'ProductsByCategory.dart';

class CategoryFilterDrawer extends StatefulWidget {
  final int categoryID;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final CategoryProductsLoadMore source;

  CategoryFilterDrawer({this.categoryID, this.scaffoldKey, this.source});

  @override
  _CategoryFilterDrawerState createState() => _CategoryFilterDrawerState();
}

class _CategoryFilterDrawerState extends State<CategoryFilterDrawer> {
  CategoryController controller;
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  RangeValues _currentRangeValues;
  bool showRange = false;

  double _lowerValue = 0.0;
  double _upperValue = 0.0;

  @override
  void initState() {
    controller = Get.put(CategoryController(widget.categoryID));
    if (controller.catAllData.value.lowestPrice != null &&
        (double.parse(controller.catAllData.value.lowestPrice) < double.parse(controller.catAllData.value.heightPrice))) {
      showRange = true;

      _lowerValue = double.parse(controller.catAllData.value.lowestPrice);
      _upperValue = double.parse(controller.catAllData.value.heightPrice);

      print('LOW PRICE $_lowerValue');
      print('HIGH PRICE $_upperValue');

      _currentRangeValues = RangeValues(_lowerValue, _upperValue);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width * 0.7,
      child: Scaffold(
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                'Filter Products'.tr,
                style: AppStyles.kFontBlack14w5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            //Category
            controller.subCats.length > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppStyles.textFieldFillColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Child Category'.tr,
                          style: AppStyles.kFontBlack12w4,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                : Container(),
            controller.subCats.length > 0
                ? Builder(
                    builder: (context) {
                      final _items = controller.subCats
                          .map((category) => MultiSelectItem<ParentCategory>(
                              category, category.name))
                          .toList();
                      return MultiSelectChipField<ParentCategory>(
                        items: _items,
                        scroll: false,
                        searchable: false,
                        showHeader: false,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white)),
                        itemBuilder: (item, state) {
                          return Card(
                            color:
                                controller.selectedSubCat.contains(item.value)
                                    ? AppStyles.darkBlueColor
                                    : Colors.white,
                            elevation:
                                controller.selectedSubCat.contains(item.value)
                                    ? 5
                                    : 3,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Container(
                              height: 30,
                              child: MaterialButton(
                                onPressed: () async {
                                  state.didChange(controller.selectedSubCat);

                                  if (controller.selectedSubCat
                                      .contains(item.value)) {
                                    controller.selectedSubCat
                                        .remove(item.value);

                                    controller
                                        .subCatFilter.value.filterTypeValue
                                        .remove(item.value.id.toString());

                                    controller.dataFilterCat.value
                                        .filterDataFromCat.filterType
                                        .where((element) =>
                                            element.filterTypeId == 'cat')
                                        .toList()
                                        .remove(controller.subCatFilter.value);

                                    await doFilter();
                                  } else {
                                    controller.selectedSubCat.add(item.value);
                                    controller
                                        .subCatFilter.value.filterTypeValue
                                        .add(item.value.id.toString());

                                    controller.dataFilterCat.value
                                        .filterDataFromCat.filterType
                                        .add(controller.subCatFilter.value);

                                    await doFilter();
                                  }
                                },
                                child: Text(item.value.name,
                                    style: controller.selectedSubCat
                                            .contains(item.value)
                                        ? AppStyles.kFontWhite14w5
                                        : AppStyles.kFontBlack14w5),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Container(),

            controller.catAllData.value.brands.length > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppStyles.textFieldFillColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Brands'.tr,
                          style: AppStyles.kFontBlack12w4,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  )
                : Container(),

            controller.catAllData.value.brands.length > 0
                ? Builder(
                    builder: (context) {
                      final _items = controller.catAllData.value.brands
                          .map((brandItem) => MultiSelectItem<BrandData>(
                              brandItem, brandItem.name))
                          .toList();
                      return MultiSelectChipField<BrandData>(
                        items: _items,
                        scroll: false,
                        searchable: false,
                        showHeader: false,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white)),
                        itemBuilder: (item, state) {
                          return Card(
                            color:
                                controller.selectedBrands.contains(item.value)
                                    ? AppStyles.darkBlueColor
                                    : Colors.white,
                            elevation:
                                controller.selectedBrands.contains(item.value)
                                    ? 5
                                    : 3,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Container(
                              height: 30,
                              child: MaterialButton(
                                onPressed: () async {
                                  state.didChange(controller.selectedBrands);
                                  if (controller.selectedBrands
                                      .contains(item.value)) {
                                    controller.selectedBrands
                                        .remove(item.value);
                                    controller.brandFilter.value.filterTypeValue
                                        .remove(item.value.id.toString());
                                    controller.dataFilterCat.value
                                        .filterDataFromCat.filterType
                                        .where((element) =>
                                            element.filterTypeId == 'brand')
                                        .toList()
                                        .remove(controller.brandFilter.value);

                                    await doFilter();
                                  } else {
                                    controller.selectedBrands.add(item.value);
                                    controller.brandFilter.value.filterTypeValue
                                        .add(item.value.id.toString());
                                    controller.dataFilterCat.value
                                        .filterDataFromCat.filterType
                                        .add(controller.brandFilter.value);

                                    await doFilter();
                                  }
                                },
                                child: Text(item.value.name,
                                    style: controller.selectedBrands
                                            .contains(item.value)
                                        ? AppStyles.kFontWhite14w5
                                        : AppStyles.kFontBlack14w5),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Container(),

            controller.catAllData.value.attributes.length > 0
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.catAllData.value.attributes.length,
                    itemBuilder: (context, attIndex) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: AppStyles.textFieldFillColor,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  '${controller.catAllData.value.attributes[attIndex].name}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          controller.catAllData.value.attributes[attIndex]
                                      .values.length >
                                  0
                              ? Builder(
                                  builder: (context) {
                                    final _items = controller.catAllData.value
                                        .attributes[attIndex].values
                                        .map((attribute) => MultiSelectItem<
                                                FilterAttributeValue>(
                                            attribute, attribute.value))
                                        .toList();
                                    return MultiSelectChipField<
                                        FilterAttributeValue>(
                                      items: _items,
                                      scroll: false,
                                      searchable: false,
                                      showHeader: false,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.white)),
                                      itemBuilder: (item, state) {
                                        return Card(
                                          color: controller.selectedAttribute
                                                  .contains(item.value)
                                              ? AppStyles.darkBlueColor
                                              : Colors.white,
                                          elevation: controller
                                                  .selectedAttribute
                                                  .contains(item.value)
                                              ? 5
                                              : 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: Container(
                                            height: 30,
                                            constraints:
                                                BoxConstraints(maxWidth: 200),
                                            child: MaterialButton(
                                              onPressed: () async {
                                                state.didChange(controller
                                                    .selectedAttribute);

                                                if (controller.selectedAttribute
                                                    .contains(item.value)) {
                                                  controller.selectedAttribute
                                                      .remove(item.value);

                                                  await controller
                                                      .removeFilterAttribute(
                                                          isColor: false,
                                                          value: item.value,
                                                          typeId: controller
                                                              .catAllData
                                                              .value
                                                              .attributes[
                                                                  attIndex]
                                                              .id
                                                              .toString());

                                                  await doFilter();
                                                } else {
                                                  controller.selectedAttribute
                                                      .add(item.value);
                                                  await controller
                                                      .addFilterAttribute(
                                                          isColor: false,
                                                          value: item.value,
                                                          typeId: controller
                                                              .catAllData
                                                              .value
                                                              .attributes[
                                                                  attIndex]
                                                              .id
                                                              .toString());

                                                  await doFilter();
                                                }
                                              },
                                              child: Text(item.value.value,
                                                  style: controller
                                                          .selectedAttribute
                                                          .contains(item.value)
                                                      ? AppStyles.kFontWhite14w5
                                                      : AppStyles
                                                          .kFontBlack14w5),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )
                              : Container(),
                        ],
                      );
                    })
                : Container(),

            //Color
            controller.catAllData.value.color != null
                ? controller.catAllData.value.color.values.length > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: AppStyles.textFieldFillColor,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(
                              'Color'.tr,
                              style: AppStyles.kFontBlack12w4,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      )
                    : Container()
                : Container(),

            controller.catAllData.value.color != null
                ? controller.catAllData.value.color.values.length > 0
                    ? Builder(
                        builder: (context) {
                          final _items = controller
                              .catAllData.value.color.values
                              .map((attribute) =>
                                  MultiSelectItem<FilterColorValue>(
                                      attribute, attribute.value))
                              .toList();
                          return MultiSelectChipField<FilterColorValue>(
                            items: _items,
                            scroll: false,
                            searchable: false,
                            showHeader: false,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.white)),
                            itemBuilder: (item, state) {
                              var bgColor = 0;
                              if (!item.value.value.contains('#')) {
                                bgColor =
                                    AppStyles.colourNameToHex(item.value.value);
                              } else {
                                bgColor =
                                    AppStyles.getBGColor(item.value.value);
                              }
                              return Container(
                                height: 30,
                                constraints: BoxConstraints(maxWidth: 200),
                                child: GestureDetector(
                                  onTap: () async {
                                    state.didChange(
                                        controller.selectedColorValue);
                                    if (controller.selectedColorValue
                                        .contains(item.value)) {
                                      controller.selectedColorValue
                                          .remove(item.value);
                                      await controller.removeFilterAttribute(
                                          isColor: true,
                                          colorValue: item.value,
                                          typeId: controller
                                              .catAllData.value.color.id
                                              .toString());
                                      await doFilter();
                                    } else {
                                      controller.selectedColorValue
                                          .add(item.value);

                                      await controller.addFilterAttribute(
                                          isColor: true,
                                          colorValue: item.value,
                                          typeId: controller
                                              .catAllData.value.color.id
                                              .toString());
                                      await doFilter();
                                    }
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 2),
                                            decoration: BoxDecoration(
                                                color: Color(bgColor),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  width: controller
                                                          .selectedColorValue
                                                          .contains(item.value)
                                                      ? 3
                                                      : 0.1,
                                                  color: controller
                                                          .selectedColorValue
                                                          .contains(item.value)
                                                      ? Colors.pink
                                                      : Colors.black,
                                                )),
                                          ),
                                        ),
                                        controller.selectedColorValue
                                                .contains(item.value)
                                            ? Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Container()
                : Container(),

            //Price Range
            showRange
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppStyles.textFieldFillColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Price Range'.tr +
                              ' (${currencyController.appCurrency.value})',
                          style: AppStyles.kFontBlack12w4,
                        ),
                      ),
                    ],
                  )
                : Container(),

            showRange
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: FlutterSlider(
                      values: [_lowerValue + 1, _upperValue - 1],
                      rangeSlider: true,
                      handler: FlutterSliderHandler(
                        decoration: BoxDecoration(),
                        child: Material(
                          type: MaterialType.circle,
                          color: AppStyles.pinkColor,
                          elevation: 3,
                          child: Container(
                              child: Icon(
                            Icons.circle,
                            size: 25,
                            color: AppStyles.pinkColor,
                          )),
                        ),
                      ),
                      rightHandler: FlutterSliderHandler(
                        decoration: BoxDecoration(),
                        child: Material(
                          type: MaterialType.circle,
                          color: AppStyles.pinkColor,
                          elevation: 3,
                          child: Container(
                              child: Icon(
                            Icons.circle,
                            size: 25,
                            color: AppStyles.pinkColor,
                          )),
                        ),
                      ),
                      trackBar: FlutterSliderTrackBar(
                        inactiveTrackBar: BoxDecoration(
                          color: AppStyles.mediumPinkColor,
                          // border: Border.all(width: 3, color: Colors.blue),
                        ),
                        activeTrackBar: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppStyles.pinkColor,
                        ),
                      ),
                      hatchMark: FlutterSliderHatchMark(
                        disabled: true,
                      ),
                      min: double.parse(controller.catAllData.value.lowestPrice),
                      max: double.parse(controller.catAllData.value.heightPrice),
                      onDragCompleted:
                          (handlerIndex, lowerValue, upperValue) async {
                        print('UPPER $lowerValue LOWER $upperValue');
                        controller.lowRangeCatCtrl.text = lowerValue.toString();
                        controller.highRangeCatCtrl.text =
                            upperValue.toString();

                        _lowerValue = lowerValue;
                        _upperValue = upperValue;

                        setState(() {});

                        controller.dataFilterCat.value.filterDataFromCat.filterType
                            .forEach((element) {
                          if (element.filterTypeId == 'price_range') {
                            element.filterTypeValue.clear();
                            element.filterTypeValue.add([
                              controller.lowRangeCatCtrl.text,
                              controller.highRangeCatCtrl.text,
                            ]);
                          }
                        });

                        await doFilter();
                      },
                    ),
                  )
                : Container(),

            showRange
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(children: [
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          readOnly: true,
                          controller: controller.lowRangeCatCtrl,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            hintText:
                                '${_currentRangeValues.start.round().toString()}',
                            fillColor: AppStyles.appBackgroundColor,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            hintStyle:
                                AppStyles.kFontGrey12w5.copyWith(fontSize: 13),
                          ),
                          style: AppStyles.kFontBlack13w5,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        ' - ',
                        style: AppStyles.kFontBlack12w4,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          readOnly: true,
                          controller: controller.highRangeCatCtrl,
                          scrollPhysics: NeverScrollableScrollPhysics(),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            hintText:
                                '${_currentRangeValues.end.round().toString()}',
                            fillColor: AppStyles.appBackgroundColor,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            hintStyle:
                                AppStyles.kFontGrey12w5.copyWith(fontSize: 13),
                          ),
                          style: AppStyles.kFontBlack13w5,
                        ),
                      ),
                    ]),
                  )
                : Container(),

            SizedBox(
              height: 10,
            ),
            //Rating

            SizedBox(
              height: 5,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: AppStyles.textFieldFillColor,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Rating'.tr,
                style: AppStyles.kFontBlack12w4,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  RatingBar.builder(
                    initialRating: controller.filterRating.value,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    glow: false,
                    itemSize: 20,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: AppStyles.goldenYellowColor,
                      size: 10,
                    ),
                    onRatingUpdate: (rating) async {
                      print(rating);
                      controller.filterRating.value = rating;

                      controller
                          .dataFilterCat.value.filterDataFromCat.filterType
                          .forEach((element) {
                        if (element.filterTypeId == 'rating') {
                          element.filterTypeValue.clear();
                          element.filterTypeValue.add(rating.toInt());
                        }
                      });

                      await doFilter();
                    },
                  ),
                  Obx(() {
                    return Text(
                      '${controller.filterRating.value.toString()} ' +
                          'and Up'.tr,
                      style: AppStyles.kFontBlack12w4,
                    );
                  })
                ],
              ),
            ),

            //Button
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: AppStyles.textFieldFillColor,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: BlueButtonWidget(
                  height: 40,
                  btnText: 'Reset'.tr,
                  btnOnTap: () async {
                    controller.categoryId.value =
                        controller.categoryIdBeforeFilter.value;
                    controller.allProds.clear();
                    controller.subCats.clear();
                    controller.lastPage.value = false;
                    controller.pageNumber.value = 1;
                    if (controller.dataFilterCat.value.filterDataFromCat !=
                        null) {
                      controller
                          .dataFilterCat.value.filterDataFromCat.filterType
                          .forEach((element) {
                        if (element.filterTypeId == 'brand' ||
                            element.filterTypeId == 'cat') {
                          print(element.filterTypeId);
                          element.filterTypeValue.clear();
                        }
                      });
                    }
                    controller.getCategoryFilterData();
                    controller.getCategoryProducts();

                    // Get.toNamed('/productsByCategory');

                    widget.source.isFilter = false;
                    widget.source.isSorted = false;
                    widget.source.refresh(true);
                    Get.back();
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: PinkButtonWidget(
                  height: 40,
                  btnText: 'Apply Filter'.tr,
                  btnOnTap: doFilter,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future doFilter() async {
    controller.dataFilterCat.value.filterDataFromCat.filterType
        .forEach((element) {
      if (element.filterTypeId == 'price_range') {
        element.filterTypeValue.clear();
        element.filterTypeValue.add([
          controller.lowRangeCatCtrl.text,
          controller.highRangeCatCtrl.text,
        ]);
      }
    });

    controller.dataFilterCat.value.filterDataFromCat.filterType
        .forEach((element) {
      if (element.filterTypeId == 'rating') {
        element.filterTypeValue.clear();
        element.filterTypeValue
            .add(controller.filterRating.value.toInt().toString());
      }
    });
    controller.filterPageNumber.value = 1;
    controller.lastPage.value = false;

    controller.filterSortKey.value = 'new';

    widget.source.isFilter = true;
    widget.source.isSorted = true;
    widget.source.refresh(true);
  }
}
