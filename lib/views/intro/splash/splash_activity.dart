import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker/core/res/app_assets.dart';
import 'package:personal_expense_tracker/core/res/app_strings.dart';
import 'package:personal_expense_tracker/views/intro/splash/controller/splash_controller.dart';

class SplashActivity extends GetView<SplashController> {
  const SplashActivity({super.key});

  @override
  Widget build(BuildContext context) {
    controller.navigateTo();
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: .center,
            mainAxisAlignment: .center,
            children: [
              Image.asset(
                AppAssets.appLogo,
                height: 96,
                width: 96,
              ),
              const SizedBox(height: 12),
              Text(AppStrings.appName, textAlign: .center, style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700
              ))
            ],
          ),
        ),
      ),
    );
  }
}
