import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/extensions/context_extension.dart';

class CustomModalBottomSheet {
  static void show(BuildContext context, {required Widget bottomSheetContent}) => showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20))
      ),
      context: context,
      builder: (context) => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: context.sizeContext.width,
          padding: .symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: .circular(20),
          ),
          child: bottomSheetContent,
        ),
      )
  );
}