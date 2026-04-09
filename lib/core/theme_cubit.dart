import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String themeKey = "theme_mode_preference";

  ThemeCubit() : super(ThemeMode.light) {
    loadTheme();
  }

  void updateTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      themeKey,
      mode.name,
    ); // Saves 'system', 'light', or 'dark'
    emit(mode);
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(themeKey) ?? ThemeMode.system.name;

    final mode = ThemeMode.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => ThemeMode.system,
    );
    emit(mode);
  }
}
