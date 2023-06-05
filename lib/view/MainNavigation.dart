import 'dart:ui';
import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/controller/home_controller.dart';
import 'package:amazy_app/controller/login_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/SplashScreen.dart';
import 'package:amazy_app/view/account/AccountPage.dart';
import 'package:amazy_app/view/cart/CartMain.dart';
import 'package:amazy_app/view/notifications/MessageNotifications.dart';
import 'package:amazy_app/view/settings/SettingsPage.dart';
import 'package:amazy_app/widgets/animate_widget/elasticIn.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:amazy_app/widgets/persistent_nav_bar/persistent-tab-view.dart';

import 'Home.dart';
import 'authentication/LoginPage.dart';
import 'products/category/browse_category_screen.dart';

class MainNavigation extends StatefulWidget {
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  PersistentTabController _controller;
  final GeneralSettingsController _settingsController = Get.find<GeneralSettingsController>();

  final LoginController loginController = Get.find<LoginController>();
  final CartController _cartController = Get.find<CartController>();
  final HomeController _homeController = Get.put(HomeController());
  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() {
        if (_settingsController.isLoading.value) {
          return SplashScreen();
        } else {
          if (_settingsController.connected.value) {
            return Scaffold(
              key: _homeController.scaffoldkey.value,
              endDrawer: SettingsPage(),
              body: PersistentTabView(
                context,
                controller: _controller,
                screens: [
                  Home(),
                  BrowseCategoryScreen(),
                  !loginController.loggedIn.value
                      ? LoginPage()
                      : CartMain(true, false),
                  !loginController.loggedIn.value
                      ? LoginPage()
                      : MessageNotifications(),
                  AccountPage(),
                ],
                confineInSafeArea: true,
                resizeToAvoidBottomInset: true,
                navBarStyle: NavBarStyle.style15,
                navBarHeight: 70,
                bottomScreenMargin: 0,
                handleAndroidBackButtonPress: true,
                stateManagement: true,
                margin: EdgeInsets.zero,
                screenTransitionAnimation: ScreenTransitionAnimation(
                  animateTabTransition: true,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                ),
                onItemSelected: (index) async {
                  if (index == 2) {
                    await Get.find<CartController>().getCartList();
                  }
                },
                decoration:
                    NavBarDecoration(borderRadius: BorderRadius.circular(20)),
                items: [
                  PersistentBottomNavBarItem(
                    icon: CustomGradientOnChild(
                      child: Image.asset(
                        'assets/images/home_icon.png',
                        height: 30,
                      ),
                    ),
                    inactiveIcon: Image.asset(
                      'assets/images/home_icon.png',
                      color: AppStyles.greyColorDark,
                      height: 30,
                    ),
                    title: "Home".tr,
                    textStyle: AppStyles.appFontBook.copyWith(
                      fontSize: 12,
                    ),
                    activeColorPrimary: AppStyles.pinkColor,
                    inactiveColorPrimary: AppStyles.greyColorLight,
                  ),
                  PersistentBottomNavBarItem(
                    icon: CustomGradientOnChild(
                      child: CustomGradientOnChild(
                        child: Icon(
                          FontAwesomeIcons.bars,
                          size: 24,
                        ),
                      ),
                    ),
                    inactiveIcon: Icon(
                      FontAwesomeIcons.bars,
                      color: AppStyles.greyColorDark,
                      size: 24,
                    ),
                    title: ("Category".tr),
                    textStyle: AppStyles.appFontBook.copyWith(
                      fontSize: 12,
                    ),
                    activeColorPrimary: AppStyles.pinkColor,
                    inactiveColorPrimary: AppStyles.greyColorLight,
                  ),
                  PersistentBottomNavBarItem(
                    icon: Container(
                      height: 46,
                      child: badges.Badge(

                        showBadge: loginController.loggedIn.value,

                        position: badges.BadgePosition.topEnd(end: -10, top: 4),
                        // toAnimate: false,
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: Colors.white,
                          padding: EdgeInsets.all(2),
                        ),
                        badgeAnimation: badges.BadgeAnimation.size(toAnimate: false),
                        badgeContent: Text(
                          '${_cartController.cartListSelectedCount.value}',
                          style: AppStyles.appFontBook.copyWith(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/cart_icon.png',
                            color: Colors.white,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                    inactiveIcon: Container(
                      height: 46,
                      child: badges.Badge(
                        // toAnimate: false,
                        showBadge:
                            loginController.loggedIn.value ? true : false,
                        position: badges.BadgePosition.topEnd(end: -10, top: 4),
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: Colors.white,
                          padding: EdgeInsets.all(2),
                        ),
                        badgeAnimation: badges.BadgeAnimation.size(toAnimate: false),
                        badgeContent: Text(
                          '${_cartController.cartListSelectedCount.value.toString()}',
                          style: AppStyles.appFontBook.copyWith(
                            color: AppStyles.pinkColor,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/cart_icon.png',
                            color: Colors.white,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                    iconSize: 5,
                    title: ("Cart".tr),
                    textStyle: AppStyles.appFontBook.copyWith(
                      fontSize: 12,
                    ),
                    inactiveColorPrimary: AppStyles.greyColorLight,
                    activeColorPrimary: AppStyles.pinkColor,
                  ),
                  PersistentBottomNavBarItem(
                    icon: CustomGradientOnChild(
                      child: Image.asset(
                        'assets/images/notification_icon.png',
                        color: AppStyles.pinkColor,
                      ),
                    ),
                    inactiveIcon: Image.asset(
                      'assets/images/notification_icon.png',
                      color: AppStyles.greyColorLight,
                    ),
                    title: ("Notification".tr),
                    textStyle: AppStyles.appFontBook.copyWith(
                      fontSize: 12,
                    ),
                    activeColorPrimary: AppStyles.pinkColor,
                    inactiveColorPrimary: AppStyles.greyColorLight,
                  ),
                  PersistentBottomNavBarItem(
                    icon: CustomGradientOnChild(
                      child: Image.asset(
                        'assets/images/user_icon.png',
                        color: AppStyles.pinkColor,
                      ),
                    ),
                    inactiveIcon: Image.asset(
                      'assets/images/user_icon.png',
                      color: AppStyles.greyColorLight,
                    ),
                    title: ("Profile".tr),
                    textStyle: AppStyles.appFontBook.copyWith(
                      fontSize: 12,
                    ),
                    activeColorPrimary: AppStyles.pinkColor,
                    inactiveColorPrimary: AppStyles.greyColorLight,
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('${AppConfig.loginBackgroundImage}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElasticIn(
                            manualTrigger: false,
                            animate: true,
                            infinite: true,
                            child: Image.asset(
                              "${AppConfig.appLogo}",
                              height: 60,
                              width: 60,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${AppConfig.appName}",
                            style: AppStyles.appFontBold.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      bottom: 50,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "${_settingsController.errorMsg.value}",
                          style: AppStyles.appFontBook.copyWith(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      }),
    );
  }
}

class CustomNavigationWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  final NavBarDecoration navBarDecoration;
  final NavBarEssentials navBarEssentials;

  CustomNavigationWidget({
    this.navBarEssentials,
    this.navBarDecoration = const NavBarDecoration(),
    this.selectedIndex,
    this.onItemSelected,
  });

  Widget _buildItem(BuildContext context, PersistentBottomNavBarItem item,
      bool isSelected, double height) {
    return Container(
      width: 150.0,
      height: height,
      color: Colors.transparent,
      padding: EdgeInsets.only(top: 1, bottom: 1),
      child: Container(
        alignment: Alignment.center,
        height: height,
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: IconTheme(
                    data: IconThemeData(
                        size: item.iconSize,
                        color: isSelected
                            ? (item.activeColorSecondary == null
                                ? item.activeColorPrimary
                                : item.activeColorSecondary)
                            : item.inactiveColorPrimary == null
                                ? item.activeColorPrimary
                                : item.inactiveColorPrimary),
                    child:
                        isSelected ? item.icon : item.inactiveIcon ?? item.icon,
                  ),
                ),
                item.title == null
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Material(
                          type: MaterialType.transparency,
                          child: FittedBox(
                              child: Text(
                            item.title,
                            style: item.textStyle != null
                                ? (item.textStyle.apply(
                                    color: isSelected
                                        ? (item.activeColorSecondary == null
                                            ? item.activeColorPrimary
                                            : item.activeColorSecondary)
                                        : item.inactiveColorPrimary))
                                : TextStyle(
                                    color: isSelected
                                        ? (item.activeColorSecondary == null
                                            ? item.activeColorPrimary
                                            : item.activeColorSecondary)
                                        : item.inactiveColorPrimary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0),
                          )),
                        ),
                      )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMiddleItem(
      PersistentBottomNavBarItem item, bool isSelected, double height) {
    return Padding(
      padding: EdgeInsets.only(
          top: kTabLabelPadding?.top ?? 0.0,
          bottom: kTabLabelPadding?.bottom ?? 0.0),
      child: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(0, -23),
            child: Center(
              child: Container(
                width: 150.0,
                height: height,
                margin: EdgeInsets.only(top: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.activeColorPrimary,
                  border: Border.all(color: Colors.transparent, width: 5.0),
                  boxShadow: this.navBarDecoration.boxShadow,
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: height,
                  child: IconTheme(
                    data: IconThemeData(
                        size: item.iconSize,
                        color: item.activeColorSecondary == null
                            ? item.activeColorPrimary
                            : item.activeColorSecondary),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: item.inactiveIcon,
                    ),
                  ),
                ),
              ),
            ),
          ),
          item.title == null
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      type: MaterialType.transparency,
                      child: FittedBox(
                          child: Text(
                        item.title,
                        style: item.textStyle != null
                            ? (item.textStyle.apply(
                                color: isSelected
                                    ? (item.activeColorSecondary == null
                                        ? item.activeColorPrimary
                                        : item.activeColorSecondary)
                                    : item.inactiveColorPrimary))
                            : TextStyle(
                                color: isSelected
                                    ? (item.activeColorPrimary)
                                    : item.inactiveColorPrimary,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0),
                      )),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final midIndex = (this.navBarEssentials.items.length / 2).floor();
    return Container(
      color: Colors.yellow,
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ClipRRect(
            borderRadius:
                this.navBarDecoration.borderRadius ?? BorderRadius.zero,
            child: BackdropFilter(
              filter: this.navBarEssentials.items[selectedIndex].filter ??
                  ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: this.navBarEssentials.items.map((item) {
                  int index = this.navBarEssentials.items.indexOf(item);
                  return Flexible(
                    child: GestureDetector(
                      onTap: () {
                        onItemSelected(index);
                      },
                      child: index == midIndex
                          ? Container(width: 150, color: Colors.transparent)
                          : _buildItem(
                              context, item, selectedIndex == index, 100),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Center(
            child: GestureDetector(
                onTap: () {
                  onItemSelected(midIndex);
                },
                child: _buildMiddleItem(this.navBarEssentials.items[midIndex],
                    selectedIndex == midIndex, kBottomNavigationBarHeight)),
          )
        ],
      ),
    );
  }
}
