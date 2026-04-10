import 'package:get/get.dart';
import 'package:personal_expense_tracker/views/bottom_navigation/home/controller/home_controller.dart';

class HomeBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}