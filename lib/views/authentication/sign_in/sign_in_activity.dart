import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:personal_expense_tracker/core/res/app_assets.dart';
import 'package:personal_expense_tracker/core/res/app_colors.dart';
import 'package:personal_expense_tracker/core/res/app_strings.dart';
import 'package:personal_expense_tracker/core/utils/validation/validation_utils.dart';
import 'package:personal_expense_tracker/routes/app_routes.dart';
import 'package:personal_expense_tracker/views/authentication/sign_in/controller/sign_in_controller.dart';

class SignInActivity extends GetView<SignInController> {
  const SignInActivity({super.key});

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
                  const Text(
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
                      key: controller.signInFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  borderSide: const BorderSide(color: AppColors.primaryColor)
                              )
                            ),
                            validator: ValidationUtils.emailValidation,
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            obscureText: true,
                            controller: controller.passwordController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
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
                                    borderSide: const BorderSide(color: AppColors.primaryColor)
                                ),
                              suffixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.visibility))
                            ),
                            validator: ValidationUtils.passwordValidation,
                          ),
                          const SizedBox(height: 24),

                          ElevatedButton(
                              onPressed: (){
                                if(controller.signInFormKey.currentState!.validate()){
                                  Get.offAllNamed(AppRoutes.homeActivity);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
                                backgroundColor: AppColors.primaryColor,
                                fixedSize: Size(MediaQuery.of(context).size.width, 48)
                              ),
                              child: const Text(
                                AppStrings.signInButtonText,
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
                        AppStrings.doNotHaveAccount,
                        textAlign: .center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withValues(alpha: 0.4)
                        ),
                      ),
                      const SizedBox(width: 8),

                      InkWell(
                        onTap: () => Get.offNamed(AppRoutes.signUpActivity),
                        child: const Text(
                          AppStrings.signUpButtonText,
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
