import 'package:get/get.dart';
import 'package:personal_expense_tracker/views/bottom_navigation/insights/controller/insights_controller.dart';

class InsightsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => InsightsController());
  }
}