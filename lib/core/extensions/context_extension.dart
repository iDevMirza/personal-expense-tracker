import 'package:flutter/widgets.dart';

extension ContextExtension on BuildContext{
  Size get sizeContext => MediaQuery.of(this).size;
}