import 'dart:developer';

import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/address_book_controller.dart';
import 'package:amazy_app/controller/checkout_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/Cart/MyCheckoutModel.dart';
import 'package:amazy_app/model/Cart/FlatGst.dart';
import 'package:amazy_app/model/GeneralSettingsModel.dart';
import 'package:amazy_app/model/Product/ProductType.dart';
import 'package:amazy_app/model/ShippingMethodModel.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/cart/GatewaySelection.dart';
import 'package:amazy_app/view/settings/AddAddress.dart';
import 'package:amazy_app/view/settings/AddressBook.dart';
import 'package:amazy_app/widgets/AppBarWidget.dart';
import 'package:amazy_app/widgets/CustomDate.dart';
import 'package:amazy_app/widgets/PinkButtonWidget.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';

class CartCheckout extends StatefulWidget {
  @override
  _CartCheckoutState createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout> {
  final CheckoutController checkoutController = Get.put(CheckoutController());
  final AddressController addressController = Get.put(AddressController());

  final TextEditingController customerPhoneCtrl = TextEditingController();
  final TextEditingController customerEmailCtrl = TextEditingController();

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  // bool _isConfirm = false;
  ScrollController _scrollController = ScrollController();
  Map data = {};

  var gstId = 0;
  var gstShow = '';
  var gstShowList = [];

  String _verticalGroupValue = "Home Delivery";
  List<String> _status = [
    "Home Delivery",
    "Pickup Location",
  ];

  PickupLocation selectedPickupValue;
  @override
  void initState() {
    checkoutController.orderData.addAll({
      'package_wise_weight': {},
      'package_wise_height': {},
      'package_wise_length': {},
      'package_wise_breadth': {},
      'packagewiseTax': {},
      'shipping_cost': {},
      'delivery_date': {},
      'shipping_method': {},
    });
    if (currencyController.vendorType.value == "single") {
      selectedPickupValue =
          currencyController.settingsModel.value.pickupLocations.first;
    }

    if (_verticalGroupValue == "Home Delivery") {
      // Map deliveryInfo = {
      //   "delivery_type": "home_delivery",
      // };
      // checkoutController.deliveryInfo.value = deliveryInfo;

      checkoutController.deliveryType.value = "home_delivery";
    } else {
      // Map deliveryInfo = {
      //   "delivery_type": "pickup_location",
      //   "pickup_location_id": "${selectedPickupValue.id}"
      // };
      // checkoutController.deliveryInfo.value = deliveryInfo;

      checkoutController.deliveryType.value = "pickup_location";
      checkoutController.pickupId.value = selectedPickupValue.id;
    }
    checkoutController.getCheckoutList();

    super.initState();
  }

  void removeValueToMap<K, V>(Map<K, List<V>> map, K key, V value) {
    map.update(key, (list) => list..remove(value), ifAbsent: () => [value]);
  }

  void addValueToMap<K, V>(Map<K, V> map, K key, V value) {
    map.update(key, (v) => value, ifAbsent: () => value);
  }

  @override
  Widget build(BuildContext context) {
    // checkoutController.calculateDiscount();
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Checkout'.tr,
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 10,
            ),

            //**Delivery Info
            Obx(() {
              if (checkoutController.isLoading.value) {
                return Container();
              } else {
                if (addressController.addressCount.value > 0) {
                  customerEmailCtrl.text =
                      addressController.shippingAddress.value.email;
                  customerPhoneCtrl.text =
                      addressController.shippingAddress.value.phone;

                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(
                                  Icons.phone,
                                  size: 20,
                                  color: AppStyles.darkBlueColor,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: TextField(
                                  autofocus: false,
                                  controller: customerPhoneCtrl,
                                  scrollPhysics:
                                      AlwaysScrollableScrollPhysics(),
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    hintText: 'Phone number',
                                    fillColor: AppStyles.appBackgroundColor,
                                    isDense: true,
                                    filled: true,
                                    contentPadding: EdgeInsets.all(14),
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
                                    hintStyle: AppStyles.appFontBlack.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: AppStyles.greyColorDark,
                                    ),
                                  ),
                                  style: AppStyles.appFontBlack.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: AppStyles.blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(
                                  Icons.mail,
                                  size: 20,
                                  color: AppStyles.darkBlueColor,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: TextField(
                                  autofocus: false,
                                  controller: customerEmailCtrl,
                                  scrollPhysics:
                                      AlwaysScrollableScrollPhysics(),
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    hintText: 'Email Address',
                                    fillColor: AppStyles.appBackgroundColor,
                                    isDense: true,
                                    filled: true,
                                    contentPadding: EdgeInsets.all(14),
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
                                    hintStyle: AppStyles.appFontBlack.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: AppStyles.greyColorDark,
                                    ),
                                  ),
                                  style: AppStyles.appFontBlack.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: AppStyles.blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),

                        //** HOME DELIVERY / PICKUP */

                        currencyController.vendorType.value == "single"
                            ? RadioGroup<String>.builder(
                                direction: Axis.horizontal,
                                horizontalAlignment: MainAxisAlignment.start,
                                groupValue: _verticalGroupValue,
                                onChanged: (value) => setState(() {
                                  _verticalGroupValue = value;

                                  if (_verticalGroupValue == "Home Delivery") {
                                    // Map deliveryInfo = {
                                    //   "delivery_type": "home_delivery",
                                    // };
                                    // checkoutController.deliveryInfo.value =
                                    //     deliveryInfo;

                                    checkoutController.deliveryType.value =
                                        "home_delivery";

                                    double totalShipping = 0.0;

                                    print(checkoutController.packageCount.value
                                        .toString());

                                    for (int i = 0;
                                        i <
                                            checkoutController
                                                .packageCount.value;
                                        i++) {
                                      totalShipping += double.parse(
                                          checkoutController
                                              .orderData["shipping_cost[$i]"]
                                              .toString());
                                    }

                                    checkoutController.shipping.value =
                                        totalShipping.toPrecision(2);
                                  } else {
                                    // Map deliveryInfo = {
                                    //   "delivery_type": "pickup_location",
                                    //   "pickup_location_id":
                                    //       "${selectedPickupValue.id}",
                                    // };
                                    // checkoutController.deliveryInfo.value =
                                    //     deliveryInfo;

                                    checkoutController.deliveryType.value =
                                        "pickup_location";
                                    checkoutController.pickupId.value =
                                        selectedPickupValue.id;

                                    checkoutController.shipping.value = 0.0;

                                    //                     removeValueToMap(widget.orderData,
                                    //     'shipping_cost[${widget.packageIndex}]', '$shippingCost');
                                    // removeValueToMap(
                                    //     widget.orderData,
                                    //     'delivery_date[${widget.packageIndex}]',
                                    //     '${calculateArrival(value.shipmentTime)}');
                                    // removeValueToMap(widget.orderData,
                                    //     'shipping_method[${widget.packageIndex}]', '${value.id}');

                                    // removeValueToMap(data, 'qty_', 0);
                                  }

                                  checkoutController
                                      .grandTotal.value = (checkoutController
                                                  .subTotal.value +
                                              checkoutController
                                                  .shipping.value +
                                              checkoutController.gstTotal.value)
                                          .toPrecision(2) -
                                      checkoutController.discountTotal.value;
                                }),
                                items: _status,
                                itemBuilder: (item) => RadioButtonBuilder(
                                  item,
                                ),
                                activeColor: Colors.red,
                              )
                            : SizedBox.shrink(),

                        currencyController.vendorType.value == "single"
                            ? _verticalGroupValue != "Home Delivery"
                                ? ListView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(top: 10),
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      Text(
                                        'Select a pickup point'.tr,
                                        style: AppStyles.appFontBlack.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppStyles.pinkColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color:
                                                  AppStyles.appBackgroundColor,
                                              border: Border.all(
                                                  color: AppStyles
                                                      .textFieldFillColor)),
                                          child: DropdownButton<PickupLocation>(
                                            elevation: 1,
                                            isExpanded: true,
                                            underline: Container(),
                                            value: selectedPickupValue,
                                            items: currencyController
                                                .settingsModel
                                                .value
                                                .pickupLocations
                                                .map((e) {
                                              // reasonValue = widget.reasonValue;
                                              return DropdownMenuItem<
                                                  PickupLocation>(
                                                child:
                                                    Text('${e.pickupLocation}'),
                                                value: e,
                                              );
                                            }).toList(),
                                            onChanged: (PickupLocation value) {
                                              setState(() {
                                                selectedPickupValue = value;
                                              });

                                              checkoutController.deliveryType
                                                  .value = "pickup_location";
                                              checkoutController
                                                      .pickupId.value =
                                                  selectedPickupValue.id;

                                              // Map deliveryInfo = {
                                              //   "delivery_type":
                                              //       "pickup_location",
                                              //   "pickup_location_id":
                                              //       "${selectedPickupValue.id}"
                                              // };

                                              // checkoutController.deliveryInfo
                                              //     .value = deliveryInfo;
                                            },
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink()
                            : SizedBox.shrink(),

                        //** Shipping address */

                        currencyController.vendorType.value != "single"
                            ? Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    title: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Shipping Address'.tr,
                                        style: AppStyles.appFontBlack.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppStyles.pinkColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/images/location_ico.png',
                                          color: AppStyles.darkBlueColor,
                                          width: 17,
                                          height: 17,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                addressController
                                                    .shippingAddress
                                                    .value
                                                    .name
                                                    .capitalizeFirst,
                                                style: AppStyles.kFontBlack14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Address'.tr + ': ',
                                                  style: AppStyles.kFontGrey14w5
                                                      .copyWith(
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                    fontSize: 13,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${addressController.shippingAddress.value.address}',
                                                      style: AppStyles
                                                          .kFontGrey14w5
                                                          .copyWith(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        Get.to(() => AddressBook());
                                      },
                                      child: Container(
                                        child: Text(
                                          'Change'.tr,
                                          style:
                                              AppStyles.appFontBlack.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppStyles.pinkColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    title: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Billing Address'.tr,
                                        style: AppStyles.appFontBlack.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppStyles.pinkColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          child: Image.asset(
                                            'assets/images/icon_delivery-parcel.png',
                                            color: AppStyles.darkBlueColor,
                                            width: 15,
                                            height: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                addressController.billingAddress
                                                    .value.name.capitalizeFirst,
                                                style: AppStyles.kFontBlack14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Address'.tr + ': ',
                                                  style: AppStyles.kFontGrey14w5
                                                      .copyWith(
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                    fontSize: 13,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${addressController.billingAddress.value.address}',
                                                      style: AppStyles
                                                          .kFontGrey14w5
                                                          .copyWith(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        Get.to(() => AddressBook());
                                      },
                                      child: Container(
                                        child: Text(
                                          'Change'.tr,
                                          style:
                                              AppStyles.appFontBlack.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppStyles.pinkColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : _verticalGroupValue == "Home Delivery"
                                ? ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    title: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Shipping Address'.tr,
                                        style: AppStyles.appFontBlack.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppStyles.pinkColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/images/location_ico.png',
                                          color: AppStyles.darkBlueColor,
                                          width: 17,
                                          height: 17,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                addressController
                                                    .shippingAddress
                                                    .value
                                                    .name
                                                    .capitalizeFirst,
                                                style: AppStyles.kFontBlack14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Address'.tr + ': ',
                                                  style: AppStyles.kFontGrey14w5
                                                      .copyWith(
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                    fontSize: 13,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${addressController.shippingAddress.value.address}',
                                                      style: AppStyles
                                                          .kFontGrey14w5
                                                          .copyWith(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        Get.to(() => AddressBook());
                                      },
                                      child: Container(
                                        child: Text(
                                          'Change'.tr,
                                          style:
                                              AppStyles.appFontBlack.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppStyles.pinkColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    title: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Billing Address'.tr,
                                        style: AppStyles.appFontBlack.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppStyles.pinkColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          child: Image.asset(
                                            'assets/images/icon_delivery-parcel.png',
                                            color: AppStyles.darkBlueColor,
                                            width: 15,
                                            height: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                addressController.billingAddress
                                                    .value.name.capitalizeFirst,
                                                style: AppStyles.kFontBlack14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Address'.tr + ': ',
                                                  style: AppStyles.kFontGrey14w5
                                                      .copyWith(
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                    fontSize: 13,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${addressController.billingAddress.value.address}',
                                                      style: AppStyles
                                                          .kFontGrey14w5
                                                          .copyWith(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        Get.to(() => AddressBook());
                                      },
                                      child: Container(
                                        child: Text(
                                          'Change'.tr,
                                          style:
                                              AppStyles.appFontBlack.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppStyles.pinkColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => AddAddress());
                      },
                      child: DottedBorder(
                        color: AppStyles.lightBlueColor,
                        strokeWidth: 1,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        child: Container(
                          alignment: Alignment.center,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xffEDF3FA),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline_rounded,
                                color: AppStyles.lightBlueColor,
                                size: 22,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Add Address'.tr,
                                textAlign: TextAlign.center,
                                style: AppStyles.appFontMedium.copyWith(
                                  color: AppStyles.lightBlueColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
            }),
            SizedBox(
              height: 10,
            ),

            //**Products
            Obx(() {
              if (checkoutController.isLoading.value) {
                return Center(
                  child: CustomLoadingWidget(),
                );
              } else {
                if (checkoutController.checkoutModel.value.packages == null ||
                    checkoutController.checkoutModel.value.packages.length ==
                        0) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Icon(
                          FontAwesomeIcons.exclamation,
                          color: AppStyles.pinkColor,
                          size: 25,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No Products found'.tr,
                          textAlign: TextAlign.center,
                          style: AppStyles.kFontPink15w5.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  );
                } else {
                  // var packageInd = 0;
                  // ignore: unused_local_variable
                  var taxes = [];
                  // ignore: unused_local_variable
                  var pTaxes = [];
                  var additionalShipping = 0.0;

                  return Container(
                    color: Colors.white,
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: checkoutController
                            .checkoutModel.value.packages.values.length,
                        itemBuilder: (context, index) {
                          // var packageTax = 0.0;
                          // packageInd++;
                          var qty = 0;
                          var price = 0.0;

                          var totalWeight = 0.0;
                          var totalHeight = 0.0;
                          var totalLength = 0.0;
                          var totalBreadth = 0.0;

                          print("Additional $additionalShipping");

                          checkoutController.checkoutModel.value.packages.values
                              .elementAt(index)
                              .items
                              .forEach((element) {
                            qty += element.qty;
                          });
                          checkoutController.checkoutModel.value.packages.values
                              .elementAt(index)
                              .items
                              .forEach((element) {
                            price += element.totalPrice;
                          });

                          checkoutController.checkoutModel.value.packages.values
                              .elementAt(index)
                              .items
                              .forEach((element) {
                            if (element.productType == ProductType.PRODUCT) {
                              totalWeight +=
                                  double.parse(element.product.sku.weight)
                                      .toDouble();
                              totalHeight +=
                                  double.parse(element.product.sku.height)
                                      .toDouble();
                              totalLength +=
                                  double.parse(element.product.sku.length)
                                      .toDouble();
                              totalBreadth +=
                                  double.parse(element.product.sku.breadth)
                                      .toDouble();
                            }
                          });

                          data.addAll({
                            'package_wise_weight[$index]': totalWeight,
                            'package_wise_height[$index]': totalHeight,
                            'package_wise_length[$index]': totalLength,
                            'package_wise_breadth[$index]': totalBreadth,
                          });

                          // String calculateArrival() {
                          //   var arr = checkoutController
                          //       .checkoutModel.value.items.values
                          //       .elementAt(index)
                          //       .first
                          //       .shippingMethod
                          //       .shipmentTime;
                          //   if (arr.contains('days')) {
                          //     arr = arr.replaceAll(' days', '');
                          //     arr = 'Est. Arrival Date: ' +
                          //         CustomDate().formattedDateOnly(
                          //             DateTime.now().add(Duration(
                          //                 days: int.parse(
                          //                     arr.split('-').first)))) +
                          //         '-' +
                          //         CustomDate().formattedDateOnly(
                          //             DateTime.now().add(Duration(
                          //                 days: int.parse(
                          //                     arr.split('-').last))));
                          //   } else {
                          //     arr = 'Est. Arrival Time: ' + arr;
                          //   }
                          //   return arr;
                          // }

                          var gst = 0.0;
                          var gstS = '';
                          var gstShowList = [];
                          var gstID = [];
                          var gstAmount = [];
                          if (checkoutController
                                  .checkoutModel.value.isGstModuleEnable ==
                              1) {
                            log("gst module enabled");
                            checkoutController
                                .checkoutModel.value.packages.values
                                .elementAt(index)
                                .items
                                .forEach((element) {
                              gstShowList.clear();
                              gstID.clear();
                              gstAmount.clear();

                              if (checkoutController
                                      .checkoutModel.value.isGstEnable ==
                                  1) {
                                log('enabled gst');
                                if (currencyController
                                        .settingsModel.value.vendorType ==
                                    "single") {
                                  if (element.customer.customerShippingAddress
                                          .state ==
                                      currencyController
                                          .settingsModel.value.settings.stateId
                                          .toString()) {
                                    checkoutController
                                        .checkoutModel.value.sameStateGstList
                                        .forEach((same) {
                                      gst = double.parse(
                                              ((price * same.taxPercentage) /
                                                      100)
                                                  .toString())
                                          .toPrecision(2);
                                      gstS =
                                          '${same.name}(${same.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
                                      gstShowList.add(gstS);
                                      gstID.add(same.id);
                                      gstAmount.add(gst);
                                    });

                                    data.addAll({
                                      'packagewiseTax[$index]': gstAmount,
                                      // 'gst_amounts_package_$packageInd[]':
                                      //     gstAmount,
                                    });
                                  } else {
                                    checkoutController.checkoutModel.value
                                        .differantStateGstList
                                        .forEach((diff) {
                                      gst = double.parse(
                                              ((price * diff.taxPercentage) /
                                                      100)
                                                  .toString())
                                          .toPrecision(2);

                                      gstS =
                                          '${diff.name}(${diff.taxPercentage} %) : $gst${currencyController.appCurrency.value} ';
                                      gstShowList.add(gstS);
                                      gstID.add(diff.id);
                                      gstAmount.add(gst);
                                    });
                                    data.addAll({
                                      'packagewiseTax[$index]': gstAmount,
                                      // 'gst_package_$packageInd[]': gstID,
                                      // 'gst_amounts_package_$packageInd[]':
                                      //     gstAmount,
                                    });
                                  }
                                } else {
                                  if ((element.customer
                                                  .customerShippingAddress !=
                                              null &&
                                          element.seller
                                                  .sellerBusinessInformation !=
                                              null) &&
                                      element.customer.customerShippingAddress
                                              .state ==
                                          element
                                              .seller
                                              .sellerBusinessInformation
                                              .businessState) {
                                    checkoutController
                                        .checkoutModel.value.sameStateGstList
                                        .forEach((same) {
                                      gst = (price * same.taxPercentage) / 100;
                                      gstS =
                                          '${same.name}(${same.taxPercentage} %) : $gst${currencyController.appCurrency.value} ';
                                      gstShowList.add(gstS);
                                      gstID.add(same.id);
                                      gstAmount.add(gst);
                                    });

                                    data.addAll({
                                      'packagewiseTax[$index]': gstAmount,

                                      // 'gst_package_$packageInd[]': gstID,
                                      // 'gst_amounts_package_$packageInd[]':
                                      //     gstAmount,
                                    });
                                  } else {
                                    if (element
                                            .seller.sellerBusinessInformation ==
                                        null) {
                                      gst = (price *
                                              checkoutController
                                                  .checkoutModel
                                                  .value
                                                  .flatGst
                                                  .taxPercentage) /
                                          100;

                                      gstS =
                                          '${checkoutController.checkoutModel.value.flatGst.name}(${checkoutController.checkoutModel.value.flatGst.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
                                      gstShowList.add(gstS);
                                      gstAmount.add(gst);

                                      data.addAll({
                                        'packagewiseTax[$index]': gstAmount,

                                        // 'gst_package_$packageInd[]': gstID,
                                        // 'gst_amounts_package_$packageInd[]':
                                        //     gstAmount,
                                      });
                                    } else {
                                      checkoutController.checkoutModel.value
                                          .differantStateGstList
                                          .forEach((diff) {
                                        gst =
                                            (price * diff.taxPercentage) / 100;
                                        gstS =
                                            '${diff.name}(${diff.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
                                        gstShowList.add(gstS);
                                        gstID.add(diff.id);
                                        gstAmount.add(gst);
                                      });
                                      data.addAll({
                                        'packagewiseTax[$index]': gstAmount,

                                        // 'gst_package_$packageInd[]': gstID,
                                        // 'gst_amounts_package_$packageInd[]':
                                        //     gstAmount,
                                      });
                                    }
                                  }
                                }
                              } else {
                                ///
                                ///not enable gst
                                ///
                                log("not enable gst");
                                FlatGst flatGST = checkoutController
                                    .checkoutModel.value.flatGst;
                                gst = (price * flatGST.taxPercentage) / 100;
                                gstS =
                                    '${flatGST.name}(${flatGST.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
                                gstShowList.add(gstS);
                                gstID.add(flatGST.id);
                                gstAmount.add(gst);
                                data.addAll({
                                  'packagewiseTax[$index]': gstAmount,
                                  // 'gst_package_$packageInd[]': gstID,
                                  // 'gst_amounts_package_$packageInd[]':
                                  //     gstAmount,
                                });
                              }
                            });
                          }

                          // var ship = checkoutController
                          //     .checkoutModel.value.items.values
                          //     .elementAt(index)
                          //     .first
                          //     .shippingMethod;

                          // data.addAll({
                          //   'shipping_cost[${packageInd - 1}]':
                          //       ship.cost +
                          //           (additionalShipping > 0.0
                          //               ? additionalShipping
                          //               : 0),
                          //   'shipping_method[${packageInd - 1}]':
                          //       ship.id,
                          //   'delivery_date[${packageInd - 1}]':
                          //       calculateArrival(),
                          // });

                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    currencyController.vendorType.value ==
                                            "single"
                                        ? SizedBox.shrink()
                                        : ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  'assets/images/icon_delivery-parcel.png',
                                                  width: 15,
                                                  height: 15,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Package'.tr +
                                                            ' ${index + 1}/${checkoutController.packageCount.value}',
                                                        style: AppStyles
                                                            .kFontBlack12w4,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      // Text(
                                                      //   'Shipping'.tr +
                                                      //       ': ' +
                                                      //       checkoutController
                                                      //           .checkoutModel
                                                      //           .value
                                                      //           .items
                                                      //           .values
                                                      //           .elementAt(
                                                      //               index)
                                                      //           .first
                                                      //           .shippingMethod
                                                      //           .methodName,
                                                      //   style: AppStyles
                                                      //       .kFontBlack12w4,
                                                      // ),
                                                      // SizedBox(
                                                      //   height: 5,
                                                      // ),
                                                      // Text(
                                                      //   '${calculateArrival()}',
                                                      //   style: AppStyles
                                                      //       .kFontBlack12w4,
                                                      // ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Text(
                                                          //   'Shipping cost'
                                                          //           .tr +
                                                          //       ': ${(checkoutController.checkoutModel.value.items.values.elementAt(index).first.shippingMethod.cost * currencyController.conversionRate.value)}${currencyController.appCurrency.value}',
                                                          //   style: AppStyles
                                                          //       .kFontGrey12w5,
                                                          // ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          additionalShipping >
                                                                  0.0
                                                              ? Text(
                                                                  'Additional Shipping'
                                                                          .tr +
                                                                      ': ${(additionalShipping * currencyController.conversionRate.value)}${currencyController.appCurrency.value}',
                                                                  style: AppStyles
                                                                      .kFontGrey12w5,
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing: Text(
                                              'Sold by'.tr +
                                                  ': ${checkoutController.checkoutModel.value.packages.values.elementAt(index).items.first.seller.name}',
                                              style: AppStyles.kFontGrey12w5,
                                            ),
                                          ),
                                    ListView.separated(
                                        separatorBuilder: (contxt, index) {
                                          return Divider(
                                            height: 2,
                                          );
                                        },
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: checkoutController
                                            .checkoutModel.value.packages.values
                                            .elementAt(index)
                                            .items
                                            .length,
                                        itemBuilder: (context, productIndex) {
                                          List<CheckoutItem> checkoutItem =
                                              checkoutController.checkoutModel
                                                  .value.packages.values
                                                  .elementAt(index)
                                                  .items;

                                          return Column(
                                            children: [
                                              Container(
                                                color: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          child: Container(
                                                            height: 65,
                                                            width: 65,
                                                            child: checkoutItem[
                                                                            productIndex]
                                                                        .productType ==
                                                                    ProductType
                                                                        .PRODUCT
                                                                ? checkoutItem[productIndex]
                                                                            .product
                                                                            .sku
                                                                            .variantImage !=
                                                                        null
                                                                    ? FancyShimmerImage(
                                                                        imageUrl: AppConfig.assetPath +
                                                                            '/' +
                                                                            checkoutItem[productIndex].product.sku.variantImage,
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        errorWidget:
                                                                            FancyShimmerImage(
                                                                          imageUrl:
                                                                              "${AppConfig.assetPath}/backend/img/default.png",
                                                                          boxFit:
                                                                              BoxFit.contain,
                                                                        ),
                                                                      )
                                                                    : FancyShimmerImage(
                                                                        imageUrl: AppConfig.assetPath +
                                                                            '/' +
                                                                            checkoutItem[productIndex].product.product.product.thumbnailImageSource,
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        errorWidget:
                                                                            FancyShimmerImage(
                                                                          imageUrl:
                                                                              "${AppConfig.assetPath}/backend/img/default.png",
                                                                          boxFit:
                                                                              BoxFit.contain,
                                                                        ),
                                                                      )
                                                                : FancyShimmerImage(
                                                                    imageUrl: AppConfig
                                                                            .assetPath +
                                                                        '/' +
                                                                        checkoutItem[productIndex]
                                                                            .giftCard
                                                                            .thumbnailImage,
                                                                    boxFit: BoxFit
                                                                        .contain,
                                                                    errorWidget:
                                                                        FancyShimmerImage(
                                                                      imageUrl:
                                                                          "${AppConfig.assetPath}/backend/img/default.png",
                                                                      boxFit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      checkoutItem[productIndex].productType ==
                                                                              ProductType.PRODUCT
                                                                          ? Text(
                                                                              checkoutItem[productIndex].product.product.product.productName,
                                                                              style: AppStyles.kFontBlack13w4,
                                                                            )
                                                                          : Text(
                                                                              checkoutItem[productIndex].giftCard.name,
                                                                              style: AppStyles.kFontBlack13w4,
                                                                            ),
                                                                      checkoutItem[productIndex].productType ==
                                                                              ProductType
                                                                                  .PRODUCT
                                                                          ? ListView
                                                                              .builder(
                                                                              shrinkWrap: true,
                                                                              physics: NeverScrollableScrollPhysics(),
                                                                              padding: EdgeInsets.symmetric(vertical: 4),
                                                                              itemCount: checkoutItem[productIndex].product.productVariations.length,
                                                                              itemBuilder: (BuildContext context, int variationIndex) {
                                                                                if (checkoutItem[productIndex].product.productVariations[variationIndex].attribute.name == 'Color') {
                                                                                  return Text(
                                                                                    '${checkoutItem[productIndex].product.productVariations[variationIndex].attribute.name}: ${checkoutItem[productIndex].product.productVariations[variationIndex].attributeValue.color.name}',
                                                                                    style: AppStyles.kFontGrey12w5,
                                                                                  );
                                                                                }
                                                                                return Text(
                                                                                  '${checkoutItem[productIndex].product.productVariations[variationIndex].attribute.name}: ${checkoutItem[productIndex].product.productVariations[variationIndex].attributeValue.value}',
                                                                                  style: AppStyles.kFontGrey12w5,
                                                                                );
                                                                              },
                                                                            )
                                                                          : SizedBox
                                                                              .shrink(),
                                                                      Wrap(
                                                                        runSpacing:
                                                                            10,
                                                                        alignment:
                                                                            WrapAlignment.start,
                                                                        crossAxisAlignment:
                                                                            WrapCrossAlignment.start,
                                                                        children: [
                                                                          //** Price */
                                                                          checkoutItem[productIndex].productType == ProductType.PRODUCT
                                                                              ? checkoutItem[productIndex].product.product.hasDiscount == "yes"
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          '${double.parse((checkoutItem[productIndex].price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                          style: AppStyles.kFontPink15w5,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        Text(
                                                                                          '${double.parse((checkoutItem[productIndex].product.sellingPrice * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                          style: AppStyles.kFontGrey12w5.copyWith(
                                                                                            decoration: TextDecoration.lineThrough,
                                                                                            decorationThickness: 2,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : Text(
                                                                                      '${double.parse((checkoutItem[productIndex].price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                      style: AppStyles.kFontPink15w5,
                                                                                    )
                                                                              : checkoutItem[productIndex].giftCard.endDate.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          '${double.parse((checkoutItem[productIndex].price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                          style: AppStyles.kFontPink15w5,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        Text(
                                                                                          '${double.parse((checkoutItem[productIndex].giftCard.sellingPrice * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                          style: AppStyles.kFontGrey12w5.copyWith(decoration: TextDecoration.lineThrough),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : Text(
                                                                                      '${double.parse((checkoutItem[productIndex].price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                      style: AppStyles.kFontPink15w5,
                                                                                    ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          //** Discount */
                                                                          checkoutItem[productIndex].productType == ProductType.PRODUCT
                                                                              ? checkoutItem[productIndex].product.product.hasDeal != null
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          padding: EdgeInsets.all(4),
                                                                                          decoration: BoxDecoration(
                                                                                            color: AppStyles.pinkColor,
                                                                                            borderRadius: BorderRadius.circular(2),
                                                                                          ),
                                                                                          child: Text(
                                                                                            checkoutItem[productIndex].product.product.hasDeal.discountType == 0 ? '-${checkoutItem[productIndex].product.product.hasDeal.discount}%' : '-${double.parse((checkoutItem[productIndex].product.product.hasDeal.discount * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                            style: AppStyles.kFontWhite12w5,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : double.parse(checkoutItem[productIndex].product.product.discount) > 0
                                                                                      ? Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              padding: EdgeInsets.all(4),
                                                                                              decoration: BoxDecoration(
                                                                                                color: AppStyles.pinkColor,
                                                                                                borderRadius: BorderRadius.circular(2),
                                                                                              ),
                                                                                              child: Text(
                                                                                                checkoutItem[productIndex].product.product.discountType == "0" ? '-${checkoutItem[productIndex].product.product.discount}%' : '-${double.parse((double.parse(checkoutItem[productIndex].product.product.discount) * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                                style: AppStyles.kFontWhite12w5,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      : Container()
                                                                              : checkoutItem[productIndex].giftCard.discount > DateTime.now().millisecondsSinceEpoch
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          padding: EdgeInsets.all(4),
                                                                                          decoration: BoxDecoration(
                                                                                            color: AppStyles.pinkColor,
                                                                                            borderRadius: BorderRadius.circular(2),
                                                                                          ),
                                                                                          child: Text(
                                                                                            checkoutItem[productIndex].giftCard.discountType == "0" || checkoutItem[productIndex].giftCard.discountType == 0 ? '-${checkoutItem[productIndex].giftCard.discount}%' : '-${double.parse((checkoutItem[productIndex].giftCard.discount * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                            style: AppStyles.kFontWhite12w5,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : Container(),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Qty'.tr +
                                                                      ': ${checkoutItem[productIndex].qty}',
                                                                  style: AppStyles
                                                                      .kFontBlack12w4,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                    Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Divider(
                                            color: AppStyles.lightBlueColorAlt,
                                            thickness: 2,
                                            height: 2,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              // Column(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.start,
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment.start,
                                              //   children: List.generate(
                                              //     gstShowList.length,
                                              //     (gstIndex) => Padding(
                                              //       padding: const EdgeInsets
                                              //               .symmetric(
                                              //           vertical: 4.0),
                                              //       child: Text(
                                              //         gstShowList[gstIndex],
                                              //         style: AppStyles
                                              //             .kFontBlack12w4
                                              //             .copyWith(
                                              //           color: AppStyles
                                              //               .greyColorDark,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '$qty ' +
                                                      'Item(s), Total: '.tr +
                                                      '${double.parse((price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                  style:
                                                      AppStyles.kFontBlack12w4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 10,
                                thickness: 2,
                                color: AppStyles.appBackgroundColor,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Shipping Method".tr + ":",
                                    textAlign: TextAlign.left,
                                    style: AppStyles.kFontBlack14w5,
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ShippingDropDown(
                                  shippingValue: checkoutController
                                      .checkoutModel.value.packages.values
                                      .elementAt(index)
                                      .shipping
                                      .first,
                                  shippings: checkoutController
                                      .checkoutModel.value.packages.values
                                      .elementAt(index)
                                      .shipping,
                                  packageIndex: index,
                                  price: price,
                                  totalWeight: totalWeight,
                                  orderData: data,
                                ),
                              ),
                              Divider(
                                height: 10,
                                thickness: 10,
                                color: AppStyles.appBackgroundColor,
                              ),
                              // ListView.builder(
                              //   shrinkWrap: true,
                              //   physics: NeverScrollableScrollPhysics(),
                              //   itemBuilder: (context, shippingIndex) {
                              //     Shipping shipping = checkoutController
                              //         .checkoutModel.value.packages.values
                              //         .elementAt(index)
                              //         .shipping[shippingIndex];

                              //     String basedOn = '';
                              //     double shippingCost = 0.0;

                              //     if (shipping.costBasedOn == "Price") {
                              //       basedOn = "Based on Per Hundred".tr;
                              //     } else if (shipping.costBasedOn == "Weight") {
                              //       basedOn = "Based on Per 100 Gm".tr;
                              //     } else {
                              //       basedOn = "Based on Flat Rate".tr;
                              //     }

                              //     if (shipping.costBasedOn == 'Price') {
                              //       if (price > 0) {
                              //         shippingCost =
                              //             (price / 100) * shipping.cost +
                              //                 additionalShipping;
                              //       }
                              //     } else if (shipping.costBasedOn == 'Weight') {
                              //       if (totalWeight > 0) {
                              //         shippingCost =
                              //             (totalWeight / 100) * shipping.cost +
                              //                 additionalShipping;
                              //       }
                              //     } else {
                              //       if (shipping.cost > 0) {
                              //         shippingCost =
                              //             shipping.cost + additionalShipping;
                              //       }
                              //     }

                              //     return Obx(() {
                              //       return RadioListTile<Shipping>(
                              //         value: checkoutController
                              //             .selectedShipping[index],
                              //         groupValue: checkoutController
                              //             .checkoutModel.value.packages.values
                              //             .elementAt(index)
                              //             .shipping[shippingIndex],
                              //         onChanged: (Shipping ind) {
                              //           setState(() {
                              //             checkoutController
                              //                     .selectedShipping[index] =
                              //                 checkoutController.checkoutModel
                              //                     .value.packages.values
                              //                     .elementAt(index)
                              //                     .shipping[shippingIndex];
                              //           });

                              //           log(checkoutController
                              //               .selectedShipping[index].methodName
                              //               .toString());
                              //         },
                              //         title: Row(
                              //           children: [
                              //             Text("${shipping.methodName}"),
                              //             Expanded(child: Container()),
                              //             Text(
                              //               "(${double.parse("${shippingCost * currencyController.conversionRate.value}").toStringAsFixed(2)}${currencyController.appCurrency.value})",
                              //             ),
                              //           ],
                              //         ),
                              //         subtitle: Text(
                              //             "${shipping.shipmentTime} - ($basedOn)"),
                              //       );
                              //     });
                              //   },
                              //   itemCount: checkoutController
                              //       .checkoutModel.value.packages.values
                              //       .elementAt(index)
                              //       .shipping
                              //       .length,
                              // ),
                            ],
                          );
                        }),
                  );
                }
              }
            }),

            //** Pricing Info
            Obx(() {
              if (checkoutController.isLoading.value) {
                return Center(
                  child: Container(),
                );
              } else {
                if (checkoutController.checkoutModel.value.packages == null ||
                    checkoutController.checkoutModel.value.packages.length ==
                        0) {
                  return Container();
                } else {
                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal'.tr,
                              style: AppStyles.kFontBlack12w4.copyWith(
                                color: AppStyles.greyColorDark,
                              ),
                            ),
                            Text(
                              '${(checkoutController.subTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shipping'.tr,
                              style: AppStyles.kFontBlack12w4.copyWith(
                                color: AppStyles.greyColorDark,
                              ),
                            ),
                            Text(
                              '${(checkoutController.shipping.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Saving'.tr,
                              style: AppStyles.kFontBlack12w4.copyWith(
                                color: AppStyles.greyColorDark,
                              ),
                            ),
                            Text(
                              '-${(checkoutController.discountTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        checkoutController
                                    .checkoutModel.value.isGstModuleEnable ==
                                1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total GST/TAX'.tr,
                                        style:
                                            AppStyles.kFontBlack12w4.copyWith(
                                          color: AppStyles.greyColorDark,
                                        ),
                                      ),
                                      Text(
                                        '${(checkoutController.gstTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                        style: AppStyles.kFontBlack14w5,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 12,
                        ),
                        checkoutController.couponApplied.value
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      checkoutController.removeCoupon();
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Coupon Discount'.tr,
                                          style: AppStyles.kFontGrey12w5
                                              .copyWith(color: Colors.green),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${(checkoutController.couponDiscount.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                    style: AppStyles.kFontBlack14w5
                                        .copyWith(color: Colors.green),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: AppStyles.lightBlueColorAlt,
                          thickness: 2,
                          height: 2,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${checkoutController.totalQty} ' +
                                  'Item(s), Grand Total:'.tr +
                                  ' ' +
                                  '${(checkoutController.grandTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        !checkoutController.couponApplied.value
                            ? Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      height: 45,
                                      child: TextField(
                                        autofocus: false,
                                        scrollPhysics:
                                            AlwaysScrollableScrollPhysics(),
                                        controller: checkoutController
                                            .couponCodeTextController,
                                        decoration: InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          hintText:
                                              'Enter coupon/voucher code'.tr,
                                          fillColor:
                                              AppStyles.appBackgroundColor,
                                          filled: true,
                                          isDense: true,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                            ),
                                          ),
                                          hintStyle: AppStyles.kFontGrey12w5
                                              .copyWith(fontSize: 13),
                                        ),
                                        style: AppStyles.kFontBlack13w5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      checkoutController.applyCoupon();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 100,
                                      height: 45,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          border: Border.all(
                                              color: AppStyles.greyColorDark)),
                                      child: Text(
                                        'Apply'.tr,
                                        textAlign: TextAlign.center,
                                        style: AppStyles.appFontMedium.copyWith(
                                          color: AppStyles.greyColorDark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                }
              }
            }),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (checkoutController.isLoading.value) {
          return SizedBox.shrink();
        } else
          return Material(
            elevation: 20,
            child: Container(
              height: 70,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Total'.tr + ": ",
                              textAlign: TextAlign.center,
                              style: AppStyles.appFontMedium.copyWith(
                                fontSize: 17,
                                color: AppStyles.blackColor,
                              ),
                            ),
                            Obx(() {
                              if (checkoutController.isLoading.value) {
                                return Center(
                                  child: Container(),
                                );
                              } else {
                                if (checkoutController
                                            .checkoutModel.value.packages ==
                                        null ||
                                    checkoutController.checkoutModel.value
                                            .packages.length ==
                                        0) {
                                  return Container();
                                } else {
                                  return Text(
                                    '${(checkoutController.grandTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                    textAlign: TextAlign.center,
                                    style: AppStyles.appFontMedium.copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: AppStyles.darkBlueColor,
                                    ),
                                  );
                                }
                              }
                            })
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 3),
                          child: Text(
                            'TAX/GST included, where applicable'.tr,
                            style: AppStyles.kFontGrey12w5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  PinkButtonWidget(
                    height: 40,
                    btnText: 'Proceed to Payment'.tr,
                    btnOnTap: () {
                      if (addressController.addressCount.value == 0) {
                        SnackBars().snackBarWarning(
                            'Please Add Shipping and Billing Address'.tr);
                      } else {
                        data.addAll({
                          'customer_shipping_address':
                              addressController.shippingAddress.value.id,
                          'customer_billing_address':
                              addressController.billingAddress.value.id,
                          'customer_email': '${customerEmailCtrl.text}',
                          'customer_phone': '${customerPhoneCtrl.text}',
                          'customer_name':
                              '${addressController.shippingAddress.value.name ?? ""}',
                          'number_of_item': checkoutController.totalQty.value,
                          'number_of_package':
                              checkoutController.packageCount.value,
                          'sub_total': checkoutController.subTotal.value,
                          'shipping_total': checkoutController.shipping.value,
                          'discount_total':
                              checkoutController.discountTotal.value,
                          'grand_total': checkoutController.grandTotal.value,
                          'tax_total': checkoutController.gstTotal.value,
                        });

                        if (checkoutController.couponDiscount.value > 0) {
                          data.addAll({
                            'coupon_id': checkoutController.couponId.value,
                            'coupon_amount':
                                checkoutController.couponDiscount.value,
                          });
                        }
                        log(data.toString());
                        Get.to(() => GatewaySelection(
                              data: data,
                            ));
                      }
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          );
      }),
    );
  }
}

// ignore: must_be_immutable
class ShippingDropDown extends StatefulWidget {
  Shipping shippingValue;
  final int packageIndex;
  final double price;

  final double totalWeight;
  final List<Shipping> shippings;
  Map orderData;

  ShippingDropDown({
    this.shippingValue,
    this.packageIndex,
    this.shippings,
    this.price,
    this.totalWeight,
    this.orderData,
  });

  @override
  _ShippingDropDownState createState() => _ShippingDropDownState();
}

class _ShippingDropDownState extends State<ShippingDropDown> {
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  final CheckoutController checkoutController = Get.put(CheckoutController());

  void addValueToMap<K, V>(Map<K, V> map, K key, V value) {
    map.update(key, (v) => value, ifAbsent: () => value);
  }

  double shippingCost2 = 0.0;

  double additionalShipping;

  String calculateArrival(shipmentTime) {
    var arr = shipmentTime;
    if (arr.contains('days')) {
      arr = arr.replaceAll(' days', '');
      arr = 'Est. Arrival Date: ' +
          CustomDate().formattedDateOnly(DateTime.now()
              .add(Duration(days: int.parse(arr.split('-').first)))) +
          '-' +
          CustomDate().formattedDateOnly(DateTime.now()
              .add(Duration(days: int.parse(arr.split('-').last))));
    } else {
      arr = 'Est. Arrival Time: ' + arr;
    }
    return arr;
  }

  @override
  void initState() {
    additionalShipping = 0.0;
    checkoutController.checkoutModel.value.packages.forEach((key, value) {
      value.items.forEach((CheckoutItem itemEl) {
        if (itemEl.productType == ProductType.PRODUCT) {
          additionalShipping += itemEl.product.sku.additionalShipping;
        }
      });
    });

    if (widget.shippingValue.costBasedOn == 'Price') {
      if (widget.price > 0) {
        shippingCost2 = (widget.price / 100) * double.parse( widget.shippingValue.cost) +
            additionalShipping;
      }
    } else if (widget.shippingValue.costBasedOn == 'Weight') {
      if (widget.totalWeight > 0) {
        shippingCost2 = (widget.totalWeight / 100) * double.parse( widget.shippingValue.cost) +
            additionalShipping;
      }
    } else {
      if (double.parse( widget.shippingValue.cost) > 0) {
        shippingCost2 = double.parse( widget.shippingValue.cost) + additionalShipping;
      }
    }

    widget.orderData.addAll({
      'shipping_cost[${widget.packageIndex}]': shippingCost2,
      'delivery_date[${widget.packageIndex}]':
          calculateArrival(widget.shippingValue.shipmentTime),
      'shipping_method[${widget.packageIndex}]': widget.shippingValue.id,
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<Shipping>(
        elevation: 1,
        isExpanded: true,
        underline: Container(),
        value: widget.shippingValue,
        itemHeight: 60,
        items: widget.shippings.map((e) {
          String basedOn = '';
          double shippingCost = 0.0;

          if (e.costBasedOn == "Price") {
            basedOn = "Based on Per Hundred".tr;
          } else if (e.costBasedOn == "Weight") {
            basedOn = "Based on Per 100 Gm".tr;
          } else {
            basedOn = "Based on Flat Rate".tr;
          }

          if (e.costBasedOn == 'Price') {
            if (widget.price > 0) {
              shippingCost =
                  ((widget.price / 100) * double.parse(e.cost)) + additionalShipping;
            }
          } else if (e.costBasedOn == 'Weight') {
            if (widget.totalWeight > 0) {
              shippingCost =
                  ((widget.totalWeight / 100) * double.parse(e.cost)) + additionalShipping;
            }
          } else {
            if (double.parse(e.cost) > 0) {
              shippingCost = double.parse(e.cost) + additionalShipping;
            }
          }

          return DropdownMenuItem<Shipping>(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${e.methodName} (${double.parse("${shippingCost * currencyController.conversionRate.value}").toStringAsFixed(2)}${currencyController.appCurrency.value})",
                  style: AppStyles.kFontBlack14w5.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${e.shipmentTime} - ($basedOn)",
                  style: AppStyles.kFontBlack14w5,
                ),
              ],
            ),
            value: e,
          );
        }).toList(),
        onChanged: (Shipping value) {
          setState(() {
            widget.shippingValue = value;

            checkoutController.selectedShipping[widget.packageIndex] = value;

            double shippingCost = 0.0;

            if (widget.shippingValue.costBasedOn == 'Price') {
              if (widget.price > 0) {
                shippingCost =
                    (widget.price / 100) * double.parse( widget.shippingValue.cost)  +
                        additionalShipping;
              }
            } else if (widget.shippingValue.costBasedOn == 'Weight') {
              if (widget.totalWeight > 0) {
                shippingCost =
                    (widget.totalWeight / 100) *double.parse( widget.shippingValue.cost)  +
                        additionalShipping;
              }
            } else {
              if (double.parse( widget.shippingValue.cost)  > 0) {
                shippingCost = double.parse( widget.shippingValue.cost)  + additionalShipping;
              }
            }
            addValueToMap(widget.orderData,
                'shipping_cost[${widget.packageIndex}]', '$shippingCost');
            addValueToMap(
                widget.orderData,
                'delivery_date[${widget.packageIndex}]',
                '${calculateArrival(value.shipmentTime)}');
            addValueToMap(widget.orderData,
                'shipping_method[${widget.packageIndex}]', '${value.id}');

            double totalShipping = 0.0;

            print(checkoutController.packageCount.value.toString());

            for (int i = 0; i < checkoutController.packageCount.value; i++) {
              totalShipping += double.parse(
                  widget.orderData["shipping_cost[$i]"].toString());
            }

            checkoutController.shipping.value = totalShipping.toPrecision(2);

            checkoutController.grandTotal.value =
                (checkoutController.subTotal.value +
                            checkoutController.shipping.value +
                            checkoutController.gstTotal.value)
                        .toPrecision(2) -
                    checkoutController.discountTotal.value;
          });
        },
      ),
    );
  }
}
