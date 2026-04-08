import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker/core/res/app_assets.dart';
import 'package:personal_expense_tracker/core/res/app_colors.dart';
import 'package:personal_expense_tracker/core/res/app_strings.dart';
import 'package:personal_expense_tracker/routes/app_routes.dart';
import 'package:personal_expense_tracker/views/authentication/sign_up/controller/sign_up_controller.dart';

class SignUpActivity extends GetView<SignUpController> {
  const SignUpActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .center,
                mainAxisAlignment: .center,
                children: [
                  Image.asset(
                    AppAssets.appLogo,
                    height: 64,
                    width: 64,
                  ),
                  const SizedBox(height: 8),
                  Text(
                      AppStrings.appName,
                      textAlign: .center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700
                      )
                  ),
                  const SizedBox(height: 4,),
                  Text(
                      AppStrings.appSubtitle,
                      textAlign: .center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withValues(alpha: 0.4)
                      )
                  ),
                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsetsGeometry.directional(start: 20, end: 20),
                    child: Form(
                      key: controller.signUpFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: controller.nameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: AppStrings.nameFieldLabel,
                                hintText: AppStrings.nameFieldHint,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.4))
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.4))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: AppColors.primaryColor)
                                )
                            ),
                            validator: (value){

                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: AppStrings.emailFieldLabel,
                                hintText: AppStrings.emailFieldHint,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.4))
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.4))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: AppColors.primaryColor)
                                )
                            ),
                            validator: (value){

                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            obscureText: true,
                            controller: controller.passwordController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                labelText: AppStrings.passwordFieldLabel,
                                hintText: AppStrings.passwordFieldHint,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.4))
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.4))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: AppColors.primaryColor)
                                ),
                                suffixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.visibility))
                            ),
                            validator: (value){

                            },
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            obscureText: true,
                            controller: controller.confirmPasswordController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                labelText: AppStrings.confirmPasswordFieldLabel,
                                hintText: AppStrings.confirmPasswordFieldHint,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.4))
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.4))
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: AppColors.primaryColor)
                                ),
                                suffixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.visibility))
                            ),
                            validator: (value){

                            },
                          ),
                          const SizedBox(height: 20),

                          ElevatedButton(
                              onPressed: (){},
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
                                  backgroundColor: AppColors.primaryColor,
                                  fixedSize: Size(MediaQuery.of(context).size.width, 48)
                              ),
                              child: Text(
                                AppStrings.signUpButtonText,
                                textAlign: .center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        AppStrings.alreadyAccount,
                        textAlign: .center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withValues(alpha: 0.4)
                        ),
                      ),
                      const SizedBox(width: 8),

                      InkWell(
                        onTap: () => Get.offNamed(AppRoutes.signInActivity),
                        child: Text(
                          AppStrings.signInButtonText,
                          textAlign: .center,
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: .underline,
                              decorationColor: AppColors.primaryColor,
                              decorationStyle: TextDecorationStyle.dotted
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
