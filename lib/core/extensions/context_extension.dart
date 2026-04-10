import 'package:flutter/material.dart';

extension ContextExtension on BuildContext{
  ScaffoldMessengerState get smSate => ScaffoldMessenger.of(this);
  Size get sizeContext => MediaQuery.of(this).size;
}