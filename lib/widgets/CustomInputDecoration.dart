import 'package:amazy_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomInputDecoration {
  static InputDecoration customInput = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    hintStyle: ThemeData.light().textTheme.headlineMedium.copyWith(
          fontSize: 12,
          color: Colors.black38,
        ),
    disabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(45, 253, 73, 73), width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(45, 253, 73, 73), width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Color.fromARGB(45, 253, 73, 73), width: 1.5),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );

  InputDecoration underlineDecoration({String label}) {
    return InputDecoration(
      labelText: '$label'.tr.toUpperCase(),
      labelStyle: AppStyles.appFontBook.copyWith(
        fontSize: 10,
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppStyles.pinkColor,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppStyles.pinkColor,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: AppStyles.pinkColor,
        ),
      ),
    );
  }
}
