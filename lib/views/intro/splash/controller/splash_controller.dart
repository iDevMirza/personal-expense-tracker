import 'dart:async';

import 'package:get/get.dart';
import 'package:personal_expense_tracker/routes/app_routes.dart';

class SplashController extends GetxController {
  void navigateTo() async{
    Timer(const Duration(seconds: 4), (){
      Get.offNamed(AppRoutes.signInActivity);
    });
  }
}