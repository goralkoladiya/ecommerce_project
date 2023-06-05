import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/model/Brand/BrandData.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/brand/ProductsByBrands.dart';
import 'package:amazy_app/view/products/brand/all_brand_controller.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/custom_grid_delegate.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBrandsPage extends StatefulWidget {
  @override
  _AllBrandsPageState createState() => _AllBrandsPageState();
}

class _AllBrandsPageState extends State<AllBrandsPage> {
  final AllBrandController _brandController = Get.put(AllBrandController());
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
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
                      "Brands".tr,
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
          SliverFillRemaining(
            child: Obx(() {
              if (_brandController.isBrandsLoading.value) {
                return Center(child: CustomLoadingWidget());
              } else {
                return GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    physics: BouncingScrollPhysics(),
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 6,
                      height: 130,
                    ),
                    itemCount: _brandController.allBrands.length,
                    itemBuilder: (context, index) {
                      BrandData brand = _brandController.allBrands[index];
                      return GestureDetector(
                        onTap: () async {
                          Get.to(() => ProductsByBrands(
                                brandId: brand.id,
                              ));
                        },
                        child: Container(
                          width: Get.width * 0.5,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x1a000000),
                                    offset: Offset(0, 3),
                                    blurRadius: 6,
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: brand.logo != null
                                            ? Container(
                                                child: FancyShimmerImage(
                                                  imageUrl:
                                                      AppConfig.assetPath +
                                                              '/' +
                                                              brand.logo ??
                                                          '',
                                                  boxFit: BoxFit.contain,
                                                  errorWidget:
                                                      FancyShimmerImage(
                                                    imageUrl:
                                                        "${AppConfig.assetPath}/backend/img/default.png",
                                                    boxFit: BoxFit.contain,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                child: Icon(
                                                  Icons.list_alt,
                                                  size: 50,
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      brand.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFontMedium.copyWith(
                                        color: AppStyles.blackColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              }
            }),
          ),
        ],
      ),
    );
  }
}
