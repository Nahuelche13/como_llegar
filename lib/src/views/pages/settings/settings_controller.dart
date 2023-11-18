import "package:como_llegar/src/views/pages/settings/settings_service.dart";
import "package:flutter/material.dart";

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  static SettingsController controller = SettingsController();

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService = SettingsService();
  SettingsService get settingsService => _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;
  late String _mapMode;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;
  String get mapMode => _mapMode;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _mapMode = await _settingsService.mapMode();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(final ThemeMode? newThemeMode) async {
    if (newThemeMode == null) {
      return;
    }

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) {
      return;
    }

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateMapMode(final String? newMapMode) async {
    if (newMapMode == null) {
      return;
    }

    // Do not perform any work if new and old ThemeMode are identical
    if (newMapMode == _mapMode) {
      return;
    }

    // Otherwise, store the new ThemeMode in memory
    _mapMode = newMapMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateMapMode(newMapMode);
  }
}
