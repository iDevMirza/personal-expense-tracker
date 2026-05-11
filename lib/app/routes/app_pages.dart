import 'package:get/get.dart';
import '../views/splash/splash_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/registration_view.dart';
import '../views/auth/auth_binding.dart';
import '../views/home/main_view.dart';
import '../views/home/main_binding.dart';
import '../views/add_expense/add_expense_view.dart';
import '../views/add_expense/add_expense_binding.dart';
import '../views/add_expense/location_picker_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.splash, page: () => const SplashView()),
    GetPage(name: Routes.login, page: () => const LoginView(), binding: AuthBinding()),
    GetPage(name: Routes.register, page: () => const RegisterView(), binding: AuthBinding()),
    GetPage(name: Routes.main, page: () => const MainView(), binding: MainBinding()),
    GetPage(name: Routes.addExpense, page: () => const AddExpenseView(), binding: AddExpenseBinding()),
    GetPage(name: Routes.locationPicker, page: () => const LocationPickerView()),
  ];
}