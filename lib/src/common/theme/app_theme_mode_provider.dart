import 'package:flutter/material.dart';
import 'package:pulse_rate_monitor/src/common/shared_preferences/shared_preference_manager.dart';
import 'package:pulse_rate_monitor/src/common/shared_preferences/shared_preferences_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_theme_mode_provider.g.dart';

@Riverpod(keepAlive: true)

/// Manages storing and switching current theme
class AppThemeMode extends _$AppThemeMode {
  /// initial theme of the app
  @override
  ThemeMode build() {
    /// current theme of the app
    final currentTheme = SharedPreferenceManager.instance.getString(
      SharedPrefConstants.apptheme,
    );

    return currentTheme == 'light'
        ? ThemeMode.light
        : currentTheme == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;
  }

  /// switch the current [AppThemeMode] with [themeMode]
  Future<void> changeTheme(ThemeMode themeMode) async {
    /// changing the theme [state] to [themeMode] passed via parameter
    state = themeMode;

    /// storing the theme to shared preference
    await SharedPreferenceManager.instance.setString(
      SharedPrefConstants.apptheme,
      themeMode.toString(),
    );
  }
}
