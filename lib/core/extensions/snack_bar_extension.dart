import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/core/enums/snack_bar_type.dart';

extension SnackBarExtension on SnackBarType{
  String get title {
    switch(this){
      case SnackBarType.SUCCESS:
        return 'Success';
      case SnackBarType.ERROR:
        return 'Error';
      case SnackBarType.WARNING:
        return 'Warning';
    }
  }

  IconData get icon {
    switch(this){
      case SnackBarType.SUCCESS:
        return Icons.check_circle_outline_rounded;
      case SnackBarType.ERROR:
        return Icons.error_outline_rounded;
      case SnackBarType.WARNING:
        return Icons.warning_amber_rounded;
    }
  }

  Color get bgColor {
    switch(this){
      case SnackBarType.SUCCESS:
        return Colors.green;
      case SnackBarType.ERROR:
        return Colors.red;
      case SnackBarType.WARNING:
        return Colors.amber;
    }
  }

  Color get fgColor {
    switch(this){
      case SnackBarType.SUCCESS:
      case SnackBarType.ERROR:
        return Colors.white;
      case SnackBarType.WARNING:
        return Colors.black;
    }
  }
}