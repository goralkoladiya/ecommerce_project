import 'package:amazy_app/utils/styles.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  ButtonWidget({this.buttonText, this.onTap, this.padding});
  final String buttonText;
  final VoidCallback onTap;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: padding,
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
              gradient: AppStyles.gradient,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Text(
            buttonText,
            style: AppStyles.appFontBook.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
