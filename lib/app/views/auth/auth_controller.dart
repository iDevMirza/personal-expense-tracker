import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _auth = Get.find();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();

  final isLoading = false.obs;
  final obscurePassword = true.obs;

  bool _validEmail(String e) =>
      RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(e);

  Future<void> login() async {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      _snack('Error', 'Please fill all fields');
      return;
    }
    if (!_validEmail(emailCtrl.text.trim())) {
      _snack('Error', 'Enter a valid email');
      return;
    }
    try {
      isLoading.value = true;
      await _auth.login(emailCtrl.text.trim(), passwordCtrl.text);
      Get.offAllNamed(Routes.main);
    } catch (e) {
      _snack('Login failed', _friendlyError(e));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (emailCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty ||
        usernameCtrl.text.isEmpty) {
      _snack('Error', 'Please fill all fields');
      return;
    }
    if (!_validEmail(emailCtrl.text.trim())) {
      _snack('Error', 'Enter a valid email');
      return;
    }
    if (passwordCtrl.text.length < 6) {
      _snack('Error', 'Password must be at least 6 characters');
      return;
    }
    try {
      isLoading.value = true;
      await _auth.register(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text,
        username: usernameCtrl.text.trim(),
      );
      Get.offAllNamed(Routes.main);
    } catch (e) {
      _snack('Registration failed', _friendlyError(e));
    } finally {
      isLoading.value = false;
    }
  }

  String _friendlyError(Object e) {
    final s = e.toString();
    if (s.contains('user-not-found')) return 'No account found with this email';
    if (s.contains('wrong-password')) return 'Incorrect password';
    if (s.contains('email-already-in-use')) return 'Email already registered';
    if (s.contains('weak-password')) return 'Password is too weak';
    if (s.contains('network')) return 'Check your internet connection';
    return 'Something went wrong. Please try again.';
  }

  void _snack(String title, String msg) {
    Get.snackbar(title, msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900);
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    usernameCtrl.dispose();
    super.onClose();
  }
}