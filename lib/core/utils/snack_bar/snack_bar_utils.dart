import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/enums/snack_bar_type.dart';
import 'package:personal_expense_tracker/core/extensions/context_extension.dart';
import 'package:personal_expense_tracker/core/extensions/snack_bar_extension.dart';

class SnackBarUtils {
  static void show(BuildContext context, {
    required SnackBarType type,
    required String message
  }){
    switch(type) {
      case SnackBarType.SUCCESS:
        _successSnackBar(context, type: type, msg: message);
      case SnackBarType.ERROR:
        _errorSnackBar(context, type: type, msg: message);
      case SnackBarType.WARNING:
        _warningSnackBar(context, type: type, msg: message);
    }
  }

  static void _successSnackBar(BuildContext context, {required SnackBarType type, required String msg}) {
    context.smSate.showSnackBar(SnackBar(
        padding: const .symmetric(vertical: 20, horizontal: 16),
        backgroundColor: type.bgColor,
        content: _snackBarContent(type: type, msg: msg)
    ));
  }
  static void _errorSnackBar(BuildContext context, {required SnackBarType type, required String msg}) {
    context.smSate.showSnackBar(SnackBar(
        padding: const .symmetric(vertical: 20, horizontal: 16),
        backgroundColor: type.bgColor,
        content: _snackBarContent(type: type, msg: msg)
    ));
  }
  static void _warningSnackBar(BuildContext context, {required SnackBarType type, required String msg}) {
    context.smSate.showSnackBar(SnackBar(
        padding: const .symmetric(vertical: 20, horizontal: 16),
        backgroundColor: type.bgColor,
        content: _snackBarContent(type: type, msg: msg)
    ));
  }

  static Widget _snackBarContent({required SnackBarType type, required String msg}){
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Icon(type.icon, color: type.fgColor, size: 18,),
            const SizedBox(width: 4),
            Text(type.title, style: TextStyle(
              color: type.fgColor,
              fontSize: 14,
              fontWeight: FontWeight.w700
            ))
          ],
        ),
        const SizedBox(height: 8),

        Text(
          msg,
          style: TextStyle(
            color: type.fgColor,
            fontSize: 18,
            fontWeight: FontWeight.w700
          ),
        )
      ],
    );
  }
}