import 'package:get/get.dart';
import 'package:personal_expense_tracker/routes/app_routes.dart';
import 'package:personal_expense_tracker/views/authentication/sign_in/binding/sign_in_binding.dart';
import 'package:personal_expense_tracker/views/authentication/sign_in/sign_in_activity.dart';
import 'package:personal_expense_tracker/views/authentication/sign_up/binding/sign_up_binding.dart';
import 'package:personal_expense_tracker/views/authentication/sign_up/sign_up_activity.dart';
import 'package:personal_expense_tracker/views/bottom_navigation/add/add_activity.dart';
import 'package:personal_expense_tracker/views/bottom_navigation/history/history_activity.dart';
import 'package:personal_expense_tracker/views/bottom_navigation/home/home_activity.dart';
import 'package:personal_expense_tracker/views/bottom_navigation/insights/insights_activity.dart';
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
    ),

    GetPage(
        name: AppRoutes.homeActivity,
        page: () => HomeActivity(),
        // binding: SignUpBinding()
    ),

    GetPage(
        name: AppRoutes.addActivity,
        page: () => AddActivity(),
        // binding: SignUpBinding()
    ),

    GetPage(
        name: AppRoutes.historyActivity,
        page: () => HistoryActivity(),
        // binding: SignUpBinding()
    ),

    GetPage(
        name: AppRoutes.insightsActivity,
        page: () => InsightsActivity(),
        // binding: SignUpBinding()
    )
  ];
}