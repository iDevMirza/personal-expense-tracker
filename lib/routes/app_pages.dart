import 'package:get/get.dart';
import 'package:personal_expense_tracker/routes/app_routes.dart';
import 'package:personal_expense_tracker/views/authentication/sign_in/binding/sign_in_binding.dart';
import 'package:personal_expense_tracker/views/authentication/sign_in/sign_in_activity.dart';
import 'package:personal_expense_tracker/views/authentication/sign_up/binding/sign_up_binding.dart';
import 'package:personal_expense_tracker/views/authentication/sign_up/sign_up_activity.dart';
import 'package:personal_expense_tracker/views/intro/splash/binding/splash_binding.dart';
import 'package:personal_expense_tracker/views/intro/splash/splash_activity.dart';

class AppPages {

  static final routes = [
    GetPage(
        name: AppRoutes.splashActivity,
        page: () => SplashActivity(),
        binding: SplashBinding()
    ),

    GetPage(
        name: AppRoutes.signInActivity,
        page: () => SignInActivity(),
        binding: SignInBinding()
    ),

    GetPage(
        name: AppRoutes.signUpActivity,
        page: () => SignUpActivity(),
        binding: SignUpBinding()
    )
  ];
}