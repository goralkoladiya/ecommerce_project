import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:amazy_app/AppConfig/api_keys.dart';
import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/account_controller.dart';
import 'package:amazy_app/controller/address_book_controller.dart';
import 'package:amazy_app/controller/checkout_controller.dart';
import 'package:amazy_app/controller/login_controller.dart';
import 'package:amazy_app/controller/otp_controller.dart';
import 'package:amazy_app/controller/payment_gateway_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/Cart/MyCheckoutModel.dart';
import 'package:amazy_app/model/GpayTokenModel.dart';
import 'package:amazy_app/model/Product/ProductType.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/authentication/OtpVerificationPage.dart';
import 'package:amazy_app/view/cart/checkout/checkout_widgets.dart';
import 'package:amazy_app/view/payment/bank_payment_sheet.dart';
import 'package:amazy_app/view/payment/gpay_service.dart';
import 'package:amazy_app/view/payment/instamojo_payment.dart';
import 'package:amazy_app/view/payment/jazzcash.dart';
import 'package:amazy_app/view/payment/midtrans_payment.dart';
import 'package:amazy_app/view/payment/paypal/paypal_payment.dart';
import 'package:amazy_app/view/payment/paytm_service.dart';
import 'package:amazy_app/view/payment/razorpay_sheet.dart';
import 'package:amazy_app/view/payment/stripe/stripe_payment.dart';
import 'package:amazy_app/view/settings/AddressBook.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/PinkButtonWidget.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';

class CheckoutPageFour extends StatefulWidget {
  final List<PaymentItem> gpayItems;
  CheckoutPageFour({this.gpayItems});
  @override
  State<CheckoutPageFour> createState() => _CheckoutPageFourState();
}

