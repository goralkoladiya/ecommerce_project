import 'package:amazy_app/model/FlashDeals/FlashDealData.dart';
import 'package:amazy_app/model/FlashDeals/FlashDealDataElement.dart';
import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class FlashDealController extends GetxController {
  Dio _dio = Dio();

  var flashProductData = <FlashDealDataElement>[].obs;

  var isFlashDealProductsLoading = false.obs;
  var lastFlashDealPage = false.obs;
  var flashPageNumber = 1.obs;
  var flashDealTitle = "".obs;
  var flashDealImage = "".obs;
  var bgColor = 0.obs;
  var textColor = 0.obs;
  var dealsText = ''.obs;
  var dealDuration = Duration().obs;
  DateTime flashDealEndDate;

  RxInt endTime = 0.obs;

  Future<List<FlashDealDataElement>> getFlashDealsData() async {
    FlashDealData flashDeals = FlashDealData();
    try {
      isFlashDealProductsLoading(true);
      await _dio.get(URLs.FLASH_DEALS, queryParameters: {
        'page': flashPageNumber,
      }).then((value) async {

        final data = new Map<String, dynamic>.from(value.data);
        flashDeals = FlashDealData.fromJson(data['flash_deal']);
        flashDealTitle.value = flashDeals.title;
        flashDealImage.value = flashDeals.bannerImage;

        int now = DateTime.now().millisecondsSinceEpoch;
        if (flashDeals.startDate.millisecondsSinceEpoch > now) {
          dealDuration.value = Duration(
              milliseconds: flashDeals.startDate.millisecondsSinceEpoch - now);
          dealsText.value = 'Deal Starts in'.tr;
          endTime.value = flashDeals.endDate.millisecondsSinceEpoch;
        } else if (flashDeals.endDate.millisecondsSinceEpoch < now) {
          dealDuration.value = Duration(milliseconds: 0);
          dealsText.value = 'Deal Ended'.tr;
          endTime.value = flashDeals.endDate.millisecondsSinceEpoch;
        } else {
          dealDuration.value = Duration(
              milliseconds: flashDeals.endDate.millisecondsSinceEpoch - now);
              endTime.value = flashDeals.endDate.millisecondsSinceEpoch;
          // if (!dealDuration.value.isNegative) {
          //   dealDuration.value = Duration(
          //       milliseconds: flashDeals.endDate.millisecondsSinceEpoch - now);
          // } else {
          //
          //   dealDuration.value = Duration(milliseconds: 0);
          // }
          dealsText.value = 'Deal Ends in'.tr;
        }

        if (flashDeals.backgroundColor == "white") {
          bgColor.value = 0xffFFFFFF;
        } else if (flashDeals.backgroundColor == "black") {
          bgColor.value = 0xff000000;
        } else {
          bgColor.value = AppStyles.getBGColor(flashDeals.backgroundColor);
        }
        if (flashDeals.textColor == "white") {
          textColor.value = 0xffFFFFFF;
        } else if (flashDeals.textColor == "black") {
          textColor.value = 0xff000000;
        } else {
          textColor.value = AppStyles.getBGColor(flashDeals.textColor);
        }

        if (flashDeals.allProducts.data.length == 0) {
          lastFlashDealPage(true);
        } else {
          flashProductData.addAll(flashDeals.allProducts.data);
        }
      });
    } catch (e) {
      isFlashDealProductsLoading(false);
      print(e.toString());
    } finally {
      isFlashDealProductsLoading(false);
    }
    return flashProductData;
  }

  @override
  void onInit() {
    getFlashDealsData();
    super.onInit();
  }
}
