import 'dart:developer';

import 'package:amazy_app/controller/address_book_controller.dart';
import 'package:amazy_app/controller/checkout_controller.dart';
import 'package:amazy_app/controller/login_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/CityList.dart';
import 'package:amazy_app/model/CountryList.dart';
import 'package:amazy_app/model/GeneralSettingsModel.dart';
import 'package:amazy_app/model/StateList.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/Settings/AddressBook.dart';
import 'package:amazy_app/view/cart/checkout/checkout_page_2.dart';
import 'package:amazy_app/view/cart/checkout/checkout_widgets.dart';
import 'package:amazy_app/widgets/CustomInputDecoration.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/PinkButtonWidget.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';

class CheckoutPageOne extends StatefulWidget {
  @override
  State<CheckoutPageOne> createState() => _CheckoutPageOneState();
}

class _CheckoutPageOneState extends State<CheckoutPageOne> {
  final _formKey = GlobalKey<FormState>();
  final AddressController _addressController = Get.put(AddressController());
  final CheckoutController _checkoutController = Get.put(CheckoutController());
  final LoginController _loginController = Get.put(LoginController());
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _zipCtrl = TextEditingController();

  final TextEditingController customerPhoneCtrl = TextEditingController();
  final TextEditingController customerEmailCtrl = TextEditingController();

