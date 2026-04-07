import 'package:get/get.dart';
import 'package:personal_expense_tracker/views/authentication/sign_in/controller/sign_in_controller.dart';
import 'package:personal_expense_tracker/views/authentication/sign_up/controller/sign_up_controller.dart';

class SignUpBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}