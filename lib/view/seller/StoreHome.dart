import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/seller_profile_controller.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/seller/SellerProductsLoadMore.dart';
import 'package:amazy_app/view/seller/StoreAllProductsPage.dart';
import 'package:amazy_app/view/seller/SellerProfileFilterDrawer.dart';
import 'package:amazy_app/view/seller/StoreHomePage.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class StoreHome extends StatefulWidget {
  final int sellerId;

  StoreHome({this.sellerId});

  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  SellerProfileController controller;

  String popUpItem1 = "Home";
  String popUpItem2 = "Share";
  String popUpItem3 = "Search";

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  SellerProductsLoadMore source;

  bool filterSelected = false;

  @override
  void initState() {
    controller = Get.put(SellerProfileController(widget.sellerId));
    source = SellerProductsLoadMore(widget.sellerId);
    source.isSorted = false;
    source.isFilter = false;
    super.initState();
  }

  // getSellerDetails() async {
  //   await controller.getSellerProfile(widget.sellerId).then((value) {
  //     controller.sellerId.value = widget.sellerId;
  //   });
  // }

  @override
  void dispose() {
    source.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final double statusBarHeight = MediaQuery.of(context).padding.top;
    // var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: SellerProfileFilterDrawer(
          sellerId: widget.sellerId,
          scaffoldKey: _scaffoldKey,
          source: source,
        ),
        backgroundColor: AppStyles.appBackgroundColor,
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CustomLoadingWidget());
          } else {
            return Scaffold(
              backgroundColor: AppStyles.appBackgroundColor,
              body: NestedScrollView(
                physics: NeverScrollableScrollPhysics(),
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    CustomSliverAppBarWidget(true, true),
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      expandedHeight: 200,
                      floating: false,
                      pinned: false,
                      automaticallyImplyLeading: false,
                      actions: [Container()],
                      titleSpacing: 0,
                      centerTitle: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              height: 170,
                              alignment: Alignment.topCenter,
                              child: controller
                                          .seller.value.seller.sellerAccount !=
                                      null
                                  ? FancyShimmerImage(
                                      imageUrl:
                                          "${AppConfig.assetPath}/${controller.seller.value.seller.sellerAccount.banner}",
                                      boxFit: BoxFit.cover,
                                      errorWidget: FancyShimmerImage(
                                        imageUrl:
                                            "${AppConfig.assetPath}/backend/img/default.png",
                                        boxFit: BoxFit.cover,
                                        width: Get.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/images/account_graphics.png',
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                    ),
                            ),
                            Positioned(
                              bottom: 15,
                              left: 20,
                              right: 0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Color(0xffF1F1F1),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.asset(
                                      'assets/images/person.png',
                                      color: Colors.white,
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.seller.value.seller
                                                          .sellerAccount !=
                                                      null
                                                  ? controller
                                                          .seller
                                                          .value
                                                          .seller
                                                          .sellerAccount
                                                          .sellerShopDisplayName ??
                                                      "${controller.seller.value.seller.firstName ?? ""} ${controller.seller.value.seller.lastName ?? ""}"
                                                  : "${controller.seller.value.seller.firstName ?? ""} ${controller.seller.value.seller.lastName ?? ""}",
                                              style: AppStyles.appFontBold
                                                  .copyWith(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Expanded(child: Container()),
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            width: 50,
                                            height: 46,
                                            margin: EdgeInsets.only(right: 15),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Color(0xff5c7185),
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Image.asset(
                                              'assets/images/store.png',
                                              width: 5,
                                              height: 5,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            width: 50,
                                            height: 46,
                                            margin: EdgeInsets.only(right: 15),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              gradient: AppStyles.gradient,
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Image.asset(
                                              'assets/images/email.png',
                                              width: 5,
                                              height: 5,
                                              color: Colors.white,
                                            ),
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppStyles.appBackgroundColor,
                          width: 0.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: TabBar(
                        controller: controller.tabController,
                        indicatorColor: AppStyles.pinkColor,
                        isScrollable: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: AppStyles.appFontBook,
                        unselectedLabelStyle: AppStyles.appFontBook,
                        tabs: controller.myTabs,
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: controller.tabController,
                        children: <Widget>[
                          StoreHomePage(widget.sellerId),
                          StoreAllProductsPage(
                            scaffoldKey: _scaffoldKey,
                            sellerId: widget.sellerId,
                            source: source,
                          ),
                          Container(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        }));
  }
}

class SkewBgWhite extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    // paint.color = Color(0xffffffff);
    paint.color = AppStyles.pinkColor;
    path = Path();
    path.lineTo(size.width * 0.06, size.height * 0.06);
    path.cubicTo(size.width * 0.06, size.height * 0.06, size.width,
        size.height * 0.06, size.width, size.height * 0.06);
    path.cubicTo(size.width, size.height * 0.06, size.width * 0.96,
        size.height * 1.06, size.width * 0.96, size.height * 1.06);
    path.cubicTo(size.width * 0.96, size.height * 1.06, size.width * 0.01,
        size.height * 1.06, size.width * 0.01, size.height * 1.06);
    path.cubicTo(size.width * 0.01, size.height * 1.06, size.width * 0.06,
        size.height * 0.06, size.width * 0.06, size.height * 0.06);
    path.cubicTo(size.width * 0.06, size.height * 0.06, size.width * 0.06,
        size.height * 0.06, size.width * 0.06, size.height * 0.06);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