class _CheckoutPageFourState extends State<CheckoutPageFour> {
  final CheckoutController _checkoutController = Get.put(CheckoutController());
  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());
  final AddressController _addressController = Get.put(AddressController());
  final PaymentGatewayController _paymentController =
      Get.put(PaymentGatewayController());

  final LoginController _loginController = Get.put(LoginController());
  final AccountController _accountController = Get.put(AccountController());

  final plugin = PaystackPlugin();

  @override
  void initState() {
    log("------" * 10);
    log("${_checkoutController.orderData.toJson().toString()}");
    log("------" * 10);
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
              value: 1.0,
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
                    isActive: true,
                    text: "Shipping",
                  ),
                  CheckoutTimelineLineWidget(),
                  CheckoutTimelineWidget(
                    isActive: true,
                    text: "Payment",
                  ),
                  CheckoutTimelineLineWidget(),
                  CheckoutTimelineWidget(
                    isActive: true,
                    text: "Summary",
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "All Summary".tr,
                        style: AppStyles.appFontMedium.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(() {
                        return _checkoutController
                                    .checkoutModel.value.packages !=
                                null
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: _checkoutController
                                    .checkoutModel.value.packages.values.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 100,
                                    child: ListView.separated(
                                        separatorBuilder: (contxt, index) {
                                          return SizedBox(
                                            width: 10,
                                          );
                                        },
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.zero,
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: _checkoutController
                                            .checkoutModel.value.packages.values
                                            .elementAt(index)
                                            .items
                                            .length,
                                        itemBuilder: (context, productIndex) {
                                          List<CheckoutItem> checkoutItem =
                                              _checkoutController.checkoutModel
                                                  .value.packages.values
                                                  .elementAt(index)
                                                  .items;

                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              clipBehavior: Clip.antiAlias,
                                              child: Container(
                                                height: 60,
                                                width: 90,
                                                padding: EdgeInsets.all(5),
                                                color: Color(0xffF1F1F1),
                                                child: checkoutItem[
                                                                productIndex]
                                                            .productType ==
                                                        ProductType.PRODUCT
                                                    ? checkoutItem[productIndex]
                                                                .product
                                                                .sku
                                                                .variantImage !=
                                                            null
                                                        ? FancyShimmerImage(
                                                            imageUrl: AppConfig
                                                                    .assetPath +
                                                                '/' +
                                                                checkoutItem[
                                                                        productIndex]
                                                                    .product
                                                                    .sku
                                                                    .variantImage,
                                                            boxFit:
                                                                BoxFit.contain,
                                                            errorWidget:
                                                                FancyShimmerImage(
                                                              imageUrl:
                                                                  "${AppConfig.assetPath}/backend/img/default.png",
                                                              boxFit: BoxFit
                                                                  .contain,
                                                            ),
                                                          )
                                                        : FancyShimmerImage(
                                                            imageUrl: AppConfig
                                                                    .assetPath +
                                                                '/' +
                                                                checkoutItem[
                                                                        productIndex]
                                                                    .product
                                                                    .product
                                                                    .product
                                                                    .thumbnailImageSource,
                                                            boxFit:
                                                                BoxFit.contain,
                                                            errorWidget:
                                                                FancyShimmerImage(
                                                              imageUrl:
                                                                  "${AppConfig.assetPath}/backend/img/default.png",
                                                              boxFit: BoxFit
                                                                  .contain,
                                                            ),
                                                          )
                                                    : FancyShimmerImage(
                                                        imageUrl: AppConfig
                                                                .assetPath +
                                                            '/' +
                                                            checkoutItem[
                                                                    productIndex]
                                                                .giftCard
                                                                .thumbnailImage,
                                                        boxFit: BoxFit.contain,
                                                        errorWidget:
                                                            FancyShimmerImage(
                                                          imageUrl:
                                                              "${AppConfig.assetPath}/backend/img/default.png",
                                                          boxFit:
                                                              BoxFit.contain,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                                })
                            : SizedBox.shrink();
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Personal Address".tr,
                            style: AppStyles.appFontMedium.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            "assets/images/check.png",
                            width: 15,
                            height: 15,
                          ),
                          Expanded(child: Container()),
                          InkWell(
                            onTap: () {
                              Get.back();
                              Get.back();
                              Get.back();
                            },
                            child: Container(
                              child: Text(
                                'Change'.tr,
                                style: AppStyles.appFontMedium.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppStyles.pinkColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${_checkoutController.orderData['customer_name']}".tr,
                        style: AppStyles.appFontBook.copyWith(
                            fontSize: 14, color: AppStyles.greyColorAlt),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${_checkoutController.orderData['customer_email']}".tr,
                        style: AppStyles.appFontBook.copyWith(
                            fontSize: 14, color: AppStyles.greyColorAlt),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        "${_checkoutController.orderData['customer_phone']}".tr,
                        style: AppStyles.appFontBook.copyWith(
                            fontSize: 14, color: AppStyles.greyColorAlt),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _checkoutController.verticalGroupValue.value ==
                                    "Home Delivery"
                                ? Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Shipping Address".tr,
                                            style: AppStyles.appFontMedium
                                                .copyWith(
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Image.asset(
                                            "assets/images/check.png",
                                            width: 15,
                                            height: 15,
                                          ),
                                          Expanded(child: Container()),
                                          InkWell(
                                            onTap: () {
                                              Get.to(() => AddressBook());
                                            },
                                            child: Container(
                                              child: Text(
                                                'Change'.tr,
                                                style: AppStyles.appFontMedium
                                                    .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: AppStyles.pinkColor,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Obx(() {
                                        return ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          dense: true,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _addressController
                                                          .shippingAddress
                                                          .value
                                                          .name
                                                          .capitalizeFirst,
                                                      style: AppStyles
                                                          .appFontBook
                                                          .copyWith(
                                                              fontSize: 14,
                                                              color: AppStyles
                                                                  .greyColorAlt),
                                                    ),
                                                    SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      _addressController
                                                          .shippingAddress
                                                          .value
                                                          .address,
                                                      style: AppStyles
                                                          .appFontBook
                                                          .copyWith(
                                                              fontSize: 14,
                                                              color: AppStyles
                                                                  .greyColorAlt),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Obx(() {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Billing Address".tr,
                                                  style: AppStyles.appFontMedium
                                                      .copyWith(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Image.asset(
                                                  "assets/images/check.png",
                                                  width: 15,
                                                  height: 15,
                                                ),
                                                Expanded(child: Container()),
                                                InkWell(
                                                  onTap: () {
                                                    Get.to(() => AddressBook());
                                                  },
                                                  child: Container(
                                                    child: Text(
                                                      'Change'.tr,
                                                      style: AppStyles
                                                          .appFontMedium
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppStyles.pinkColor,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              dense: true,
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
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
                                                              .appFontBook
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  color: AppStyles
                                                                      .greyColorAlt),
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          _addressController
                                                              .billingAddress
                                                              .value
                                                              .address,
                                                          style: AppStyles
                                                              .appFontBook
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  color: AppStyles
                                                                      .greyColorAlt),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Pickup From".tr,
                                                  style: AppStyles.appFontMedium
                                                      .copyWith(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Image.asset(
                                                  "assets/images/check.png",
                                                  width: 15,
                                                  height: 15,
                                                ),
                                                Expanded(child: Container()),
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                    Get.back();
                                                    Get.back();
                                                  },
                                                  child: Container(
                                                    child: Text(
                                                      'Change'.tr,
                                                      style: AppStyles
                                                          .appFontMedium
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color:
                                                            AppStyles.pinkColor,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              dense: true,
                                              title: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _checkoutController
                                                              .selectedPickupValue
                                                              .value
                                                              .name
                                                              .capitalizeFirst,
                                                          style: AppStyles
                                                              .appFontBook
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  color: AppStyles
                                                                      .greyColorAlt),
                                                        ),
                                                        SizedBox(
                                                          height: 2,
                                                        ),
                                                        Text(
                                                          _checkoutController
                                                              .selectedPickupValue
                                                              .value
                                                              .address,
                                                          style: AppStyles
                                                              .appFontBook
                                                              .copyWith(
                                                                  fontSize: 14,
                                                                  color: AppStyles
                                                                      .greyColorAlt),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Payment Method".tr,
                                  style: AppStyles.appFontMedium.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  "assets/images/check.png",
                                  width: 15,
                                  height: 15,
                                ),
                                Expanded(child: Container()),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    child: Text(
                                      'Change'.tr,
                                      style: AppStyles.appFontMedium.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: AppStyles.pinkColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 35,
                                  width: 50,
                                  child: FadeInImage(
                                    image: NetworkImage(AppConfig.assetPath +
                                        '/' +
                                        _checkoutController.orderData['payment_method_logo']),
                                    placeholder:
                                        AssetImage("${AppConfig.appBanner}"),
                                    fit: BoxFit.fitWidth,
                                    imageErrorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Image.asset(
                                          '${AppConfig.appBanner}');
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${_checkoutController.orderData['payment_method_name']}",
                                  style: AppStyles.appFontBook.copyWith(
                                      fontSize: 14,
                                      color: AppStyles.greyColorAlt),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Obx(() {
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Coupon".tr,
                                    style: AppStyles.appFontMedium.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  _checkoutController.couponApplied.value
                                      ? Image.asset(
                                          "assets/images/check.png",
                                          width: 15,
                                          height: 15,
                                        )
                                      : SizedBox.shrink(),
                                  Expanded(child: Container()),
                                  _checkoutController.couponApplied.value
                                      ? InkWell(
                                          onTap: () {
                                            _checkoutController.removeCoupon();
                                          },
                                          child: Container(
                                            child: Text(
                                              'Remove'.tr,
                                              style: AppStyles.appFontMedium
                                                  .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppStyles.pinkColor,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _checkoutController.couponApplied.value
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Coupon Discount'.tr,
                                          style: AppStyles.appFontBook
                                              .copyWith(color: Colors.green),
                                        ),
                                        Expanded(child: Container()),
                                        Text(
                                          '${(_checkoutController.couponDiscount.value * _settingsController.conversionRate.value).toStringAsFixed(2)}${_settingsController.appCurrency.value}',
                                          style: AppStyles.appFontBook
                                              .copyWith(color: Colors.green),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Flexible(
                                          child: Container(
                                            height: 45,
                                            child: TextField(
                                              autofocus: false,
                                              scrollPhysics:
                                                  AlwaysScrollableScrollPhysics(),
                                              controller: _checkoutController
                                                  .couponCodeTextController,
                                              decoration: InputDecoration(
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.auto,
                                                hintText:
                                                    'Enter coupon/voucher code'
                                                        .tr,
                                                fillColor: AppStyles
                                                    .appBackgroundColor,
                                                filled: true,
                                                isDense: true,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppStyles
                                                        .textFieldFillColor,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppStyles
                                                        .textFieldFillColor,
                                                  ),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppStyles
                                                        .textFieldFillColor,
                                                  ),
                                                ),
                                                hintStyle: AppStyles
                                                    .kFontGrey12w5
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
                                            _checkoutController.applyCoupon();
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
                                                    color: AppStyles
                                                        .greyColorDark)),
                                            child: Text(
                                              'Apply'.tr,
                                              textAlign: TextAlign.center,
                                              style: AppStyles.appFontMedium
                                                  .copyWith(
                                                color: AppStyles.greyColorDark,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: AppStyles.gradient,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Obx(() {
                          return Text(
                            "Total".tr +
                                ": " +
                                "${(_checkoutController.grandTotal.value * _settingsController.conversionRate.value).toStringAsFixed(2)}${_settingsController.appCurrency.value}",
                            style: AppStyles.appFontBold.copyWith(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _checkoutController.removeCoupon();
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
                      Obx(() {
                        if (_paymentController.isPaymentProcessing.value) {
                          return Expanded(
                            child: PinkButtonWidget(
                              height: 45,
                              width: Get.width,
                              btnText: "Processing".tr + "...",
                            ),
                          );
                        } else {
                          return _paymentController.selectedGateway.value.id ==
                                  13
                              ? Platform.isAndroid
                                  ? GooglePayButton(
                                      width: 100,
                                      height: 50,
                                      onError: (Object error) {
                                        debugPrint(error.toString());
                                      },
                                      childOnError: const Text('errror'),
                                      onPressed: () {
                                        debugPrint('pressed');
                                      },
                                      paymentConfigurationAsset:
                                          "payment/google_pay.json",
                                      paymentItems: widget.gpayItems,
                                      // style: GooglePayButtonStyle.white,
                                      type: GooglePayButtonType.pay,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      onPaymentResult: (paymentResult) async {
                                        final data = jsonEncode(paymentResult);
                                        final gpayTokenModel =
                                            gpayTokenModelFromJson(data);

                                        final tokenModel = tokenFromJson(
                                            jsonDecode(jsonEncode(gpayTokenModel
                                                .paymentMethodData
                                                .tokenizationData
                                                .token)));

                                        log(tokenModel.id);

                                        await GooglePaymentIntentConfirm()
                                            .postGpayPaymentIntent(
                                                email: _addressController
                                                    .billingAddress.value.email,
                                                orderAmount: _checkoutController
                                                    .orderData['grand_total']
                                                    .toString(),
                                                token: tokenModel.id)
                                            .then((value) async {
                                          print(value.paymentIntent.id);

                                          Map payment = {
                                            'amount': _checkoutController
                                                .orderData['grand_total'],
                                            'payment_method': _paymentController
                                                .selectedGateway.value.id,
                                            'transection_id':
                                                '${value.paymentIntent.id}'
                                          };

                                          await _paymentController
                                              .paymentInfoStore(
                                            orderData:
                                                _checkoutController.orderData,
                                            paymentData: payment,
                                            transactionID:
                                                value.paymentIntent.id,
                                          );
                                        });
                                      },
                                      loadingIndicator: Center(
                                        child: CustomLoadingWidget(),
                                      ),
                                    )
                                  : Expanded(
                                      child: ApplePayButton(
                                        width: Get.width,
                                        height: 45,
                                        paymentConfigurationAsset:
                                            'payment/apple_pay.json',
                                        paymentItems: widget.gpayItems,
                                        style: ApplePayButtonStyle.black,
                                        type: ApplePayButtonType.buy,
                                        onPaymentResult: (paymentResult) {
                                          debugPrint(paymentResult.toString());
                                        },
                                        loadingIndicator: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    )
                              : Expanded(
                                  child: PinkButtonWidget(
                                    height: 45,
                                    width: Get.width,
                                    btnText: "Next",
                                    btnOnTap: () async {
                                      // Get.dialog(OrderConfirmedDialog());
                                      // return;

                                      print(_paymentController
                                          .selectedGateway.value.id);

                                      /// Cash on delivery
                                      if (_paymentController
                                              .selectedGateway.value.id ==
                                          1) {
                                        _checkoutController.orderData.addAll({
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                        });
                                        Map payment = {
                                          'amount': _checkoutController
                                              .orderData['grand_total'],
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                        };

                                        if (_settingsController
                                            .otpOnOrderWithCod.value) {
                                          int cancelOrders = _accountController
                                              .customerData
                                              .value
                                              .cancelOrderCount;

                                          if (_loginController.profileData.value
                                                      .isVerified ==
                                                  1 &&
                                              _settingsController
                                                  .otpOrderOnVerifiedCustomer
                                                  .value &&
                                              _settingsController
                                                      .orderCancelLimitOnVerified
                                                      .value <
                                                  cancelOrders) {
                                            Map data = {
                                              "type": "otp_on_order_with_cod",
                                              "email": _checkoutController
                                                  .orderData['customer_email'],
                                              "name": _checkoutController
                                                  .orderData['customer_name'],
                                              "phone": _checkoutController
                                                  .orderData['customer_phone'],
                                            };

                                            final OtpController otpController =
                                                Get.put(OtpController());

                                            EasyLoading.show(
                                                maskType:
                                                    EasyLoadingMaskType.none,
                                                indicator:
                                                    CustomLoadingWidget());

                                            await otpController
                                                .generateOtp(data)
                                                .then((value) {
                                              if (value == true) {
                                                EasyLoading.dismiss();
                                                Get.to(() =>
                                                    OtpVerificationPage(
                                                      data: data,
                                                      onSuccess:
                                                          (result) async {
                                                        if (result == true) {
                                                          await _paymentController
                                                              .paymentInfoStore(
                                                                  paymentData:
                                                                      payment,
                                                                  orderData:
                                                                      _checkoutController
                                                                          .orderData);
                                                        }
                                                      },
                                                    ));
                                              } else {
                                                EasyLoading.dismiss();
                                                SnackBars().snackBarWarning(
                                                    value.toString());
                                              }
                                            });
                                          } else if (_loginController
                                                  .profileData
                                                  .value
                                                  .isVerified ==
                                              0) {
                                            Map data = {
                                              "type": "otp_on_order_with_cod",
                                              "email": _checkoutController
                                                  .orderData['customer_email'],
                                              "name": _checkoutController
                                                  .orderData['customer_name'],
                                              "phone": _checkoutController
                                                  .orderData['customer_phone'],
                                            };

                                            final OtpController otpController =
                                                Get.put(OtpController());

                                            EasyLoading.show(
                                                maskType:
                                                    EasyLoadingMaskType.none,
                                                indicator:
                                                    CustomLoadingWidget());

                                            await otpController
                                                .generateOtp(data)
                                                .then((value) {
                                              if (value == true) {
                                                EasyLoading.dismiss();
                                                Get.to(() =>
                                                    OtpVerificationPage(
                                                      data: data,
                                                      onSuccess:
                                                          (result) async {
                                                        if (result == true) {
                                                          await _paymentController
                                                              .paymentInfoStore(
                                                                  paymentData:
                                                                      payment,
                                                                  orderData:
                                                                      _checkoutController
                                                                          .orderData);
                                                        }
                                                      },
                                                    ));
                                              } else {
                                                EasyLoading.dismiss();
                                                SnackBars().snackBarWarning(
                                                    value.toString());
                                              }
                                            });
                                          }
                                        } else {
                                          await _paymentController
                                              .paymentInfoStore(
                                                  paymentData: payment,
                                                  orderData: _checkoutController
                                                      .orderData);
                                        }
                                      }

                                      /// Wallet
                                      else if (_paymentController
                                              .selectedGateway.value.id ==
                                          2) {
                                        final AccountController
                                            _accountController =
                                            Get.put(AccountController());

                                        await _accountController
                                            .getAccountDetails()
                                            .then((value) async {
                                          if (double.parse(_checkoutController
                                                      .orderData['grand_total']
                                                      .toString())
                                                  .toDouble() >
                                              _accountController.customerData
                                                  .value.walletRunningBalance) {
                                            SnackBars().snackBarWarning(
                                                "You dont have sufficient wallet balance"
                                                    .tr);
                                          } else {
                                            _checkoutController.orderData
                                                .addAll({
                                              'wallet_amount':
                                                  _accountController
                                                      .customerData
                                                      .value
                                                      .walletRunningBalance,
                                              'payment_method': 2,
                                            });
                                            log(_checkoutController.orderData
                                                .toString());

                                            Map payment = {
                                              'amount': _checkoutController
                                                  .orderData['grand_total'],
                                              'payment_method':
                                                  _paymentController
                                                      .selectedGateway.value.id,
                                            };

                                            await _paymentController
                                                .paymentInfoStore(
                                                    paymentData: payment,
                                                    orderData:
                                                        _checkoutController
                                                            .orderData);
                                          }
                                        });
                                      }

                                      ///Paypal
                                      else if (_paymentController
                                              .selectedGateway.value.id ==
                                          3) {
                                        Map payment = {
                                          'amount': _checkoutController
                                              .orderData['grand_total'],
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                        };
                                        _checkoutController.orderData
                                            .addAll({'payment_method': 3});
                                        Get.to(
                                          () => PaypalPayment(
                                            onFinish: (number) async {
                                              payment.addAll({
                                                'transection_id': number,
                                              });
                                              await _paymentController
                                                  .paymentInfoStore(
                                                      orderData:
                                                          _checkoutController
                                                              .orderData,
                                                      paymentData: payment,
                                                      transactionID: number);
                                            },
                                          ),
                                        );
                                      }

                                      ///Stripe
                                      else if (_paymentController
                                              .selectedGateway.value.id ==
                                          4) {
                                        _checkoutController.orderData.addAll({
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                        });
                                        Map payment = {
                                          'amount': _checkoutController
                                              .orderData['grand_total'],
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                        };
                                        Get.bottomSheet(
                                          StripePaymentScreen(
                                            orderData:
                                                _checkoutController.orderData,
                                            paymentData: payment,
                                            onFinish: (onFinish) async {
                                              print(onFinish['id']);

                                              payment.addAll({
                                                'transection_id':
                                                    '${onFinish['id']}'
                                              });

                                              log(payment.toString());

                                              await _paymentController
                                                  .paymentInfoStore(
                                                      orderData:
                                                          _checkoutController
                                                              .orderData,
                                                      paymentData: payment,
                                                      transactionID:
                                                          onFinish['id']);
                                            },
                                          ),
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          ignoreSafeArea: false,
                                          persistent: true,
                                        );
                                      }

                                      ///PayStack
                                      else if (_paymentController
                                              .selectedGateway.value.id ==
                                          5) {
                                        _checkoutController.orderData.addAll({
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                        });
                                        final finalAmount = (_checkoutController
                                                    .orderData['grand_total'] *
                                                100)
                                            .toInt();
                                        Charge charge = Charge()
                                          ..amount = finalAmount
                                          ..currency = 'ZAR'
                                          ..reference = _getReference()
                                          ..email = _checkoutController
                                              .orderData['customer_email'];
                                        CheckoutResponse response =
                                            await plugin.checkout(
                                          context,
                                          method: CheckoutMethod.card,
                                          // Defaults to CheckoutMethod.selectable
                                          charge: charge,
                                        );

                                        if (response.status == true) {
                                          print(response.reference);
                                          Map payment = {
                                            'amount': _checkoutController
                                                .orderData['grand_total'],
                                            'payment_method': _paymentController
                                                .selectedGateway.value.id,
                                            'transection_id':
                                                response.reference,
                                          };
                                          await _paymentController
                                              .paymentInfoStore(
                                                  orderData: _checkoutController
                                                      .orderData,
                                                  paymentData: payment,
                                                  transactionID:
                                                      response.reference);
                                        } else {
                                          SnackBars().snackBarWarning(
                                              response.message);
                                        }
                                      }

                                      ///Razorpay
                                      else if (_paymentController
                                              .selectedGateway.value.id ==
                                          6) {
                                        _checkoutController.orderData.addAll({
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                        });
                                        Get.bottomSheet(
                                          RazorpaySheet(
                                            orderData:
                                                _checkoutController.orderData,
                                          ),
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          persistent: true,
                                        );
                                      }

                                      ///Bank Payment
                                      else if (_paymentController
                                              .selectedGateway.value.id ==
                                          7) {
                                        _checkoutController.orderData.addAll({
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                        });
                                        await _paymentController.getBankInfo();
                                        Get.bottomSheet(
                                          BankPaymentSheet(
                                            orderData:
                                                _checkoutController.orderData,
                                          ),
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          persistent: true,
                                        );
                                      }

                                      ///Instamojo
                                      else if (_paymentController
                                              .selectedGateway.value.id ==
                                          8) {
                                        Map payment = {
                                          'amount': _checkoutController
                                              .orderData['grand_total'],
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                        };
                                        _checkoutController.orderData
                                            .addAll({'payment_method': 8});
                                        Get.to(
                                          () => InstaMojoPayment(
                                            orderData:
                                                _checkoutController.orderData,
                                            paymentData: payment,
                                            onFinish: (number) async {
                                              if (number != null) {
                                                payment.addAll({
                                                  'transection_id': number,
                                                });
                                                print(payment);
                                                await _paymentController
                                                    .paymentInfoStore(
                                                        orderData:
                                                            _checkoutController
                                                                .orderData,
                                                        paymentData: payment,
                                                        transactionID: number);
                                              }
                                            },
                                          ),
                                        );
                                      }

                                      ///PayTM
                                      else if (_paymentController
                                              .selectedGateway.value.id ==
                                          9) {
                                        _checkoutController.orderData
                                            .addAll({'payment_method': 9});

                                        final orderId =
                                            "PayTM_${DateTime.now().millisecondsSinceEpoch}";

                                        String callBackUrl = (payTmIsTesting
                                                ? 'https://securegw-stage.paytm.in'
                                                : 'https://securegw.paytm.in') +
                                            '/theia/paytmCallback?ORDER_ID=' +
                                            orderId;

                                        Map payment = {
                                          'orderId': orderId,
                                          'amount': double.parse(
                                                  _checkoutController
                                                      .orderData['grand_total']
                                                      .toString())
                                              .toStringAsFixed(2),
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                          "custID": "USER_" +
                                              _addressController.shippingAddress
                                                  .value.customerId
                                                  .toString(),
                                          "custEmail": _checkoutController
                                              .orderData['customer_email'],
                                          "custPhone": _checkoutController
                                              .orderData['customer_phone'],
                                          'callbackUrl': callBackUrl,
                                        };

                                        await PayTmService().payTmPayment(
                                            trxData: payment,
                                            orderData:
                                                _checkoutController.orderData);
                                      }

                                      ///Midtrans
                                      else if (_paymentController
                                              .selectedGateway.value.id ==
                                          10) {
                                        _checkoutController.orderData
                                            .addAll({'payment_method': 10});

                                        Map payment = {
                                          'amount': _checkoutController
                                              .orderData['grand_total'],
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                        };

                                        Get.to(
                                          () => MidTransPaymentPage(
                                            orderData:
                                                _checkoutController.orderData,
                                            paymentData: payment,
                                            onFinish: (number) async {
                                              if (number != null) {
                                                payment.addAll({
                                                  'transection_id': number,
                                                });
                                                print(payment);
                                                await _paymentController
                                                    .paymentInfoStore(
                                                        orderData:
                                                            _checkoutController
                                                                .orderData,
                                                        paymentData: payment,
                                                        transactionID: number);
                                              }
                                            },
                                          ),
                                        );
                                      }

                                      ///PayUMoney
                                      else if (_paymentController
                                              .selectedGateway.value.id ==
                                          11) {
                                        _checkoutController.orderData
                                            .addAll({'payment_method': 11});

                                        // Map payment = {
                                        //   'amount': _checkoutController.checkoutData['grand_total'],
                                        //   'payment_method': _paymentController.selectedGateway.value.id,
                                        // };

                                        // await initPlatformState();
                                      }

                                      ///Jazzcash
                                      else if (_paymentController
                                              .selectedGateway.value.id ==
                                          12) {
                                        _checkoutController.orderData.addAll({
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                        });
                                        Get.bottomSheet(
                                          JazzCashSheet(
                                            orderData:
                                                _checkoutController.orderData,
                                          ),
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          persistent: true,
                                        );
                                      }

                                      ///Flutter wave
                                      else if (_paymentController
                                              .selectedGateway.value.id ==
                                          14) {
                                        final AddressController
                                            addressController =
                                            Get.put(AddressController());
                                        _checkoutController.orderData.addAll({
                                          'payment_method': _paymentController
                                              .selectedGateway.value.id,
                                        });
                                        try {
                                          final String currency = "NGN";

                                          Flutterwave flutterwave = Flutterwave(
                                            context: this.context,
                                            publicKey: flutterWavePublicKey,
                                            currency: currency,
                                            paymentOptions:
                                                "card, payattitude, barter",
                                            customization: Customization(
                                                title: "Cart Payment"),
                                            amount: _checkoutController
                                                .orderData['grand_total']
                                                .toString(),
                                            customer: Customer(
                                                name: addressController
                                                    .shippingAddress.value.name,
                                                phoneNumber: _checkoutController
                                                        .orderData[
                                                    'customer_phone'],
                                                email: _checkoutController
                                                        .orderData[
                                                    'customer_email']),
                                            txRef:
                                                'AMZ_${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}',
                                            isTestMode: false,
                                          );

                                          final ChargeResponse response =
                                              await flutterwave.charge();
                                          print(response.txRef);

                                          if (response.txRef != null) {
                                            Map payment = {
                                              'amount': _checkoutController
                                                  .orderData['grand_total'],
                                              'payment_method':
                                                  _paymentController
                                                      .selectedGateway.value.id,
                                              'transection_id':
                                                  response.txRef,
                                            };
                                            _paymentController.paymentInfoStore(
                                                paymentData: payment,
                                                orderData: _checkoutController
                                                    .orderData,
                                                transactionID:
                                                    response.txRef);
                                          }
                                        } catch (error) {
                                          print(
                                              "ERROR =>  ${error.toString()}");
                                        }
                                      }
                                    },
                                  ),
                                );
                        }
                      }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'AMZ-${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
