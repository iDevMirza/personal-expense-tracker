import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker/core/res/app_strings.dart';
import 'package:personal_expense_tracker/routes/app_pages.dart';
import 'package:personal_expense_tracker/routes/app_routes.dart';
import 'package:personal_expense_tracker/views/intro/splash/binding/splash_binding.dart';

class PersonalExpenseTracker extends StatelessWidget {
  const PersonalExpenseTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      initialRoute: AppRoutes.splashActivity,
      initialBinding: SplashBinding(),
      getPages: AppPages.routes,
    );
  }
}
