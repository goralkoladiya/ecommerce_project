import 'dart:convert';
import 'dart:io';

import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/controller/login_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/utils/dio_exception.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/widgets/CustomInputDecoration.dart';
import 'package:amazy_app/widgets/CustomSliverAppBarWidget.dart';
import 'package:amazy_app/widgets/PinkButtonWidget.dart';
import 'package:amazy_app/widgets/custom_loading_widget.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../model/Customer/CustomerData.dart';
import '../../widgets/SettingsListTileWidget.dart';

class ProfilePage extends StatefulWidget {
  CustomerData user;
  ProfilePage({this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final LoginController loginController = Get.put(LoginController());
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  DIO.Response response;
  DIO.Dio dio = new DIO.Dio();
  File _file;

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  String maxDateTime = '2099-12-31';
  String initDateTime = '1900-01-01';
  String _format = 'yyyy-MMMM-dd';
  DateTime _dateTime;
  String toDate;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  final _formKey = GlobalKey<FormState>();

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


  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController phoneNumberCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();

  @override
  void initState() {
    print("user=${widget.user}");
    firstNameCtrl.text = loginController.profileData.value.firstName ?? "";
    lastNameCtrl.text = loginController.profileData.value.lastName ?? "";
    dobCtrl.text = loginController.profileData.value.dateOfBirth ?? "";
    descriptionCtrl.text = loginController.profileData.value.description ?? "";
    phoneNumberCtrl.text = loginController.profileData.value.phone ?? "";
    emailCtrl.text = loginController.profileData.value.email ?? "";
    super.initState();
    getdata();
  }

  getdata()
  async {
  print("===${await loginController.getProfileData()}");
}
  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  Future updateProfile(Map data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);
    Uri addressUrl = Uri.parse(URLs.UPDATE_USER_PROFILE);
    var body = json.encode(data);
    var response = await http.post(addressUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 202) {
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.dismiss();
      if (response.statusCode == 401) {
        SnackBars().snackBarWarning('Invalid Access token. Please re-login.');
        return false;
      } else {
        SnackBars().snackBarError(jsonString['message']);
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          CustomSliverAppBarWidget(true, false),
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        if (loginController.profileData.value.avatar == null) {
                          return GestureDetector(
                            onTap: () async {
                              if (AppConfig.isDemo) {
                                SnackBars().snackBarWarning("Disabled in demo");
                              } else {
                                await pickDocument().then((value) async {
                                  if (value) {
                                    await updatePhoto().then((up) async {
                                      if (up) {
                                        SnackBars().snackBarSuccess(
                                            'updated successfully');
                                        await loginController.getProfileData();
                                      }
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: AppStyles.pinkColorAlt,
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.add,
                                color: AppStyles.pinkColor,
                                size: 40,
                              ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onTap: () async {
                              if (AppConfig.isDemo) {
                                SnackBars().snackBarWarning("Disabled in demo");
                              } else {
                                await pickDocument().then((value) async {
                                  if (value) {
                                    await updatePhoto().then((up) async {
                                      if (up) {
                                        SnackBars().snackBarSuccess(
                                            'updated successfully');
                                        await loginController.getProfileData();
                                      }
                                    });
                                  }
                                });
                              }
                            },
                            child: _file != null
                                ? CircleAvatar(
                                    radius: 100,
                                    backgroundImage: FileImage(
                                      _file,
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl:
                                        '${AppConfig.assetPath}/${loginController.profileData.value.avatar}',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          )),
                                      width: 100,
                                      height: 100,
                                      alignment: Alignment.center,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        CachedNetworkImage(
                                      imageUrl:
                                          '${AppConfig.assetPath}/backend/img/default.png',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                        width: 100,
                                        height: 100,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                          );
                        }
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [

                              TextFormField(
                                // initialValue:

                                 controller: firstNameCtrl,
                                // onChanged: (value){
                                //   widget.user.firstName = value;
                                // }


                                keyboardType: TextInputType.text,
                                decoration: CustomInputDecoration()
                                    .underlineDecoration(label: "First name"),
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 16,
                                ),
                                validator: (value) {
                                  if (value.length == 0) {
                                    return 'Please Type First Name'.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: lastNameCtrl,
                                keyboardType: TextInputType.text,
                                decoration: CustomInputDecoration()
                                    .underlineDecoration(label: "Last name"),
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 16,
                                ),
                                validator: (value) {
                                  if (value.length == 0) {
                                    return 'Please Type Last Name'.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: phoneNumberCtrl,
                                keyboardType: TextInputType.text,
                                decoration: CustomInputDecoration()
                                    .underlineDecoration(
                                        label: "Mobile Number"),
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 16,
                                ),
                                validator: (value) {
                                  if (value.length == 0) {
                                    return 'Please Type Mobile Number'.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: emailCtrl,
                                keyboardType: TextInputType.text,
                                decoration: CustomInputDecoration()
                                    .underlineDecoration(
                                        label: "Email Address"),
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 16,
                                ),
                                validator: (value) {
                                  if (value.length == 0) {
                                    return 'Please Type Email Address'.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  print(loginController
                                      .profileData.value.dateOfBirth);
                                  var splitted;
                                  if (loginController
                                              .profileData.value.dateOfBirth !=
                                          "" &&
                                      loginController
                                              .profileData.value.dateOfBirth !=
                                          null) {
                                    splitted = loginController
                                        .profileData.value.dateOfBirth
                                        .toString()
                                        .split('-');
                                  } else {
                                    splitted =
                                        '2000/12/31'.toString().split('/');
                                  }

                                  print(splitted);
                                  final dob =
                                      '${splitted[0]}-${splitted[1]}-${splitted[2]}';
                                  DatePicker.showDatePicker(
                                    context,
                                    pickerTheme: DateTimePickerTheme(
                                      confirm: Text(
                                        'Update'.tr,
                                        style: AppStyles.kFontPink15w5,
                                      ),
                                      cancel: Text(
                                        'Cancel'.tr,
                                        style: AppStyles.kFontBlack14w5,
                                      ),
                                    ),
                                    minDateTime: DateTime.parse(initDateTime),
                                    maxDateTime: DateTime.parse(maxDateTime),
                                    initialDateTime: DateTime.parse(dob),
                                    dateFormat: _format,
                                    locale: _locale,
                                    onClose: () => print("----- onClose -----"),
                                    onCancel: () => print('onCancel'),
                                    onChange: (dateTime, List<int> index) {
                                      setState(() {
                                        _dateTime = dateTime;
                                      });
                                    },
                                    onConfirm:
                                        (dateTime, List<int> index) async {
                                      setState(() {
                                        _dateTime = dateTime;
                                        toDate =
                                            '${_dateTime.year}-${getAbsoluteDate(_dateTime.month)}-${getAbsoluteDate(_dateTime.day)}';
                                        print(toDate);

                                        dobCtrl.text = toDate;
                                      });
                                    },
                                  );
                                },
                                child: TextFormField(
                                  controller: dobCtrl,
                                  enabled: false,
                                  keyboardType: TextInputType.text,
                                  decoration: CustomInputDecoration()
                                      .underlineDecoration(
                                          label: "Date of Birth")
                                      .copyWith(
                                          disabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppStyles.pinkColor,
                                        ),
                                      )),
                                  style: AppStyles.appFontBook.copyWith(
                                    fontSize: 16,
                                  ),
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return 'Please Type Date of Birth'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: descriptionCtrl,
                                keyboardType: TextInputType.text,
                                maxLines: 3,
                                decoration: CustomInputDecoration()
                                    .underlineDecoration(label: "Description"),
                                style: AppStyles.appFontBook.copyWith(
                                  fontSize: 16,
                                ),
                                validator: (value) {
                                  if (value.length == 0) {
                                    return 'Please Type Description'.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              PinkButtonWidget(
                                width: Get.width,
                                height: 50,
                                btnText: "Submit".tr,
                                btnOnTap: () async {
                                  if (AppConfig.isDemo) {
                                    SnackBars()
                                        .snackBarWarning("Disabled in demo");
                                  } else {
                                    if (_formKey.currentState.validate()) {
                                      Map data = {
                                        "first_name": firstNameCtrl.text,
                                        "last_name": lastNameCtrl.text,
                                        "email": emailCtrl.text,
                                        "phone": phoneNumberCtrl.text,
                                        "date_of_birth": dobCtrl.text,
                                        "description": descriptionCtrl.text,
                                      };
                                      await updateProfile(data)
                                          .then((value) async {
                                        if (value) {
                                          SnackBars().snackBarSuccess(
                                              'profile updated successfully');
                                          await loginController
                                              .getProfileData();
                                        }
                                      });
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
