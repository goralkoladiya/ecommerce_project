import 'package:amazy_app/controller/cart_controller.dart';
import 'package:amazy_app/controller/home_controller.dart';
import 'package:amazy_app/controller/login_controller.dart';
import 'package:amazy_app/controller/settings_controller.dart';
import 'package:get/get.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeneralSettingsController>(() => GeneralSettingsController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<CartController>(() => CartController());
  }
}
