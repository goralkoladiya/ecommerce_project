import 'package:amazy_app/utils/styles.dart';
import 'package:flutter/material.dart';

class PinkButtonWidget extends StatelessWidget {
  final String btnText;
  final double width;
  final double height;
  final VoidCallback btnOnTap;

  PinkButtonWidget({this.width, this.height, this.btnOnTap, this.btnText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnOnTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: AppStyles.gradient,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 10,
          ),
          child: Text(
            btnText,
            textAlign: TextAlign.center,
            style: AppStyles.appFontMedium.copyWith(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
