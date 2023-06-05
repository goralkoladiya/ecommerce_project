import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/home_controller.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/products/SearchPageMain.dart';
import 'package:amazy_app/widgets/cart_icon_widget.dart';
import 'package:amazy_app/widgets/custom_input_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSliverAppBarWidget extends StatelessWidget {
  final bool showBack;
  final bool showCart;
  CustomSliverAppBarWidget(this.showBack, this.showCart);
  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.find<HomeController>();
    return SliverAppBar(
      backgroundColor: Color(0xff6E0200),
      titleSpacing: 0,
      expandedHeight: MediaQuery.of(context).size.height * 0.08,
      automaticallyImplyLeading: false,
      stretch: false,
      pinned: true,
      floating: false,
      forceElevated: false,
      elevation: 0,
      actions: [
        Container(),
      ],
      title: Row(
        children: [
          showBack
              ? Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.asset(
                    "${AppConfig.appBarIcon}",
                  ),
                ),
          SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.to(() => SearchPageMain());
              },
              child: Container(
                height: 40,
                child: TextField(
                  autofocus: true,
                  enabled: false,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.text,
                  expands: false,
                  decoration: CustomInputBorder()
                      .inputDecorationAppBar(
                        '${AppConfig.appName}',
                      )
                      .copyWith(
                        prefixIcon: CustomGradientOnChild(
                          child: Icon(
                            Icons.search,
                            color: AppStyles.pinkColor,
                          ),
                        ),
                      ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          showCart
              ? CartIconWidget()
              : Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        print('open drawer');
                        _homeController.scaffoldkey.value.currentState
                            .openEndDrawer();
                      },
                      child: Icon(
                        Icons.menu_rounded,
                        size: 35,
                      )),
                ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
