import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/AppConfig/language/language_selection.dart';
import 'package:amazy_app/AppConfig/language/translation.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/controller/login_controller.dart';
import 'package:amazy_app/model/Currency.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/settings/ChangePassword.dart';
import 'package:amazy_app/view/settings/MessagesSettings.dart';
import 'package:amazy_app/view/settings/widget/account_delete_dialogue.dart';
import 'package:amazy_app/widgets/AppBarWidget.dart';
import 'package:amazy_app/widgets/BlueButtonWidget.dart';
import 'package:amazy_app/widgets/PinkButtonWidget.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // bool _isRadioSelected = false;
  final LoginController loginController = Get.put(LoginController());

  final LanguageController languageController = Get.put(LanguageController());

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  bool active = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyles.appBackgroundColor,
        appBar: AppBarWidget(
          title: ''.tr,
          showCart: false,
        ),
        body: Obx(() {
          return Container(
            child: ListView(
              children: [
                SizedBox(
                  height: 5,
                ),
                loginController.loggedIn.value
                    ? ListTile(
                        onTap: () {
                          Get.to(() => NotificationSettings());
                        },
                        tileColor: Colors.white,
                        title: Text(
                          'Messages'.tr,
                          style: AppStyles.appFontMedium.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          'Receive exclusive offers & personal updates'.tr,
                          style: AppStyles.appFontBook.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Container(),
                loginController.loggedIn.value
                    ? Divider(
                        color: AppStyles.appBackgroundColor,
                        height: 1,
                      )
                    : Container(),
                loginController.loggedIn.value
                    ? ListTile(
                        onTap: () {
                          Get.to(() => ChangePassword());
                        },
                        tileColor: Colors.white,
                        title: Text(
                          'Change Password'.tr,
                          style: AppStyles.appFontMedium.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      )
                    : Container(),
                loginController.loggedIn.value
                    ? Divider(
                        color: AppStyles.appBackgroundColor,
                        height: 1,
                      )
                    : Container(),
                ListTile(
                  onTap: () {
                    Get.bottomSheet(
                      GetBuilder<LanguageController>(
                          init: LanguageController(),
                          builder: (controller) {
                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 40,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Color(0xffDADADA),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Change Language'.tr,
                                    style: AppStyles.appFontMedium.copyWith(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    title: DropdownButton(
                                      isExpanded: true,
                                      items: List.generate(
                                        languages.length,
                                        (index) => DropdownMenuItem(
                                          child: Text(
                                            languages[index].languageText,
                                            style: AppStyles.kFontBlack14w5,
                                          ),
                                          value: languages[index].languageValue,
                                        ),
                                      ),
                                      onChanged: (value) async {
                                        print(value);
                                        LanguageSelection.instance.drop = value;
                                        final sharedPref =
                                            await SharedPreferences
                                                .getInstance();
                                        sharedPref.setString('language', value);
                                        controller.appLocale = value;
                                        Get.updateLocale(Locale(
                                            controller.appLocale.toString()));
                                        setState(() {
                                          LanguageSelection.instance.drop =
                                              value;
                                          languages.forEach((element) {
                                            if (element.languageValue ==
                                                value) {
                                              LanguageSelection
                                                      .instance.langName =
                                                  element.languageText;
                                            }
                                          });
                                          languageController.langName.value =
                                              LanguageSelection
                                                  .instance.langName;
                                        });
                                      },
                                      value: LanguageSelection.instance.drop,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.2,
                                  ),
                                ],
                              ),
                            );
                          }),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    );
                  },
                  tileColor: Colors.white,
                  title: Text(
                    'Language'.tr,
                    style: AppStyles.appFontMedium.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Obx(() {
                    return Text(
                      languageController.langName.value,
                      style: AppStyles.appFontBook.copyWith(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    );
                  }),
                ),
                Divider(
                  color: AppStyles.appBackgroundColor,
                  height: 1,
                ),
                ListTile(
                  onTap: () {
                    Get.bottomSheet(
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          child: Container(
                            color: Color.fromRGBO(0, 0, 0, 0.001),
                            child: DraggableScrollableSheet(
                              initialChildSize: 0.4,
                              minChildSize: 0.3,
                              maxChildSize: 1,
                              builder: (_, scrollController2) {
                                return Obx(() {
                                  if (currencyController.isLoading.value) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(25.0),
                                            topRight:
                                                const Radius.circular(25.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: CustomLoadingWidget(),
                                        ),
                                      ),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(25.0),
                                          topRight: const Radius.circular(25.0),
                                        ),
                                      ),
                                      child: Scaffold(
                                        backgroundColor: Colors.white,
                                        body: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Container(
                                                  width: 40,
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffDADADA),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(30),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: Text(
                                                'Change Currency'.tr,
                                                style: AppStyles.kFontBlack15w4
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              'Select Currency'.tr + ' :',
                                              textAlign: TextAlign.left,
                                              style: AppStyles.kFontBlack15w4,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Obx(() {
                                              return DropdownButton<Currency>(
                                                elevation: 1,
                                                isExpanded: true,
                                                underline: Container(),
                                                value: currencyController
                                                    .currency.value,
                                                items: currencyController
                                                    .currenciesList
                                                    .map((e) {
                                                  return DropdownMenuItem<
                                                      Currency>(
                                                    child: Text(
                                                        '${e.name} (${e.symbol.toString()})'),
                                                    value: e,
                                                  );
                                                }).toList(),
                                                onChanged: (Currency value) {
                                                  setState(() {
                                                    currencyController
                                                        .currency.value = value;
                                                  });
                                                },
                                              );
                                            }),
                                            Divider(),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                BlueButtonWidget(
                                                  height: 40,
                                                  width: 130,
                                                  btnText: 'Back'.tr,
                                                  btnOnTap: () {
                                                    Get.back();
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                PinkButtonWidget(
                                                  height: 40,
                                                  width: 130,
                                                  btnOnTap: () async {
                                                    currencyController
                                                            .appCurrency.value =
                                                        currencyController
                                                            .currency
                                                            .value
                                                            .symbol;
                                                    currencyController
                                                            .conversionRate
                                                            .value =
                                                        currencyController
                                                            .currency
                                                            .value
                                                            .convertRate;
                                                    currencyController
                                                            .currencyName
                                                            .value =
                                                        currencyController
                                                            .currency
                                                            .value
                                                            .name;
                                                    SnackBars().snackBarSuccess(
                                                        "Currency changed to"
                                                                .tr +
                                                            ' ${currencyController.currency.value.name.capitalizeFirst}');
                                                    Future.delayed(
                                                        Duration(seconds: 3),
                                                        () {
                                                      Get.back();
                                                    });
                                                  },
                                                  btnText: 'Confirm'.tr,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      persistent: true,
                    );
                  },
                  tileColor: Colors.white,
                  title: Text(
                    'Currency'.tr,
                    style: AppStyles.appFontMedium.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    '${currencyController.currencyName.value} (${currencyController.appCurrency.value})',
                    style: AppStyles.appFontBook.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ),
                Divider(
                  color: AppStyles.appBackgroundColor,
                  height: 1,
                ),

                ListTile(
                  onTap: () async {
                    // ignore: deprecated_member_use
                    if (!await launch(AppConfig.privacyPolicyUrl))
                      throw 'Could not launch ${AppConfig.privacyPolicyUrl}';
                  },
                  tileColor: Colors.white,
                  title: Text(
                    'Policies'.tr,
                    style: AppStyles.appFontMedium.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                Divider(
                  color: AppStyles.appBackgroundColor,
                  height: 1,
                ),
                /// Account Delete
                loginController.loggedIn.value ? ListTile(
                  onTap: () {

                    Get.dialog(
                      AccountDeleteDialogue(
                        onYesTap: () {
                          currencyController.deleteAccount();
                        },
                      ),
                      // backgroundColor: Colors.white,
                    );
                  },
                  tileColor: Colors.white,
                  trailing: Icon(Icons.warning_amber_rounded),
                  title: Text(
                    'Delete Account'.tr,
                    style: AppStyles.appFont.copyWith(
                      color: AppStyles.pinkColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ) : SizedBox(),
                Divider(
                  color: AppStyles.appBackgroundColor,
                  height: 1,
                ),
              ],
            ),
          );
        }));
  }
}

class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key key,
    @required this.label,
    @required this.padding,
    @required this.groupValue,
    @required this.value,
    @required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final bool groupValue;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(label),
            Radio<bool>(
              groupValue: groupValue,
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
              activeColor: AppStyles.pinkColor,
            ),
          ],
        ),
      ),
    );
  }
}
