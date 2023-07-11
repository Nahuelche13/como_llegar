import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../keys.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return {
          "light": ThemeMode.light,
          "dark": ThemeMode.dark
        }[instance.getString("themeMode")] ??
        ThemeMode.system;
  }

  Future<String> mapMode() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    return instance.getString("mapMode") ?? maps.keys.first;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    SharedPreferences instance = await SharedPreferences.getInstance();
    String themeString =
        {ThemeMode.light: "light", ThemeMode.dark: "dark"}[theme] ?? "system";
    instance.setString("themeMode", themeString);
  }

  Future<void> updateMapMode(String provider) async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString("mapMode", provider);
  }
}
