import 'dart:developer';

import 'package:amazy_app/model/HomePage/HomePageModel.dart';
import 'package:amazy_app/network/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Dio _dio = Dio();
  RxBool isHomePageLoading = false.obs;
  var dealDuration = Duration().obs;
  var hasDeal = false.obs;
  var dealsText = ''.obs;
  var chunkedBrands = [].obs;
  RxInt endTime = 0.obs;

  RxBool isScrolling = false.obs;

  final Rx<GlobalKey<ScaffoldState>> scaffoldkey =
      GlobalKey<ScaffoldState>().obs;

  Rx<HomePageModel> homePageModel = HomePageModel().obs;

  Future getHomePage() async {
    try {
      isHomePageLoading(true);
      print(URLs.HOME_PAGE);
      await _dio.get(URLs.HOME_PAGE,).then((value) {
        try {
          final data = new Map<String, dynamic>.from(value.data);
          // log("data::: ${value.data['sliders']}");
          homePageModel.value = HomePageModel.fromJson(data);
          homePageModel.value.newUserZone.allProducts.removeWhere((element) => element == null);
          print('home top ticked: ${homePageModel.value.topPicks.length}');
          print(
              'home top ticked: ${homePageModel.value.flashDeal.allProducts.length}');
        } catch (e, t) {
          print('home_page_data error ---<>');
          print(e.toString());
          print(t.toString());
        }

        if (homePageModel.value.flashDeal != null) {
          int now = DateTime.now().millisecondsSinceEpoch;
          if (homePageModel.value.flashDeal.startDate.isAfter(DateTime.now())) {
            hasDeal.value = true;
            dealDuration.value = Duration(
                milliseconds: homePageModel
                        .value.flashDeal.startDate.millisecondsSinceEpoch -
                    now);

            endTime.value =
                homePageModel.value.flashDeal.endDate.millisecondsSinceEpoch +
                    1000 * 30;
            dealsText.value = 'Deal Starts in';
          } else if (homePageModel.value.flashDeal.endDate
              .isBefore(DateTime.now())) {
            dealDuration.value = Duration(milliseconds: 0);
            dealsText.value = 'Deal Ended';
          } else {
            hasDeal.value = true;
            dealDuration.value = Duration(
                milliseconds: homePageModel
                        .value.flashDeal.endDate.millisecondsSinceEpoch -
                    now);
            endTime.value =
                homePageModel.value.flashDeal.endDate.millisecondsSinceEpoch +
                    1000 * 30;
            dealsText.value = 'Deal Ends in';
          }
        }

        chunkedBrands.addAll(homePageModel.value.featuredBrands.toList());
      });
    } catch (e) {
      isHomePageLoading(false);
    } finally {
      isHomePageLoading(false);
    }
  }

  @override
  void onInit() {
    getHomePage();
    super.onInit();
  }
}
