import 'package:get/get.dart';
import 'package:personal_expense_tracker/views/bottom_navigation/add/controller/add_controller.dart';

class AddBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => AddController());
  }
}