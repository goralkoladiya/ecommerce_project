import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:amazy_app/widgets/animate_widget/elasticIn.dart';
import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatefulWidget {
  const CustomLoadingWidget({Key key}) : super(key: key);

  @override
  _CustomLoadingWidgetState createState() => _CustomLoadingWidgetState();
}

class _CustomLoadingWidgetState extends State<CustomLoadingWidget>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElasticIn(
      manualTrigger: false,
      animate: true,
      infinite: true,
      child: Container(
        child: Image.asset(
          AppConfig.appLogo,
          width: 30,
          height: 30,
        ),
      ),
    );
  }
}
