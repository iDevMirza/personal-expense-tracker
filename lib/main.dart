import 'package:flutter/material.dart';
import 'package:personal_expense_tracker/config/app/app_config.dart';
import 'package:personal_expense_tracker/personal_expense_tracker.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig config = AppConfig.instance;
  await config.initialize();

  runApp(const PersonalExpenseTracker());
}