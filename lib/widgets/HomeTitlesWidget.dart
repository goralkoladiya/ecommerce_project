import 'package:amazy_app/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';

class HomeTitlesWidget extends StatelessWidget {
  final VoidCallback btnOnTap;
  final String title;
  final bool showDeal;
  final Duration dealDuration;
  final int endTime;

  HomeTitlesWidget({
    this.btnOnTap,
    this.title,
    this.showDeal,
    this.dealDuration,
    this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 20),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: btnOnTap,
            child: Row(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppStyles.appFontBold.copyWith(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                showDeal
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            gradient: AppStyles.gradient,
                            borderRadius: BorderRadius.circular(5)),
                        child: CountdownTimer(
                          endTime: endTime,
                          widgetBuilder: (_, CurrentRemainingTime time) {
                            return Text(
                              '${time.days}d-${time.hours}h-${time.min}m-${time.sec}s',
                              style: AppStyles.appFontLight.copyWith(
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox.shrink(),
                Spacer(),
                Row(
                  children: [
                    Text(
                      'Show All'.tr,
                      textAlign: TextAlign.center,
                      style: AppStyles.appFontLight
                          .copyWith(color: AppStyles.pinkColor, fontSize: 12),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppStyles.pinkColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
