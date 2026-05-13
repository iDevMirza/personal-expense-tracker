import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';
import 'auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                margin: const EdgeInsetsDirectional.only(top: 56),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.account_balance_wallet,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(height: 24),
              const Text('Welcome Back',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Sign in to continue tracking your expenses',
                  style: TextStyle(color: Theme.of(context).hintColor)),
              const SizedBox(height: 32),

              const Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter your email'),
              ),
              const SizedBox(height: 16),

              const Text('Password', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Obx(() => TextField(
                controller: controller.passwordCtrl,
                obscureText: controller.obscurePassword.value,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    icon: Icon(controller.obscurePassword.value
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => controller.obscurePassword.toggle(),
                  ),
                ),
              )),
              const SizedBox(height: 32),
              Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: controller.isLoading.value ? null : controller.login,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign In',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              )),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => Get.toNamed(Routes.register),
                  child: const Text.rich(TextSpan(
                    text: "Don't have an account? ",
                    children: [
                      TextSpan(
                          text: 'Sign Up',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}