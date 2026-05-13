import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Start managing your money smarter',
                  style: TextStyle(color: Theme.of(context).hintColor)),
              const SizedBox(height: 32),

              const Text('Username', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.usernameCtrl,
                decoration: const InputDecoration(hintText: 'Enter your username'),
              ),
              const SizedBox(height: 16),

              const Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'Enter your email'),
              ),
              const SizedBox(height: 16),

              const Row(
                mainAxisAlignment: .start,
                children: [
                  Text('Password', style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Tooltip(
                    message: 'Password must be at least 6 characters',
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: Duration(seconds: 3),
                    waitDuration: Duration.zero,
                    child: Icon(
                      Icons.info_outline,
                      size: 20,
                      color: AppColors.error,
                    ),
                  )
                ],
              ),
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
                  onPressed: controller.isLoading.value ? null : controller.register,
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Create Account',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}