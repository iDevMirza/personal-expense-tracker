import 'package:get/get.dart';
import 'package:personal_expense_tracker/app/core/services/theme_service.dart';
import 'package:personal_expense_tracker/app/data/services/auth_service.dart';
import 'package:personal_expense_tracker/app/data/services/expense_service.dart';
import 'package:personal_expense_tracker/app/data/services/location_service.dart';

class InjectDependency {

  static Future<void> init() async{
    await Get.putAsync(() => ThemeService().init());
    Get.put(AuthService(), permanent: true);
    Get.put(ExpenseService(), permanent: true);
    Get.put(LocationService(), permanent: true);
  }
}