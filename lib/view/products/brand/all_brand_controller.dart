import 'package:amazy_app/model/Brand/BrandData.dart';
import 'package:amazy_app/model/Brand/BrandsMain.dart';
import 'package:amazy_app/network/config.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AllBrandController extends GetxController {
  Dio _dio = Dio();

  var allBrands = <BrandData>[].obs;
  var chunkedBrands = [].obs;
  RxBool isBrandsLoading = false.obs;
  Future<void> getAllBrand() async {
    try {
      isBrandsLoading(true);
      await _dio
          .get(
        URLs.ALL_BRAND,
      )
          .then((value) {
        var data = new Map<String, dynamic>.from(value.data);
        return BrandsMain.fromJson(data);
      }).then((value) async {
        allBrands.value = value.data;
        chunkedBrands
            .addAll(allBrands.where((p0) => p0.featured == 1).toList());
      });
    } catch (e) {
      isBrandsLoading(false);
      print(e.toString());
    } finally {
      isBrandsLoading(false);
    }
  }

  @override
  void onInit() {
    getAllBrand();
    super.onInit();
  }
}
