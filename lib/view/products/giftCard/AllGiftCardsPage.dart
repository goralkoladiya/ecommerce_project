import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/controller/gift_card_controller.dart';
import 'package:amazy_app/model/AllGiftCardsModel.dart';
import 'package:amazy_app/model/Product/ProductModel.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/widgets/BuildIndicatorBuilder.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/single_product_widgets/GridViewProductWidget.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

// ignore: must_be_immutable
class AllGiftCardPage extends StatefulWidget {
  @override
  _AllGiftCardPageState createState() => _AllGiftCardPageState();
}

class _AllGiftCardPageState extends State<AllGiftCardPage> {
  final CartController cartController = Get.put(CartController());

  final GiftCardController giftCardController = Get.put(GiftCardController());

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  // Sorting _selectedSort;

  bool freeSelected = false;

  Future<void> onRefresh() async {
    print('onref');
  }

  AllGiftCardsLoadMore source;

  int productsLeng = 0;

  @override
  void initState() {
    source = AllGiftCardsLoadMore();

    productsLeng = source.productsLength;
    super.initState();
  }

  @override
  void dispose() {
    source.dispose();

    super.dispose();
  }

  String calculatePrice(ProductModel prod) {
    String priceText;
    if (prod.giftCardEndDate.millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch) {
      priceText =
          (prod.giftCardSellingPrice * currencyController.conversionRate.value)
              .toString();
    } else {
      if (prod.discountType == 0) {
        priceText = ((prod.giftCardSellingPrice -
                    ((double.parse(prod.discount) / 100) * prod.giftCardSellingPrice)) *
                currencyController.conversionRate.value)
            .toString();
      } else {
        priceText = ((prod.giftCardSellingPrice - prod.discount) *
                currencyController.conversionRate.value)
            .toString();
      }
    }
    return priceText;
  }

  String calculateMainPrice(ProductModel productModel) {
    String amountText;

    if (double.parse(productModel.discount) > 0) {
      amountText = (productModel.giftCardSellingPrice *
              currencyController.conversionRate.value)
          .toString();
    } else {
      amountText = '';
    }

    return amountText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyles.appBackgroundColor,
        body: CustomScrollView(
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
                        "Gift Cards".tr,
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
            LoadingMoreSliverList<ProductModel>(
              SliverListConfig<ProductModel>(
                indicatorBuilder: BuildIndicatorBuilder(
                  source: source,
                  isSliver: true,
                  name: 'Gift Card'.tr,
                ).buildIndicator,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                extendedListDelegate:
                    SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (BuildContext c, ProductModel prod, int index) {
                  return GridViewProductWidget(
                    productModel: prod,
                  );
                },
                sourceList: source,
              ),
            ),
          ],
        ));
  }
}

class AllGiftCardsLoadMore extends LoadingMoreBase<ProductModel> {
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
    DIO.Dio _dio = DIO.Dio();

    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      // await Future.delayed(Duration(milliseconds: 500));
      DIO.Response result;
      AllGiftCardsModel source;

      if (!isSorted) {
        if (this.length == 0) {
          result = await _dio
              .get(
            URLs.ALL_GIFT_CARDS,
          )
              .catchError((onError) {
            print('ERRORRRRR');
            this.length = 0;
          });
        } else {
          result = await _dio.get(URLs.ALL_GIFT_CARDS, queryParameters: {
            'page': pageIndex,
          }).catchError((onError) {
            print('ERRORRRRR');
          });
        }
        if (result != null) {
          print(result.statusCode);
          final data = new Map<String, dynamic>.from(result.data);
          source = AllGiftCardsModel.fromJson(data);
          productsLength = source.giftcards.total;
        }
      } else {
        if (this.length == 0) {
          result = await _dio.get(URLs.ALL_GIFT_CARDS, queryParameters: {
            'sort_by': sortKey,
          });
        } else {
          result = await _dio.get(URLs.ALL_GIFT_CARDS, queryParameters: {
            'sort_by': sortKey,
            'page': pageIndex,
          });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllGiftCardsModel.fromJson(data);
        productsLength = source.giftcards.total;
      }

      if (source != null) {
        if (pageIndex == 1) {
          this.clear();
        }
        for (var item in source.giftcards.data) {
          this.add(item);
        }

        _hasMore = source.giftcards.data.length != 0;
        pageIndex++;
        isSuccess = true;
      }
    } catch (exception, stack) {
      isSuccess = false;
      print('Exception => $exception');
      print('Stack => $stack');
    }
    return isSuccess;
  }
}
