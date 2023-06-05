import 'package:amazy_app/utils/styles.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutTimelineLineWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: DottedLine(
          direction: Axis.horizontal,
          lineLength: double.infinity,
          lineThickness: 1.5,
          dashColor: Color(0xffE1E1E2),
          dashRadius: 0.0,
          dashGapLength: 0.0,
        ),
      ),
    );
  }
}

class CheckoutTimelineWidget extends StatelessWidget {
  final bool isActive;
  final String text;

  CheckoutTimelineWidget({this.isActive, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          isActive ? "assets/images/check.png" : "assets/images/uncheck.png",
          width: 25,
          height: 25,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          '$text'.tr,
          style: AppStyles.appFontMedium.copyWith(
            fontSize: 16,
            color: isActive ? Colors.black : Color(0xffE1E1E2),
          ),
        ),
      ],
    );
  }
}