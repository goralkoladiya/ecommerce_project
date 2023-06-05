import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/controller/new_user_zone_controller.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/marketing/NewUserZone/NewUserZoneCouponMain.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/PinkButtonWidget.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'NewUserZoneCategoryMain.dart';
import 'NewUserZoneProducts.dart';

class NewUserZonePage extends StatefulWidget {
  @override
  _NewUserZonePageState createState() => _NewUserZonePageState();
}

class _NewUserZonePageState extends State<NewUserZonePage>
    with SingleTickerProviderStateMixin {
  final NewUserZoneController newUserZoneController =
      Get.put(NewUserZoneController());
  final CartController cartController = Get.put(CartController());

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    newUserZoneController.newUserProducts.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final double statusBarHeight = MediaQuery.of(context).padding.top;
    // var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    return Obx(() {
      if (newUserZoneController.isLoading.value) {
        return Scaffold(
          body: Center(
            child: CustomLoadingWidget(),
          ),
        );
      } else {
        if (newUserZoneController.newZone.value.newUserZone == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Image.asset(
                AppConfig.appLogo,
                width: 50,
                height: 50,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '- ' + 'No Products found'.tr + ' - ',
                style: AppStyles.kFontBlack17w5,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: PinkButtonWidget(
                  height: 32,
                  btnOnTap: () {
                    Get.back();
                  },
                  btnText: 'Continue Shopping'.tr,
                ),
              ),
            ],
          );
        }
        return Scaffold(
          backgroundColor: AppStyles.appBackgroundColor,
          body: NestedScrollView(
            physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                CustomSliverAppBarWidget(true, true),
                SliverAppBar(
                  expandedHeight: 80,
                  floating: false,
                  pinned: false,
                  automaticallyImplyLeading: false,
                  actions: [Container()],
                  titleSpacing: 0,
                  centerTitle: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            child: FancyShimmerImage(
                              imageUrl:
                                  '${AppConfig.assetPath}/${newUserZoneController.newZone.value.newUserZone.bannerImage}',
                              boxFit: BoxFit.cover,
                              errorWidget: FancyShimmerImage(
                                imageUrl:
                                    "${AppConfig.assetPath}/backend/img/default.png",
                                boxFit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            // pinnedHeaderSliverHeightBuilder: () {
            //   return pinnedHeaderHeight;
            // },
            floatHeaderSlivers: false,
            body: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppStyles.pinkColor,
                    isScrollable: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    automaticIndicatorColorAdjustment: true,
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(
                        child: Text(
                            newUserZoneController.newZone.value.newUserZone
                                .productNavigationLabel,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: AppStyles.kFontBlack14w5),
                      ),
                      Tab(
                        child: Text(
                            newUserZoneController.newZone.value.newUserZone
                                .categoryNavigationLabel,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: AppStyles.kFontBlack14w5),
                      ),
                      Tab(
                        child: Text(
                          newUserZoneController
                              .newZone.value.newUserZone.couponNavigationLabel,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: AppStyles.kFontBlack14w5,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: <Widget>[
                      NewUserZoneProducts(),
                      NewUserZoneCategoryMain(),
                      NewUserZoneCouponMain(),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    });
  }
}
