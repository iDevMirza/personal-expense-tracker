import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker/app/views/home/main_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    final auth = Get.find<AuthService>();
    if (auth.currentUser != null) {
      if (!Get.isRegistered<MainController>()) {
        Get.put(MainController(), permanent: true);
      }
      Get.offAllNamed(Routes.main);
    } else {
      Get.offAllNamed(Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.account_balance_wallet,
                    color: AppColors.primary, size: 56),
              ),
              const SizedBox(height: 24),
              const Text('Personal Expense Tracker',
                  textAlign: .center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 32),
              const SizedBox(
                height: 24, width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              ),
            ],
          ),
        ),
      ),
    );
  }
}