  @override
  void initState() {
    _nameController.text = _loginController.profileData.value.name ?? "";
    _emailAddressController.text =
        _loginController.profileData.value.email ?? "";
    _phoneNumberController.text =
        _loginController.profileData.value.phone ?? "";

    _checkoutController.orderData.addAll({
      'package_wise_weight': {},
      'package_wise_height': {},
      'package_wise_length': {},
      'package_wise_breadth': {},
      'packagewiseTax': {},
      'shipping_cost': {},
      'delivery_date': {},
      'shipping_method': {},
    });

    if (currencyController.settingsModel.value.pickupLocations.length != 0) {
      if (currencyController.vendorType.value == "single") {
        _checkoutController.selectedPickupValue.value =
            currencyController.settingsModel.value.pickupLocations.first;
      }
    }

    if (_checkoutController.verticalGroupValue.value == "Home Delivery") {
      _checkoutController.deliveryType.value = "home_delivery";
    } else {
      _checkoutController.deliveryType.value = "pickup_location";
      _checkoutController.pickupId.value =
          _checkoutController.selectedPickupValue.value.id;
    }
    _checkoutController.getCheckoutList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          CustomSliverAppBarWidget(true, false),
          SliverToBoxAdapter(
            child: LinearProgressIndicator(
              value: 0.25,
              color: AppStyles.pinkColor,
              backgroundColor: Colors.white,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CheckoutTimelineWidget(
                    isActive: true,
                    text: "Address",
                  ),
                  CheckoutTimelineLineWidget(),
                  CheckoutTimelineWidget(
                    isActive: false,
                    text: "Shipping",
                  ),
                  CheckoutTimelineLineWidget(),
                  CheckoutTimelineWidget(
                    isActive: false,
                    text: "Payment",
                  ),
                  CheckoutTimelineLineWidget(),
                  CheckoutTimelineWidget(
                    isActive: false,
                    text: "Summary",
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  children: [
                    Text(
                      "Personal Address".tr,
                      style: AppStyles.appFontMedium.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Your Name".tr,
                      style: AppStyles.appFontMedium.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: CustomInputDecoration.customInput,
                      validator: (String text) {
                        if (text.isEmpty) {
                          return "Enter your name".tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Email Address".tr,
                      style: AppStyles.appFontMedium.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: TextFormField(
                        controller: _emailAddressController,
                        decoration: CustomInputDecoration.customInput,
                        validator: (String text) {
                          if (text.isEmpty) {
                            return "Enter your email".tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Mobile Number".tr,
                      style: AppStyles.appFontMedium.copyWith(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      child: TextFormField(
                        controller: _phoneNumberController,
                        decoration: CustomInputDecoration.customInput,
                        validator: (String text) {
                          if (text.isEmpty) {
                            return "Enter your phone number".tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      if (_addressController.isLoading.value) {
                        return Center(child: CustomLoadingWidget());
                      } else {
                        customerEmailCtrl.text = _addressController.shippingAddress.value.email;
                        customerPhoneCtrl.text = _addressController.shippingAddress.value.phone;
                        return _addressController.addressCount.value > 0
                            ? Container(
                                child: Column(
                                  children: [
                                    SizedBox(height: 10,),
                                    //** HOME DELIVERY / PICKUP */

                                    currencyController.vendorType.value == "single"
                                        ? RadioGroup<String>.builder(
                                            direction: Axis.horizontal,
                                            horizontalAlignment:
                                                MainAxisAlignment.start,
                                            groupValue: _checkoutController
                                                .verticalGroupValue.value,
                                            onChanged: (value) => setState(() {
                                              _checkoutController
                                                  .verticalGroupValue
                                                  .value = value;

                                              if (_checkoutController
                                                      .verticalGroupValue
                                                      .value ==
                                                  "Home Delivery") {
                                                // _checkoutController.deliveryType
                                                //     .value = "home_delivery";

                                                // double totalShipping = 0.0;

                                                // print(_checkoutController
                                                //     .packageCount.value
                                                //     .toString());

                                                // for (int i = 0;
                                                //     i <
                                                //         _checkoutController
                                                //             .packageCount.value;
                                                //     i++) {
                                                //   if (_checkoutController
                                                //               .orderData[
                                                //           "shipping_cost[$i]"] !=
                                                //       null) {
                                                //     totalShipping += double.parse(
                                                //         _checkoutController
                                                //             .orderData[
                                                //                 "shipping_cost[$i]"]
                                                //             .toString());
                                                //   }
                                                // }

                                                // _checkoutController
                                                //         .shipping.value =
                                                //     totalShipping
                                                //         .toPrecision(2);

                                                _checkoutController
                                                    .calculateShipment();
                                                print(_checkoutController
                                                    .shipping.value);
                                              } else {
                                                _checkoutController.deliveryType
                                                    .value = "pickup_location";
                                                _checkoutController
                                                        .pickupId.value =
                                                    _checkoutController
                                                        .selectedPickupValue
                                                        .value
                                                        .id;

                                                _checkoutController
                                                    .shipping.value = 0.0;
                                              }

                                              _checkoutController.grandTotal
                                                  .value = (_checkoutController
                                                              .subTotal.value +
                                                          _checkoutController
                                                              .shipping.value +
                                                          _checkoutController
                                                              .gstTotal.value)
                                                      .toPrecision(2) -
                                                  _checkoutController
                                                      .discountTotal.value;
                                            }),
                                            items: _checkoutController.status,
                                            itemBuilder: (item) =>
                                                RadioButtonBuilder(
                                              item,
                                            ),
                                            activeColor: Colors.red,
                                          )
                                        : SizedBox.shrink(),

                                    currencyController.vendorType.value ==
                                            "single"
                                        ? _checkoutController
                                                    .verticalGroupValue.value !=
                                                "Home Delivery"
                                            ? ListView(
                                                shrinkWrap: true,
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                children: [
                                                  Text(
                                                    'Select a pickup point'.tr,
                                                    style: AppStyles
                                                        .appFontBlack
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppStyles.pinkColor,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0,
                                                              right: 10.0),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          color: AppStyles
                                                              .appBackgroundColor,
                                                          border: Border.all(
                                                              color: AppStyles
                                                                  .textFieldFillColor)),
                                                      child: DropdownButton<
                                                          PickupLocation>(
                                                        elevation: 1,
                                                        isExpanded: true,
                                                        underline: Container(),
                                                        value: _checkoutController
                                                            .selectedPickupValue
                                                            .value,
                                                        items:
                                                            currencyController
                                                                .settingsModel
                                                                .value
                                                                .pickupLocations
                                                                .map((e) {
                                                          // reasonValue = widget.reasonValue;
                                                          return DropdownMenuItem<
                                                              PickupLocation>(
                                                            child: Text(
                                                                '${e.pickupLocation}'),
                                                            value: e,
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (PickupLocation
                                                                value) {
                                                          setState(() {
                                                            _checkoutController
                                                                .selectedPickupValue
                                                                .value = value;
                                                          });

                                                          _checkoutController
                                                                  .deliveryType
                                                                  .value =
                                                              "pickup_location";
                                                          _checkoutController
                                                                  .pickupId
                                                                  .value =
                                                              _checkoutController
                                                                  .selectedPickupValue
                                                                  .value
                                                                  .id;
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

                                    currencyController.vendorType.value !=
                                            "single"
                                        ? Column(
                                            children: [
                                              ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                                title: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text(
                                                    'Shipping Address'.tr,
                                                    style: AppStyles
                                                        .appFontBlack
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppStyles.pinkColor,
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
                                                      color: AppStyles
                                                          .darkBlueColor,
                                                      width: 17,
                                                      height: 17,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            _addressController
                                                                .shippingAddress
                                                                .value
                                                                .name
                                                                .capitalizeFirst,
                                                            style: AppStyles
                                                                .kFontBlack14w5
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          SizedBox(height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  'Address'.tr +
                                                                      ': ',
                                                              style: AppStyles
                                                                  .kFontGrey14w5
                                                                  .copyWith(
                                                                color: AppStyles
                                                                    .darkBlueColor,
                                                                fontSize: 13,
                                                              ),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '${_addressController.shippingAddress.value.address}',
                                                                  style: AppStyles
                                                                      .kFontGrey14w5
                                                                      .copyWith(
                                                                    fontSize:
                                                                        13,
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
                                                      style: AppStyles
                                                          .appFontBlack
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppStyles.pinkColor,
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
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text(
                                                    'Billing Address'.tr,
                                                    style: AppStyles
                                                        .appFontBlack
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppStyles.pinkColor,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                subtitle: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Image.asset(
                                                        'assets/images/icon_delivery-parcel.png',
                                                        color: AppStyles
                                                            .darkBlueColor,
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            _addressController
                                                                .billingAddress
                                                                .value
                                                                .name
                                                                .capitalizeFirst,
                                                            style: AppStyles
                                                                .kFontBlack14w5
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  'Address'.tr +
                                                                      ': ',
                                                              style: AppStyles
                                                                  .kFontGrey14w5
                                                                  .copyWith(
                                                                color: AppStyles
                                                                    .darkBlueColor,
                                                                fontSize: 13,
                                                              ),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '${_addressController.billingAddress.value.address}',
                                                                  style: AppStyles
                                                                      .kFontGrey14w5
                                                                      .copyWith(
                                                                    fontSize:
                                                                        13,
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
                                                      style: AppStyles
                                                          .appFontBlack
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppStyles.pinkColor,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : _checkoutController
                                                    .verticalGroupValue.value ==
                                                "Home Delivery"
                                            ? ListTile(
                                                contentPadding: EdgeInsets.zero,
                                                dense: true,
                                                title: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text(
                                                    'Shipping Address'.tr,
                                                    style: AppStyles
                                                        .appFontBlack
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppStyles.pinkColor,
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
                                                      color: AppStyles
                                                          .darkBlueColor,
                                                      width: 17,
                                                      height: 17,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            _addressController.shippingAddress.value.name.capitalizeFirst,
                                                            style: AppStyles.kFontBlack14w5.copyWith(
                                                              fontWeight: FontWeight.w600,),
                                                          ),
                                                          SizedBox(height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  'Address'.tr +
                                                                      ': ',
                                                              style: AppStyles
                                                                  .kFontGrey14w5
                                                                  .copyWith(
                                                                color: AppStyles
                                                                    .darkBlueColor,
                                                                fontSize: 13,
                                                              ),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '${_addressController.shippingAddress.value.address}',
                                                                  style: AppStyles
                                                                      .kFontGrey14w5
                                                                      .copyWith(
                                                                    fontSize:
                                                                        13,
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
                                                      style: AppStyles
                                                          .appFontBlack
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppStyles.pinkColor,
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
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text(
                                                    'Billing Address'.tr,
                                                    style: AppStyles
                                                        .appFontBlack
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          AppStyles.pinkColor,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                subtitle: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Image.asset(
                                                        'assets/images/icon_delivery-parcel.png',
                                                        color: AppStyles
                                                            .darkBlueColor,
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            _addressController
                                                                .billingAddress
                                                                .value
                                                                .name
                                                                .capitalizeFirst,
                                                            style: AppStyles
                                                                .kFontBlack14w5
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          SizedBox(height: 8),
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  'Address'.tr +
                                                                      ': ',
                                                              style: AppStyles
                                                                  .kFontGrey14w5
                                                                  .copyWith(
                                                                color: AppStyles
                                                                    .darkBlueColor,
                                                                fontSize: 13,
                                                              ),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                  text:
                                                                      '${_addressController.billingAddress.value.address}',
                                                                  style: AppStyles
                                                                      .kFontGrey14w5
                                                                      .copyWith(
                                                                    fontSize:
                                                                        13,
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
                                                      style: AppStyles
                                                          .appFontBlack
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppStyles.pinkColor,
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
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Shipping Address".tr,
                                    style: AppStyles.appFontMedium.copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Country".tr,
                                    style: AppStyles.appFontMedium.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Obx(() {
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                          color:
                                              Color.fromARGB(45, 253, 73, 73),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      height: 45,
                                      width: Get.width,
                                      child: _addressController
                                              .countryLoading.value
                                          ? CupertinoActivityIndicator()
                                          : DropdownButton<Country>(
                                              elevation: 1,
                                              isExpanded: true,
                                              underline: Container(),
                                              items: _addressController
                                                  .countryList
                                                  .map((item) {
                                                return DropdownMenuItem<
                                                    Country>(
                                                  value: item,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                      item.name,
                                                      style:
                                                          AppStyles.appFontBook,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium
                                                  .copyWith(fontSize: 15.0),
                                              onChanged: (value) async {
                                                _addressController
                                                    .selectedCountry
                                                    .value = value;
                                                await _addressController
                                                    .getStates(value.id);
                                              },
                                              value: _addressController
                                                  .selectedCountry.value,
                                            ),
                                    );
                                  }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "State".tr,
                                    style: AppStyles.appFontMedium.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Obx(() {
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                          color:
                                              Color.fromARGB(45, 253, 73, 73),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      height: 45,
                                      width: Get.width,
                                      child: _addressController
                                              .stateLoading.value
                                          ? CupertinoActivityIndicator()
                                          : DropdownButton<AllState>(
                                              elevation: 1,
                                              isExpanded: true,
                                              underline: Container(),
                                              items: _addressController
                                                  .statesList
                                                  .map((item) {
                                                return DropdownMenuItem<
                                                    AllState>(
                                                  value: item,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(item.name,
                                                        style: AppStyles
                                                            .appFontBook),
                                                  ),
                                                );
                                              }).toList(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium
                                                  .copyWith(fontSize: 15.0),
                                              onChanged: (value) async {
                                                _addressController.selectedState
                                                    .value = value;
                                                await _addressController
                                                    .getCities(value.id);
                                              },
                                              value: _addressController
                                                  .selectedState.value,
                                            ),
                                    );
                                  }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "City".tr,
                                    style: AppStyles.appFontMedium.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Obx(() {
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                          color:
                                              Color.fromARGB(45, 253, 73, 73),
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                      height: 45,
                                      width: Get.width,
                                      child: _addressController
                                              .cityLoading.value
                                          ? CupertinoActivityIndicator()
                                          : DropdownButton<AllCity>(
                                              elevation: 1,
                                              isExpanded: true,
                                              underline: Container(),
                                              items: _addressController
                                                  .citiesList
                                                  .map((item) {
                                                return DropdownMenuItem<
                                                    AllCity>(
                                                  value: item,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(item.name,
                                                        style: AppStyles
                                                            .appFontBook),
                                                  ),
                                                );
                                              }).toList(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium
                                                  .copyWith(fontSize: 15.0),
                                              onChanged: (value) {
                                                _addressController
                                                    .selectedCity.value = value;
                                              },
                                              value: _addressController
                                                  .selectedCity.value,
                                            ),
                                    );
                                  }),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Address".tr,
                                    style: AppStyles.appFontMedium.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: TextFormField(
                                      controller: _addressCtrl,
                                      maxLines: 3,
                                      decoration:
                                          CustomInputDecoration.customInput,
                                      validator: (String text) {
                                        if (text.isEmpty) {
                                          return "Enter your address".tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Postal/Zip Code".tr,
                                    style: AppStyles.appFontMedium.copyWith(
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: TextFormField(
                                      controller: _zipCtrl,
                                      maxLines: 1,
                                      decoration:
                                          CustomInputDecoration.customInput,
                                      validator: (String text) {
                                        if (text.isEmpty) {
                                          return "Enter your Postal/Zip Code"
                                              .tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                      }
                    }),
                    SizedBox(height: 20,),

                    Obx(() {
                      if (_addressController.isLoading.value) {
                        return SizedBox.shrink();
                      } else {
                        return Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: Get.width,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppStyles.pinkColor,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      "Back",
                                      textAlign: TextAlign.center,
                                      style: AppStyles.appFontBook.copyWith(
                                        color: AppStyles.pinkColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: PinkButtonWidget(
                                btnOnTap: () async {
                                  if (!_formKey.currentState.validate()) {
                                    return;
                                  } else {
                                    _checkoutController.orderData.addAll({
                                      'customer_email':
                                          '${_emailAddressController.text}',
                                      'customer_phone':
                                          '${_phoneNumberController.text}',
                                      'customer_name':
                                          '${_nameController.text}',
                                      'number_of_item':
                                          _checkoutController.totalQty.value,
                                      'number_of_package': _checkoutController
                                          .packageCount.value,
                                      'sub_total':
                                          _checkoutController.subTotal.value,
                                      'discount_total': _checkoutController
                                          .discountTotal.value,
                                      'tax_total':
                                          _checkoutController.gstTotal.value,
                                      'delivery_type': _checkoutController
                                          .deliveryType.value,
                                      'pickup_location_id':
                                          _checkoutController.pickupId.value,
                                    });

                                    if (_addressController.addressCount.value >
                                        0) {
                                      _checkoutController.orderData.addAll({
                                        'customer_shipping_address':
                                            _addressController
                                                .shippingAddress.value.id,
                                        'customer_billing_address':
                                            _addressController
                                                .billingAddress.value.id,
                                      });

                                      Get.to(() => CheckoutPageTwo());
                                    } else {
                                      Map data = {
                                        "name": _nameController.text,
                                        "email": _emailAddressController.text,
                                        "address": _addressCtrl.text,
                                        "phone": _phoneNumberController.text,
                                        "city": _addressController
                                            .selectedCity.value.id,
                                        "state": _addressController
                                            .selectedState.value.id,
                                        "country": _addressController
                                            .selectedCountry.value.id,
                                        "postal_code": _zipCtrl.text
                                      };

                                      await _addressController
                                          .addAddress(data)
                                          .then((value) async {
                                        await _addressController
                                            .getAllAddress()
                                            .then((value) {
                                          _checkoutController.orderData.addAll({
                                            'customer_shipping_address':
                                                _addressController
                                                    .shippingAddress.value.id,
                                            'customer_billing_address':
                                                _addressController
                                                    .billingAddress.value.id,
                                          });

                                          log(_checkoutController.orderData
                                              .toString());

                                          Get.to(() => CheckoutPageTwo());
                                        });
                                      });
                                    }
                                  }
                                },
                                height: 45,
                                width: Get.width,
                                btnText: "Next",
                              ),
                            ),
                          ],
                        );
                      }
                    }),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
