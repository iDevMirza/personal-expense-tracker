import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/res/app_colors.dart';

class CustomLoadingButton extends StatelessWidget {
  const CustomLoadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){

        },
        style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
            backgroundColor: AppColors.primaryColor,
            fixedSize: Size(MediaQuery.of(context).size.width, 48)
        ),
        child: const SizedBox(
          height: 20, width: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
    );
  }
}
