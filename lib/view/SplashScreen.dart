import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/widgets/animate_widget/elasticIn.dart';
import 'package:amazy_app/AppConfig/app_config.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('${AppConfig.loginBackgroundImage}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElasticIn(
                    manualTrigger: false,
                    animate: true,
                    infinite: true,
                    child: Image.asset(
                      "${AppConfig.appLogo}",
                      color: Colors.white,
                      height: 100,
                      width: 300,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Text(
                  //   "${AppConfig.appName}",
                  //   style: AppStyles.appFontBold.copyWith(
                  //     color: Colors.white,
                  //     fontSize: 20,
                  //   ),
                  // ),
                ],
              ),
            ),
            Positioned.fill(
              bottom: 50,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "${AppConfig.appName} Ecommerce Platform",
                  style: AppStyles.appFontBook.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//   return CustomSplash(
//     imagePath: '${AppConfig.splashScreenLogo}',
//     animationEffect: 'elastic-in',
//     logoSize: 60,
//     home: SplashScreen(),
//     duration: 20000,
//     bgPath: AppConfig.loginBackgroundImage,
//     type: CustomSplashType.StaticDuration,
//   );
// }
}