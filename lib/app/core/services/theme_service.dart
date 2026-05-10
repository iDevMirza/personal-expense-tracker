import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends GetxService {
  static const _key = 'isDarkMode';
  final isDark = false.obs;

  Future<ThemeService> init() async {
    final prefs = await SharedPreferences.getInstance();
    isDark.value = prefs.getBool(_key) ?? false;
    return this;
  }

  ThemeMode get themeMode => isDark.value ? ThemeMode.dark : ThemeMode.light;

  Future<void> toggle() async {
    isDark.value = !isDark.value;
    Get.changeThemeMode(themeMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isDark.value);
  }
}