import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/controller/login_controller.dart';
import 'package:amazy_app/utils/styles.dart';
import 'package:amazy_app/view/cart/CartMain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartIconWidget extends StatelessWidget {
  final Color color;
  final bool isSliver;
  CartIconWidget({
    this.color = Colors.black,
    this.isSliver = true,
  });
  final CartController cartController = Get.put(CartController());
  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CartMain(true, true));
      },
      child: Container(
        width: 50,
        height: 50,
        padding: EdgeInsets.only(right: 2),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/icon_cart_grey.png',
                width: 30,
                height: 30,
                color: isSliver ? Colors.white : AppStyles.pinkColor,
              ),
            ),
            _loginController.loggedIn.value
                ? Positioned(
                    right: 2,
                    top: 2,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isSliver ? Colors.white : AppStyles.pinkColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Obx(() {
                          if (cartController.isLoading.value) {
                            return Container();
                          }
                          return Text(
                            '${cartController.cartListSelectedCount.value}',
                            textAlign: TextAlign.center,
                            style: AppStyles.appFontLight.copyWith(
                              fontSize: 10,
                              color: isSliver ? Colors.black : Colors.white,
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
