import 'dart:convert';

import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/model/MyPurchasedGiftCards.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/widgets/BuildIndicatorBuilder.dart';
import 'package:amazy_app/widgets/CustomDate.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'package:scratcher/widgets.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class MyGiftCardsPage extends StatefulWidget {
  @override
  _MyGiftCardsPageState createState() => _MyGiftCardsPageState();
}

class _MyGiftCardsPageState extends State<MyGiftCardsPage> {
  final CartController cartController = Get.put(CartController());

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  bool freeSelected = false;

  MyGiftCardsLoadMore source;

  @override
  void initState() {
    source = MyGiftCardsLoadMore();

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
        slivers: [
          CustomSliverAppBarWidget(true, true),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "My Gift Cards".tr,
                      style: AppStyles.appFontMedium.copyWith(
                        fontSize: 18,
                        color: Color(0xff5C7185),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)),
                ),
              ),
            ),
          ),
          LoadingMoreSliverList<GiftCardDatum>(
            SliverListConfig<GiftCardDatum>(
              padding: const EdgeInsets.all(0.0),
              indicatorBuilder: BuildIndicatorBuilder(
                source: source,
                isSliver: true,
                name: 'Gift Cards',
              ).buildIndicator,
              itemBuilder: (BuildContext c, GiftCardDatum prod, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 130,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned.fill(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/images/voucher_bg.png',
                                  fit: BoxFit.fill,
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: double.infinity,
                                    lineThickness: 4.0,
                                    dashLength: 4.0,
                                    dashColor: Colors.white,
                                    dashGapLength: 4.0,
                                    dashGapColor: Colors.transparent,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: double.infinity,
                                    lineThickness: 4.0,
                                    dashLength: 4.0,
                                    dashColor: Colors.white,
                                    dashGapLength: 4.0,
                                    dashGapColor: Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ListTile(
                              title: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        prod.giftCard.name,
                                        style: AppStyles.kFontBlack17w5,
                                      ),
                                      Text(
                                        'Validity'.tr +
                                            ': ${CustomDate().formattedDate(prod.giftCard.startDate)} - ${CustomDate().formattedDate(prod.giftCard.endDate)}',
                                        style: AppStyles.appFontBook.copyWith(
                                          color: AppStyles.blackColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            double.parse((prod.giftCard
                                                            .sellingPrice *
                                                        currencyController
                                                            .conversionRate
                                                            .value)
                                                    .toString())
                                                .toPrecision(2)
                                                .toString(),
                                            style:
                                                AppStyles.appFontBook.copyWith(
                                              color: AppStyles.pinkColor,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${currencyController.appCurrency}',
                                            style:
                                                AppStyles.appFontBook.copyWith(
                                              color: AppStyles.pinkColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Scratch to reveal'.tr,
                                        style: AppStyles.appFontBook.copyWith(
                                          color: AppStyles.blackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Scratcher(
                                        brushSize: 30,
                                        threshold: 100,
                                        color: AppStyles.pinkColor,
                                        onScratchEnd: () {
                                          FlutterClipboard.copy(
                                                  '${prod.secretCode}')
                                              .then((value) {
                                            SnackBars().snackBarSuccess(
                                                'Secret Code copied to Clipboard'
                                                    .tr);
                                          });
                                        },
                                        onChange: (value) =>
                                            print("Scratch progress: $value%"),
                                        onThreshold: () {
                                          FlutterClipboard.copy(
                                                  '${prod.secretCode}')
                                              .then((value) {
                                            print('copied: ${prod.secretCode}');
                                            SnackBars().snackBarSuccess(
                                                'Secret Code copied to Clipboard'
                                                    .tr);
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Text(
                                            prod.secretCode,
                                            style:
                                                AppStyles.appFontBook.copyWith(
                                              color: AppStyles.blackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  // PinkButtonWidget(
                                  //   height: 32.h,
                                  //   width: 100.w,
                                  //   btnOnTap: () {},
                                  //   btnText: 'Redeem'.tr,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
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

class MyGiftCardsLoadMore extends LoadingMoreBase<GiftCardDatum> {
  bool isSorted = false;
  String sortKey = 'new';

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
    GetStorage userToken = GetStorage();
    var tokenKey = 'token';

    String token = await userToken.read(tokenKey);

    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      // await Future.delayed(Duration(milliseconds: 500));
      http.Response result;
      MyPurchasedGiftCards source;

      if (!isSorted) {
        if (this.length == 0) {
          result = await http.get(
            Uri.parse(URLs.MY_PURCHASED_GIFT_CARDS),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
        } else {
          result = await http.get(
            Uri.parse(URLs.MY_PURCHASED_GIFT_CARDS + '?page=$pageIndex'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
        }
        if (result.statusCode != 404) {
          final data = jsonDecode(result.body);
          source = MyPurchasedGiftCards.fromJson(data);
          productsLength = source.giftcards.total;
        } else {
          isSuccess = false;
        }
      } else {
        if (this.length == 0) {
          result = await http.get(
            Uri.parse(URLs.MY_PURCHASED_GIFT_CARDS + '?sort_by=$sortKey'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
        } else {
          result = await http.get(
            Uri.parse(URLs.MY_PURCHASED_GIFT_CARDS +
                '?sort_by=$sortKey&page=$pageIndex'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
        }
        if (result.statusCode != 404) {
          final data = jsonDecode(result.body);
          source = MyPurchasedGiftCards.fromJson(data);
          productsLength = source.giftcards.total;
        } else {
          isSuccess = false;
        }
      }

      if (pageIndex == 1) {
        this.clear();
      }
      if (result.statusCode != 404) {
        for (var item in source.giftcards.data) {
          this.add(item);
        }

        _hasMore = source.giftcards.data?.length != 0;
        pageIndex++;
        isSuccess = true;
      } else {}
    } catch (exception, stack) {
      isSuccess = false;
      print("exc $exception");
      print("stk $stack");
    }
    return isSuccess;
  }
}
