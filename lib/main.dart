import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_expense_tracker/app/core/dependency/inject_dependency.dart';
import 'package:personal_expense_tracker/personal_expense_tracker.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await InjectDependency.init();
  runApp(const PersonalExpenseTracker());
}