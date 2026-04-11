import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker/core/data/repositories/auth_repository.dart';
import 'package:personal_expense_tracker/core/enums/snack_bar_type.dart';
import 'package:personal_expense_tracker/core/utils/snack_bar/snack_bar_utils.dart';
import 'package:personal_expense_tracker/routes/app_routes.dart';

class SignUpController extends GetxController{
  final signUpFormKey = GlobalKey<FormState>();

  late AuthRepository _authRepository;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  Rx<bool> isLoading = false.obs;
  Rx<bool> isObscurePassword = true.obs;
  Rx<bool> isObscureConfirmPassword = true.obs;

  void checkPasswordVisibility(){
    isObscurePassword.value = !isObscurePassword.value;
  }

  void checkConfirmPasswordVisibility(){
    isObscureConfirmPassword.value = !isObscureConfirmPassword.value;
  }

  Future<void> signUpUser() async{
    isLoading.value = true;

    try{
      final user = await _authRepository.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: confirmPasswordController.text.trim(),
      );

      if (user == null) {
        SnackBarUtils.show(
            Get.context!,
            type: SnackBarType.ERROR,
            message: 'Email already exists!'
        );
        return;
      }

      SnackBarUtils.show(
          Get.context!,
          type: SnackBarType.SUCCESS,
          message: 'Account created successfully!'
      );
      clearData();
      Get.offAllNamed(AppRoutes.signInActivity);
    } catch (e){
      SnackBarUtils.show(
          Get.context!,
          type: SnackBarType.ERROR,
          message: 'Something went wrong. Try again!'
      );
      clearData();
    } finally {
      isLoading.value = false;
      clearData();
    }
  }

  void clearData(){
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onInit() {
    _authRepository = AuthRepository();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}