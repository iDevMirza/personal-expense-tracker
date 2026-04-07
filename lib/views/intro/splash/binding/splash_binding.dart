import 'package:get/get.dart';
import 'package:personal_expense_tracker/views/intro/splash/controller/splash_controller.dart';

class SplashBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => SplashController());
  }
}