import 'package:amazy_app/utils/styles.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StarCounterWidget extends StatelessWidget {
  final double value;
  final double size;
  Color color = AppStyles.pinkColor;

  StarCounterWidget({
    Key key,
    this.value = 0,
    this.size = 8,
    this.color,
  })  : assert(value != null),
        super(key: key);

  // Widget buildStar(BuildContext context, int index) {
  //   Icon icon;
  //   if (index >= value) {
  //     icon = new Icon(
  //       Icons.star_border_rounded,
  //       color: this.color,
  //       size: this.size,
  //     );
  //   } else if (index > value - 1 && index < value) {
  //     icon = new Icon(
  //       Icons.star_half,
  //       color: this.color,
  //       size: this.size,
  //     );
  //   } else {
  //     icon = new Icon(
  //       Icons.star_rounded,
  //       color: this.color,
  //       size: this.size,
  //     );
  //   }
  //   return Ink(
  //     child: icon,
  //   );
  // }

  Widget buildStar(BuildContext context, int index) {
    Image icon;
    if (index >= value) {
      icon = new Image.asset(
        "assets/images/star_blank.png",
        color: this.color,
        height: this.size,
        width: this.size,
      );
    } else if (index > value - 1 && index < value) {
      icon = new Image.asset(
        "assets/images/star_blank.png",
        color: this.color,
        height: this.size,
        width: this.size,
      );
    } else {
      icon = new Image.asset(
        "assets/images/star.png",
        color: this.color,
        height: this.size,
        width: this.size,
      );
    }
    return Ink(
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 0,
      runSpacing: 0,
      children: List.generate(5, (index) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: buildStar(context, index));
      }),
    );
  }
}
