import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker/app/core/services/theme_service.dart';
import 'package:personal_expense_tracker/app/core/theme/app_theme.dart';
import 'package:personal_expense_tracker/app/routes/app_pages.dart';
import 'package:personal_expense_tracker/app/routes/app_routes.dart';

class PersonalExpenseTracker extends StatelessWidget {
  const PersonalExpenseTracker({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Obx(() => GetMaterialApp(
      title: 'Personal Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeService.themeMode,
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
    ));
  }
}