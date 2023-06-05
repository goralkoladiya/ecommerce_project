import 'dart:io';

import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/login_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/utils/dio_exception.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/account/orders/MyCancellations.dart';
import 'package:amazy_app/view/account/orders/OrderList/MyOrders.dart';
import 'package:amazy_app/view/account/orders/RefundAndDisputes/MyRefundsAndDisputes.dart';
import 'package:amazy_app/view/account/reviews/MyReviews.dart';
import 'package:amazy_app/view/authentication/LoginPage.dart';
import 'package:amazy_app/view/settings/SettingsPage.dart';
import 'package:amazy_app/view/support/SupportTicketsPage.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class OrdersPageMain extends StatefulWidget {
  @override
  State<OrdersPageMain> createState() => _OrdersPageMainState();
}

class _OrdersPageMainState extends State<OrdersPageMain> {
  final LoginController loginController = Get.put(LoginController());
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  DIO.Response response;
  DIO.Dio dio = new DIO.Dio();
  File _file;

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  final picker = ImagePicker();

  Future<bool> updatePhoto() async {
    String token = await userToken.read(tokenKey);

    final file =
        await DIO.MultipartFile.fromFile(_file.path, filename: '${_file.path}');

    final formData = DIO.FormData.fromMap({
      'avatar': file,
    });

    response = await dio.post(
      URLs.UPDATE_PROFILE_PHOTO,
      data: formData,
      options: DIO.Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      onSendProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError((e) {
      print(e);
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print(errorMessage);
    });

    print(response);
    if (response.statusCode == 202) {
      return true;
    } else {
      if (response.statusCode == 401) {
        SnackBars().snackBarWarning('Invalid Access token. Please re-login.');
        return false;
      } else {
        SnackBars().snackBarError(response.data);
        return false;
      }
    }
  }

  Future<bool> pickDocument() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print(pickedFile);
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
      return true;
    } else {
      SnackBars().snackBarWarning('Cancelled');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBarWidget(true, true),
          SliverToBoxAdapter(
            child: Stack(
              children: [
                ClipPath(
                  clipper: TsClip3(),
                  child: Image.asset(
                    'assets/images/account_graphics.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.22,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30),
                        child: Obx(() {
                          if (!loginController.loggedIn.value) {
                            return Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hello".tr +
                                          ", " +
                                          "Welcome to".tr +
                                          " ${AppConfig.appName}",
                                      style: AppStyles.appFontBold.copyWith(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.dialog(LoginPage(),
                                            useSafeArea: false);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 4),
                                        child: Text(
                                          'Sign in or Register'.tr,
                                          textAlign: TextAlign.center,
                                          style:
                                              AppStyles.appFontMedium.copyWith(
                                            color: AppStyles.pinkColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(child: Container()),
                                IconButton(
                                  onPressed: () {
                                    Get.to(() => SettingsPage());
                                  },
                                  icon: Icon(
                                    Icons.settings_outlined,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                Obx(() {
                                  if (loginController
                                          .profileData.value.avatar ==
                                      null) {
                                    return GestureDetector(
                                      onTap: () async {
                                        if (AppConfig.isDemo) {
                                          SnackBars().snackBarWarning(
                                              "Disabled in demo");
                                        } else {
                                          await pickDocument()
                                              .then((value) async {
                                            if (value) {
                                              await updatePhoto()
                                                  .then((up) async {
                                                if (up) {
                                                  SnackBars().snackBarSuccess(
                                                      'updated successfully');
                                                  await loginController
                                                      .getProfileData();
                                                }
                                              });
                                            }
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: Icon(
                                          Icons.add,
                                          color: AppStyles.pinkColor,
                                          size: 20,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () async {
                                        if (AppConfig.isDemo) {
                                          SnackBars().snackBarWarning(
                                              "Disabled in demo");
                                        } else {
                                          await pickDocument()
                                              .then((value) async {
                                            if (value) {
                                              await updatePhoto()
                                                  .then((up) async {
                                                if (up) {
                                                  SnackBars().snackBarSuccess(
                                                      'updated successfully');
                                                  await loginController
                                                      .getProfileData();
                                                }
                                              });
                                            }
                                          });
                                        }
                                      },
                                      child: _file != null
                                          ? CircleAvatar(
                                              radius: 70,
                                              backgroundImage: FileImage(
                                                _file,
                                              ),
                                            )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  '${AppConfig.assetPath}/${loginController.profileData.value.avatar}',
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    )),
                                                width: 70,
                                                height: 70,
                                                alignment: Alignment.center,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      CachedNetworkImage(
                                                imageUrl:
                                                    '${AppConfig.assetPath}/backend/img/default.png',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                  ),
                                                  width: 70,
                                                  height: 70,
                                                  alignment: Alignment.center,
                                                ),
                                              ),
                                            ),
                                    );
                                  }
                                }),
                                SizedBox(
                                  width: 20,
                                ),
                                Obx(
                                  () => Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${loginController.profileData.value.name ?? ""}',
                                        textAlign: TextAlign.left,
                                        style: AppStyles.appFontMedium.copyWith(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      Text(
                                        '${loginController.profileData.value.email ?? ""}',
                                        textAlign: TextAlign.left,
                                        style: AppStyles.appFontBook.copyWith(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await loginController
                                              .accountController
                                              .getAccountDetails();
                                        },
                                        child: Container(
                                          height: 25,
                                          // color: Colors.blue,
                                          alignment: Alignment.center,
                                          child: loginController
                                                      .accountController
                                                      .customerData
                                                      .value
                                                      .walletRunningBalance !=
                                                  null
                                              ? Text(
                                                  'Wallet'.tr +
                                                      ': ${(loginController.accountController.customerData.value.walletRunningBalance * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                  textAlign: TextAlign.left,
                                                  style: AppStyles.appFontBook
                                                      .copyWith(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(child: Container()),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.settings_outlined,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 20,
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: ListView(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                AccountTiles(
                                  title: "All Order",
                                  image: 'assets/images/all_order.png',
                                  onTap: () {
                                    if (!loginController.loggedIn.value) {
                                      Get.dialog(LoginPage(),
                                          useSafeArea: false);
                                    } else {
                                      Get.to(() => MyOrders(0));
                                    }
                                  },
                                ),
                                AccountTiles(
                                  title: "My Cancellations",
                                  image: 'assets/images/my_cancellations.png',
                                  onTap: () {
                                    if (!loginController.loggedIn.value) {
                                      Get.dialog(LoginPage(),
                                          useSafeArea: false);
                                    } else {
                                      Get.to(() => MyCancellations());
                                    }
                                  },
                                ),
                                AccountTiles(
                                  title: "Refunds and Disputes",
                                  image:
                                      'assets/images/refund_and_disputes.png',
                                  onTap: () {
                                    if (!loginController.loggedIn.value) {
                                      Get.dialog(LoginPage(),
                                          useSafeArea: false);
                                    } else {
                                      Get.to(() => MyRefundsAndDisputes());
                                    }
                                  },
                                ),
                                AccountTiles(
                                  title: "My Review",
                                  image: 'assets/images/my_review.png',
                                  onTap: () {
                                    if (!loginController.loggedIn.value) {
                                      Get.dialog(LoginPage(),
                                          useSafeArea: false);
                                    } else {
                                      Get.to(() => MyReviews(
                                            tabIndex: 0,
                                          ));
                                    }
                                  },
                                ),
                                AccountTiles(
                                  title: "Need Help?",
                                  image: 'assets/images/need_help.png',
                                  onTap: () {
                                    if (!loginController.loggedIn.value) {
                                      Get.dialog(LoginPage(),
                                          useSafeArea: false);
                                    } else {
                                      Get.to(() => SupportTicketsPage());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountTiles extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;

  AccountTiles({this.onTap, this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 215, 215),
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          '$image',
          height: 15,
          width: 15,
        ),
      ),
      onTap: onTap,
      title: Text(
        title,
        style: AppStyles.appFontBold.copyWith(fontSize: 14),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppStyles.pinkColor,
        size: 18,
      ),
    );
  }
}

class TsClip3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width / 2, size.height - 30);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
