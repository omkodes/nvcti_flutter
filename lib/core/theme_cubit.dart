import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String themeKey = "isDarkMode";

  ThemeCubit() : super(ThemeMode.light) {
    loadTheme();
  }

  void toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isDark);

    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(themeKey) ?? false;

    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}