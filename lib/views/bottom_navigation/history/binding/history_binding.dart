import 'package:get/get.dart';
import 'package:personal_expense_tracker/views/bottom_navigation/history/controller/history_controller.dart';

class HistoryBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => HistoryController());
  }
}