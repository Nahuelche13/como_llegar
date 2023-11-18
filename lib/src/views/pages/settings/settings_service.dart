import "package:como_llegar/keys.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    final instance = await SharedPreferences.getInstance();
    return switch (instance.getString("themeMode")) {
      "light" => ThemeMode.light,
      "dark" => ThemeMode.dark,
      _ => ThemeMode.system
    };
  }

  Future<String> mapMode() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString("mapMode") ?? maps.keys.first;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(final ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    final instance = await SharedPreferences.getInstance();
    final themeString = switch (theme) {
      ThemeMode.light => "light",
      ThemeMode.dark => "dark",
      _ => "system",
    };
    await instance.setString("themeMode", themeString);
  }

  Future<void> updateMapMode(final String provider) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString("mapMode", provider);
  }
}
